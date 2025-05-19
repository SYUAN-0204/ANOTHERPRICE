//
//  temp6.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import KeychainSwift

struct MessageView: View {
    @State private var showLoginView = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var showAlert: Bool = false
    @State var systemCount: Int = 0
    @State private var messageSummaries: [MessageSummary] = []
    @State private var keychain = KeychainSwift()
    
    struct MessageSummary: Identifiable {
        var id: String // Document ID
        var otherUid: String
        var name: String
        var content: String
        var date: String
        var badgeCount: Int
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18))
                            .opacity(0)
                    }
                    .padding(.leading, 10)
                    Spacer()
                    Text("訊息")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        showAlert = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                    .alert("提示", isPresented: $showAlert) {
                        Button("全部已讀") {
                        }
                        Button("全部刪除", role: .destructive) {
                        }
                        Button("取消", role: .cancel) {
                            showAlert = false
                        }
                    } message: {
                        Text("用戶 用戶名稱 的提問")
                    }
                }
                .frame(height: 36)
                .background(Color.white)
                ScrollView{
                    HStack{
                        UINavigationMessage(destination: SystemMessageView(title: "我的提問"), icon: "questionmark.message", color: Color.teal, title: "我的提問", badgeCount: 1004)
                        Spacer()
                        UINavigationMessage(destination: SystemMessageView(title: "我的獲讚"), icon: "hand.thumbsup", color: Color.pink, title: "我的獲讚", badgeCount: 0)
                        Spacer()
                        UINavigationMessage(destination: SystemMessageView(title: "我的關注"), icon: "star", color: Color.orange, title: "我的關注", badgeCount: 5)
                        Spacer()
                        UINavigationMessage(destination: SystemMessageView(title: "系統通知"), icon: "bell", color: Color.cyan, title: "系統通知", badgeCount: 13)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    //小精靈跟小助手一起按照日期排
                    UINavigationPersonalMessage(destination: RewardMessageView(name: "獎勵小精靈"), userAvatar: userAvatar, name: "獎勵小精靈", date: "2-25", content: "您的獎勵已送達", badgeCount: systemCount)
                    UINavigationPersonalMessage(destination: IssueMessageView(name: "提問小助手"), userAvatar: userAvatar, name: "提問小助手", date: "2-24", content: "您的提問已到期", badgeCount: 5)
                    ForEach(messageSummaries) { summary in
                        UINavigationPersonalMessage(
                            destination: MessageDetailView(docID: summary.id, otherUid: summary.otherUid, name: summary.name),
                            userAvatar: userAvatar,
                            name: summary.name,
                            date: summary.date,
                            content: summary.content,
                            badgeCount: summary.badgeCount
                        )
                    }
                }
            }
            if (keychain.get("authUid") == nil) {
                Color.white.opacity(0.9)
                VStack {
                    Text("登入即可體驗完整功能")
                        .font(.custom("NotoSerifTC-Regular", size: 20))
                        .foregroundColor(ColorConstants.systemSubColor)
                    UIButtonAccountCustom(title: "登入", action: {
                        showLoginView = true
                    })
                    .frame(width: 160)
                    .sheet(isPresented: $showLoginView) {
                        LoginView()
                            .presentationDetents([.fraction(0.9)])
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .onAppear {
            if (keychain.get("authUid") != nil) {
                listenToMessages()
                listenToSystemCount()
            }
        }
    }
    
    func listenToSystemCount() {
        let db = Firestore.firestore()
        let uid = keychain.get("authUid") ?? ""
        
        db.collection("users")
            .document(uid)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("System count listener error: \(error)")
                    return
                }
                let data = snapshot?.data()
                self.systemCount = data?["systemCount"] as? Int ?? 0
            }
    }
    
    func listenToMessages() {
        let db = Firestore.firestore()
        let uid = keychain.get("authUid") ?? ""
        
        db.collection("users")
            .document(uid)
            .collection("message")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening to messages: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let summaries = documents.compactMap { doc -> MessageSummary? in
                    let data = doc.data()
                    return MessageSummary(
                        id: doc.documentID,
                        otherUid: data["friendUid"] as? String ?? "",
                        name: data["friendName"] as? String ?? "未知使用者",
                        content: data["lastMessage"] as? String ?? "",
                        date: (data["lastUpdated"] as? Timestamp)?.dateValue().formatted(date: .abbreviated, time: .omitted) ?? "",
                        badgeCount: data["badgeCount"] as? Int ?? 0
                    )
                }
                
                self.messageSummaries = summaries
                
                //total = summaries.map { $0.badgeCount }.reduce(0, +)
                //print("總 badgeCount：\(total)")
            }
    }
}

#Preview {
    MessageView()
}
