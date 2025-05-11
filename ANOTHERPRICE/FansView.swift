//
//  temp5.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/30.
//

import SwiftUI

import FirebaseFirestore
import KeychainSwift

struct FansView: View {
    @Environment(\.dismiss) var dismiss
    @State private var keychain = KeychainSwift()
    @State private var currentUserId: String = "unknown"
    @State var 關注狀態: Bool = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State private var relatedUsers: [String: Users] = [:]
    @State private var isLoading: Bool = false
    
    struct Users: Identifiable {
        let id: String
        let userName: String
        var follow: Bool
        var fans: Int
        var exp: Int
    }
    
    var body: some View {
        VStack{
            UINavigationBar(title: "粉絲列表")
            if isLoading {
                ProgressView("載入中...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(relatedUsers.values.sorted(by: { $0.userName < $1.userName })) { user in
                        UIComplexUser(follow: $關注狀態, userAvatar: userAvatar, fans: user.fans, exp: user.exp, userName: user.userName)
                            .padding(.horizontal, 5)
                        UIRectangleLine(opacity: 0.1)
                    }
                    
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func searchMoreUsers() {
        let db = Firestore.firestore()
        isLoading = true

        db.collection("users")
            .document(currentUserId)
            .collection("fans")
            .getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    var tempUsers: [String: Users] = [:]
                    let group = DispatchGroup()

                    for doc in snapshot.documents {
                        let followedUserId = doc.documentID
                        group.enter()

                        db.collection("users")
                            .document(followedUserId)
                            .getDocument { userSnapshot, error in
                                defer { group.leave() }

                                if let userData = userSnapshot?.data() {
                                    let userName = userData["userName"] as? String ?? "未知用戶"
                                    let fans = userData["fans"] as? Int ?? 0
                                    let exp = userData["exp"] as? Int ?? 0

                                    let user = Users(id: followedUserId, userName: userName, follow: true, fans: fans, exp: exp)
                                    tempUsers[followedUserId] = user
                                } else {
                                    print("找不到使用者 \(followedUserId)：\(error?.localizedDescription ?? "未知錯誤")")
                                }
                            }
                    }

                    group.notify(queue: .main) {
                        self.relatedUsers = tempUsers
                        self.isLoading = false
                    }
                } else {
                    self.isLoading = false
                    print("搜尋關注列表錯誤：\(error?.localizedDescription ?? "未知錯誤")")
                }
            }
    }
}

#Preview {
    FansView()
}
