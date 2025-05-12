//
//  temp8.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct RewardMessageView: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    @State private var messages: [Message] = []
    @State private var 獎勵是否領取: Bool = false
    @State private var 提問是否存在: Bool = true
    
    struct Message: Identifiable {
        var id: String
        var category: String
        var point: Int
        var deadline: Timestamp
        var timestamp: Timestamp
        var title: String
        var content: String
        var isOver: Bool = false
        var issueExist: Bool = true
    }
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                Spacer()
                Text(name)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .opacity(0)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 30)
            .background(Color.white)
            ScrollView {
                ForEach(groupMessagesByDate(messages), id: \.key) { date, msgs in
                    UITextMessageDate(date: date)
                    
                    ForEach(msgs) { msg in
                        UIComplexReward(
                            point: msg.point,
                            title: msg.title,
                            content: msg.content,
                            issueExist: msg.issueExist,
                            rewardExist: .constant(msg.isOver)
                        )
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadMessages()
            observeBadgeCount()
        }
    }
    
    private func loadMessages() {
        let keychain = KeychainSwift()
        let db = Firestore.firestore()

        db.collection("users")
            .document(keychain.get("authUid") ?? "")
            .collection("system")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("讀取訊息失敗：\(error.localizedDescription)")
                    return
                }
                print("A")
                guard let documents = snapshot?.documents else { return }

                var tempMessages: [Message] = []

                let group = DispatchGroup()

                for doc in documents {
                    let data = doc.data()

                    guard let category = data["category"] as? String,
                          let point = data["reward"] as? Int,
                          let timestamp = data["timestamp"] as? Timestamp,
                          let deadline = data["deadline"] as? Timestamp,
                          let title = data["title"] as? String,
                          let content = data["description"] as? String else {
                        continue
                    }

                    var message = Message(
                        id: doc.documentID,
                        category: category,
                        point: point,
                        deadline: deadline,
                        timestamp: timestamp,
                        title: title,
                        content: content,
                        isOver: (data["isOver"] as? Bool) ?? false,
                        issueExist: true
                    )

                    group.enter()
                    db.collection(category)
                        .document(title)
                        .getDocument { docSnapshot, error in
                            if let docSnapshot = docSnapshot, !docSnapshot.exists {
                                message.issueExist = false
                            }
                            tempMessages.append(message)
                            group.leave()
                        }
                }

                group.notify(queue: .main) {
                    self.messages = tempMessages
                }
            }
    }
    
    func groupMessagesByDate(_ messages: [RewardMessageView.Message]) -> [(key: String, value: [RewardMessageView.Message])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let grouped = Dictionary(grouping: messages) { msg in
            formatter.string(from: msg.timestamp.dateValue())
        }
        
        // 按日期由新到舊排序
        return grouped.sorted { $0.key > $1.key }
    }
    
    private func observeBadgeCount() {
        let keychain = KeychainSwift()
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(keychain.get("authUid") ?? "")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("監聽錯誤：\(error?.localizedDescription ?? "未知錯誤")")
                    return
                }
                
                // 取得 badgeCount
                if let badgeCount = document.data()?["systemCount"] as? Int {
                    if badgeCount != 0{
                        clearBadgeCount()}
                    print("當前 systemCount: \(badgeCount)")
                }
            }
    }
    
    private func clearBadgeCount() {
        let keychain = KeychainSwift()
        let db = Firestore.firestore()
        db.collection("users")
            .document(keychain.get("authUid") ?? "")
            .updateData([
                "systemCount": 0
            ]) { error in
                if let error = error {
                    print("更新未讀訊息數量失敗：\(error.localizedDescription)")
                } else {
                    print("未讀訊息數量已重設")
                }
            }
    }
    
}

#Preview {
    RewardMessageView(name: "qwe")
}
