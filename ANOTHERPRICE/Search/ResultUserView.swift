import SwiftUI
import FirebaseFirestore
import KeychainSwift

struct ResultUserView: View {
    @Environment(\.dismiss) var dismiss
    @State private var keychain = KeychainSwift()
    @State private var currentUserId: String = "unknown"
    let keyword: String
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
        VStack {
            UINavigationBar(title: "更多帳號")
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
        .onAppear() {
            self.currentUserId = keychain.get("authUid") ?? "unknown"
            searchMoreUsers()
        }
    }
    
    func searchMoreUsers() {
        let db = Firestore.firestore()
        isLoading = true

        db.collection("users")
            .whereField("userName", isGreaterThanOrEqualTo: keyword)
            .whereField("userName", isLessThanOrEqualTo: keyword + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    var tempUsers: [String: Users] = [:]
                    let group = DispatchGroup()

                    for doc in snapshot.documents {
                        let uid = doc.documentID
                        let userName = doc.data()["userName"] as? String ?? "未知用戶"
                        let fans = doc.data()["fans"] as? Int ?? 0
                        let exp = doc.data()["exp"] as? Int ?? 0
                        
                        group.enter()
                        let followRef = db.collection("users").document(currentUserId).collection("follow").document(uid)
                        followRef.getDocument { document, error in
                            let isFollowed = document?.exists ?? false
                            let user = Users(id: uid, userName: userName, follow: isFollowed, fans: fans, exp: exp)
                            tempUsers[uid] = user
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        self.relatedUsers = tempUsers
                        self.isLoading = false
                    }
                } else {
                    self.isLoading = false
                    print("搜尋錯誤：\(error?.localizedDescription ?? "未知錯誤")")
                }
            }
    }

}

#Preview {
    ResultUserView(keyword: "搜尋")
}
