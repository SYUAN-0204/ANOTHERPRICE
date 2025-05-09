//
//  temp3.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI
import FirebaseFirestore
import KeychainSwift

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    let category: String
    let documentID: String
    let isMyDisplayView: Bool
    @State private var keychain = KeychainSwift()
    @State private var db = Firestore.firestore()
    @State private var currentUserId: String = "unknown"
    @State private var isAnonymous = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State private var exp: Int = 0
    @State private var isSelfIssue: Bool = false
    @State private var description: String = "內容"
    @State private var follow: Bool = false
    @State private var tags = "#標籤 #不同標籤"
    @State private var title: String = "標題"
    @State private var deadLine: String = "2025/4/20"
    @State private var like: Bool = false
    @State private var isSet: Bool = false
    @State private var authorUid: String = ""
    @State private var star: Bool = false
    @State private var heart: Int = 54
    @State private var upload: String = "2025/4/20"
    @State private var message: Int = 43
    @State private var reward: Int = 1234
    @State private var author: String = "誠實精靈"
    @State private var code: String = "/*edwefwec8*/"
    @State private var http: String = "https://www.anotherprice.com"
    @State private var order: Bool = false
    @State private var response: String = ""
    @State private var 評論: String = "一條很長長長長e長的評論，一條很長長長長長的評論，一條很長長長長長的評論，一條很長長長長長的評論，一條很長長長長長的評論"
    @State private var 展開狀態: Bool = false
    @State private var 展開回覆: Bool = false
    @State private var showAlert: Bool = false
    @State private var responses: [Response] = []
    
    struct Response: Identifiable {
        let id: String
        let response: String
        let heart: Int
        let author: String
        let authorUid: String
        let timestamp: Date
        let exp: Int
    }
    
    let categoryToCollection: [String: String] = [
        "生活": "public_life",
        "學術": "public_academic",
        "科技": "public_technology",
        "健康": "public_health",
        "理財": "public_finance",
        "情感": "public_emotion",
        "娛樂": "public_entertainment",
        "其他": "public_other"
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 120)
                Spacer()
                Text("問題回答")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                }
                .padding(.trailing, 10)
                .frame(width: 120)
            }
            .frame(height: 36)
            HStack {
                UINavigationPostToDisplay(isSelfIssue: isSelfIssue, userAvatar: userAvatar, isAnonymous: isAnonymous,author: author)
                /*NavigationLink{
                 DisplayView(isMyDisplayView: isSelfIssue)
                 } label: {
                 Image(uiImage: userAvatar)
                 .resizable()
                 .scaledToFill() // 確保填滿圓形
                 .frame(width: 40, height: 40) // 限制大小
                 .background(Color(.systemGray6))
                 .clipShape(Circle()) // 剪裁為圓形
                 .overlay(
                 Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                 )
                 Text(isAnonymous ? "匿名精靈":"用戶名稱")
                 .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                 .foregroundColor(ColorConstants.systemSubColor)
                 }
                 .disabled(isAnonymous)*/
                if !isAnonymous {
                    UITextLevel(totalExp: exp, width: 32, height: 14, size: 12)
                    Spacer()
                    if !isSelfIssue && isSet{
                        UIButtonFollow(follow: $follow)
                            .onChange(of: follow) {
                                toggleFollowStatus() // 當 follow 狀態改變時，呼叫關注邏輯
                            }
                    }
                }
            }
            .padding(.horizontal, 15)
            UIRectangleLine(opacity: 0.3)
                .padding(.horizontal, 10)
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    HStack{
                        Text(title)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .foregroundColor(ColorConstants.systemDarkColor)
                        Spacer()
                        Button{
                            showAlert = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 24, alignment: .trailing)
                        }
                        .alert("提示", isPresented: $showAlert) {
                            Button("複製連結") {
                            }
                            Button(isSelfIssue ? "刪除提問" : "檢舉提問", role: .destructive) {
                            }
                            Button("取消", role: .cancel) {
                                showAlert = false
                            }
                        } message: {
                            Text("用戶 用戶名稱 的提問")
                        }
                    }
                    HStack{
                        Text(category)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor)
                            .lineLimit(1)
                            .padding(.horizontal, 3)
                            .background(ColorConstants.systemMainColor.opacity(0.2))
                            .cornerRadius(3)
                        Text("Deadline : \(deadLine)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("-")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("Point : \(reward)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, -7)
                    Text(description)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                        .padding(.top, -3)
                    let tagString = tags
                        .components(separatedBy: " ")
                        .filter { !$0.isEmpty && $0.starts(with: "#") }
                        .prefix(5)
                        .joined(separator: " ")
                    Text(tagString)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemMainColor)
                        .padding(.top, -3)
                        .padding(.top, 20)
                    HStack{
                        Button{
                            like.toggle()
                        } label: {
                            Image(systemName: like ? "heart.fill":"heart")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Text("\(heart)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Button{
                            star.toggle()
                        } label: {
                            Image(systemName: star ? "star.fill":"star")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Text("\(message)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Image(systemName: "ellipsis.message")
                            .font(.system(size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Text("\(message)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        ShareLink(item: "✨「\(author)發布了一則問答《\(title)》，快來看看吧！」\n打開 APP 搜尋口令：/*\(code)*/🪄\n🔗  \(http)") {
                            Image(systemName: "arrowshape.turn.up.right")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Spacer()
                        Text("Upload : \(upload)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 5)
                }
                .padding(.horizontal, 5)
                UIRectangleLine(opacity: 0.3)
                HStack{
                    Text("回答")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                    Spacer()
                    Button{
                        order.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                        Text(order ? "按時間":"按熱度")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                    }
                }
                .padding(.horizontal, 5)
                ForEach(responses) { responseData in
                    UIComplexAnswer(
                        userName: responseData.author,
                        isSelfIssue: isSelfIssue,
                        userAvatar: userAvatar,
                        anonymous: isAnonymous,
                        comment: responseData.response,
                        totalExp: responseData.exp,
                        like: $like,
                        heart: responseData.heart
                    )
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            if !isSelfIssue {
                HStack{
                    HStack{
                        TextField("睡著了也等不到你的回答" ,text: $response)
                            .autocapitalization(.none)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                            .foregroundColor(ColorConstants.systemSubColor)
                            .tracking(1)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 3)
                            .frame(height: 28)
                        Button{
                            展開回覆 = true
                        } label: {
                            Image(systemName: "arrow.down.left.and.arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                                .padding(.trailing, 5)
                        }
                        .sheet(isPresented: $展開回覆) {
                            temp4(input: $response, hint: "睡著了也等不到你的回答", button: "送出")
                                .presentationDetents([.fraction(0.96)])
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                    }
                    Button{
                        uploadToFirebase()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(ColorConstants.systemMainColor.opacity(response.isEmpty ? 0.7 : 1.0))
                            Text("送出")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 60, height: 28)
                }
                .padding(.horizontal, 15)
                .padding(.top, 5)
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.currentUserId = keychain.get("authUid") ?? "unknown"
            fetchPostDetails()
            fetchResponses()
        }
    }
    
    private func fetchPostDetails() {
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID)
        
        postRef.getDocument { document, error in
            DispatchQueue.main.async {
                if error != nil {
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()
                    
                    let updatedAtTimestamp = (data?["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                    let deadline = (data?["deadline"] as? Timestamp)?.dateValue() ?? Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd mm:ss"
                    let formattedDate = dateFormatter.string(from: deadline)
                    let formattedDate2 = dateFormatter.string(from: updatedAtTimestamp)
                    
                    self.title = data?["title"] as? String ?? ""
                    self.description = data?["description"] as? String ?? ""
                    self.tags = (data?["tags"] as? [String])?.joined(separator: " ") ?? ""
                    self.author = data?["author"] as? String ?? "未知"
                    self.authorUid = data?["authorUid"] as? String ?? "未知"
                    self.isAnonymous = data?["isAnonymous"] as? Bool ?? false
                    self.heart = data?["heart"] as? Int ?? 0
                    self.message = data?["commentCount"] as? Int ?? 0
                    self.reward = data?["reward"] as? Int ?? 0
                    self.deadLine = formattedDate
                    self.upload = formattedDate2
                    self.code = data?["code"] as? String ?? ""
                    self.http = data?["http"] as? String ?? ""
                    
                    if(!isAnonymous){
                        db.collection("users").document(authorUid).getDocument { document, error in
                            if let error = error {
                                print("獲取使用者資料失敗: \(error.localizedDescription)")
                                return
                            }
                            
                            if let document = document, document.exists {
                                let data = document.data()
                                exp = data?["exp"] as? Int ?? 0
                            }
                        }
                        
                        let followRef = db.collection("users").document(currentUserId).collection("follow").document(authorUid)
                        followRef.getDocument { document, error in
                            if let error = error {
                                print("取得 follow 狀態失敗: \(error.localizedDescription)")
                                return
                            }

                            if let document = document, document.exists {
                                self.follow = true
                            } else {
                                self.follow = false
                            }
                            
                            if(currentUserId == authorUid) {
                                isSelfIssue = true
                            }
                            isSet = true
                        }
                    }
                }
            }
        }
    }
    
    func fetchResponses() {
        let targetCollection = categoryToCollection[category] ?? "life"
        let responseRef = db.collection(targetCollection).document(documentID).collection("response").order(by: "timestamp", descending: !order)

        responseRef.getDocuments { snapshot, error in
            if let error = error {
                print("取得回答失敗：\(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            var tempResponses: [Response] = []
            let group = DispatchGroup()

            for doc in documents {
                let data = doc.data()
                let id = doc.documentID
                let responseText = data["response"] as? String ?? ""
                let heart = data["heart"] as? Int ?? 0
                let author = data["author"] as? String ?? "未知"
                let authorUid = data["authorUid"] as? String ?? ""
                let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                
                group.enter()
                db.collection("users").document(authorUid).getDocument { userDoc, error in
                    var exp = 0
                    if let userData = userDoc?.data() {
                        exp = userData["exp"] as? Int ?? 0
                    }

                    let response = Response(
                        id: id,
                        response: responseText,
                        heart: heart,
                        author: author,
                        authorUid: authorUid,
                        timestamp: timestamp,
                        exp: exp
                    )

                    tempResponses.append(response)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.responses = tempResponses.sorted { $0.timestamp > $1.timestamp }
            }
        }
    }
    
    func uploadToFirebase() {
        let data: [String: Any] = [
            "response": response,
            "timestamp": Timestamp(),
            "heart": 0,
            "author": keychain.get("userName") ?? "error",
            "authorUid": keychain.get("authUid") ?? "error"
        ]
        
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID).collection("response").document()
        let documentId = postRef.documentID
        
        postRef.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document successfully added!")
            }
        }
        
        db.collection("users").document(authorUid).collection("response").document(documentId)
            .setData(["documentId": documentID, "collection": targetCollection, "createdAt": Timestamp()]) { error in
                if let error = error {
                    print("(PostDetailView) 儲存 documentId 失敗: \(error.localizedDescription)")
                } else {
                    print("(PostDetailView) 成功儲存 documentId 到 response")
                }
            }
    }
    
    //關注問題處理
    func toggleFollowStatus() {
        let targetUserUid = authorUid
        // 1. 檢查是否已經關注過
        let followRef = db.collection("users").document(currentUserId).collection("follow").document(targetUserUid)
        followRef.getDocument { document, error in
            if let error = error {
                print("Error fetching follow document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                self.unfollowUser(currentUserUid: currentUserId, targetUserUid: targetUserUid)
            } else {
                self.followUser(currentUserUid: currentUserId, targetUserUid: targetUserUid)
            }
        }
    }
    
    func followUser(currentUserUid: String, targetUserUid: String) {
        // 將 targetUserUid 添加到當前用戶的 follow 集合
        let followRef = db.collection("users").document(currentUserUid).collection("follow").document(targetUserUid)
        followRef.setData([ "uid": targetUserUid ]) { error in
            if let error = error {
                print("Error following user: \(error.localizedDescription)")
            } else {
                print("Successfully followed user!")
                // 同時將當前用戶的 UID 添加到 targetUserUid 的 fans 集合中
                let fansRef = db.collection("users").document(targetUserUid).collection("fans").document(currentUserUid)
                fansRef.setData([ "uid": currentUserUid ]) { error in
                    if let error = error {
                        print("Error adding user to fans: \(error.localizedDescription)")
                    } else {
                        print("Successfully added user to fans!")
                    }
                }
            }
        }
    }
    
    func unfollowUser(currentUserUid: String, targetUserUid: String) {
        // 從當前用戶的 follow 集合中刪除 targetUserUid
        let followRef = db.collection("users").document(currentUserUid).collection("follow").document(targetUserUid)
        followRef.delete { error in
            if let error = error {
                print("Error unfollowing user: \(error.localizedDescription)")
            } else {
                print("Successfully unfollowed user!")
                // 同時從 targetUserUid 的 fans 集合中刪除當前用戶的 UID
                let fansRef = db.collection("users").document(targetUserUid).collection("fans").document(currentUserUid)
                fansRef.delete { error in
                    if let error = error {
                        print("Error removing user from fans: \(error.localizedDescription)")
                    } else {
                        print("Successfully removed user from fans!")
                    }
                }
            }
        }
    }
    
}

#Preview {
    PostDetailView(category: "12", documentID: "12", isMyDisplayView: true)
}
