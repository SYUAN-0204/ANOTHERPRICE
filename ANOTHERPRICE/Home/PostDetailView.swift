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
    
    @State var category: String
    @State var documentID: String
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
    @State private var star: Int = 0
    @State private var isStar: Bool = false
    @State private var heart: Int = 54
    @State private var upload: String = "2025/4/20"
    @State private var message: Int = 43
    @State private var reward: Int = 1234
    @State private var author: String = "誠實精靈"
    @State private var code: String = "/*edwefwec8*/"
    @State private var http: String = "https://www.anotherprice.com"
    @State private var order: Bool = false
    @State private var response: String = ""
    @State private var isExpanded: Bool = false
    @State private var isReplyExpanded: Bool = false
    @State private var showAlert: Bool = false
    @State private var responses: [Response] = []
    @State private var isResponse: Bool = false
    @State private var hasResponded: Bool = false
    
    struct Response: Identifiable {
        let id: String
        let response: String
        var heart: Int
        let author: String
        let authorUid: String
        let timestamp: String
        let exp: Int
        var like: Bool
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
                if !isAnonymous {
                    UITextLevel(totalExp: exp, width: 32, height: 14, size: 12)
                    Spacer()
                    if !isSelfIssue && isSet{
                        UIButtonFollow(follow: $follow)
                            .onChange(of: follow) {
                                toggleFollowStatus()
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
                            if(like) {
                                saveToHeart()
                            } else{
                                deleteFromHeart()
                            }
                        } label: {
                            Image(systemName: like ? "heart.fill":"heart")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        .disabled(isSelfIssue)
                        Text("\(heart)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Button{
                            isStar.toggle()
                            if(isStar) {
                                saveToFavorites()
                            } else{
                                deleteFromFavorites()
                            }
                        } label: {
                            Image(systemName: isStar ? "star.fill":"star")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        .disabled(isSelfIssue)
                        Text("\(star)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Image(systemName: "ellipsis.message")
                            .font(.system(size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Text("\(message)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        ShareLink(item: "✨「\(author)發布了一則問答《\(title)》，快來看看吧！」\n打開 APP 搜尋口令：/*\(category)_\(documentID)*/🪄\n🔗  \(http)") {
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
                        fetchResponses()
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
                        authorUid: responseData.authorUid,
                        docId: responseData.id,
                        userName: responseData.author,
                        isSelfIssue: isSelfIssue,
                        userAvatar: userAvatar,
                        anonymous: false,
                        comment: responseData.response,
                        totalExp: responseData.exp,
                        timestamp: responseData.timestamp,
                        like: $responses[responses.firstIndex(where: { $0.id == responseData.id })!].like, // 透過 Binding 傳遞
                        heart: $responses[responses.firstIndex(where: { $0.id == responseData.id })!].heart,
                        toggleResponseHeart: { docId, authorUid,like in
                            toggleResponseHeart(docId: docId, authorId: authorUid, isLiked:like)
                        }
                    )
                }
                if isResponse && responses.isEmpty {
                    Text("誠實精靈翻了翻箱子，還沒有任何回答")
                        .foregroundColor(.gray)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                        .padding(.vertical, 10)
                } else if isResponse {
                    Text("沒有更多回答了")
                        .foregroundColor(.gray)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                        .padding(.vertical, 10)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            if !isSelfIssue || !hasResponded{
                HStack{
                    HStack{
                        TextField(hasResponded ? "誠實精靈已收到你的回答":"睡著了也等不到你的回答", text: $response)
                            .autocapitalization(.none)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                            .foregroundColor(ColorConstants.systemSubColor)
                            .tracking(1)
                            .padding(.vertical, 3)
                            .padding(.horizontal, 3)
                            .frame(height: 28)
                            .disabled(hasResponded)
                        Button{
                            isReplyExpanded = true
                        } label: {
                            Image(systemName: "arrow.down.left.and.arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                                .padding(.trailing, 5)
                        }
                        .sheet(isPresented: $isReplyExpanded) {
                            InputView(input: $response, hint: "睡著了也等不到你的回答", button: "送出") {
                                uploadToFirebase()
                            }
                            .presentationDetents([.fraction(0.96)])
                        }
                        .disabled(hasResponded)
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
                    .disabled(response.isEmpty)
                    .frame(width: 60, height: 28)
                }
                .padding(.horizontal, 15)
                .padding(.top, 5)
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            setupFromKeychainIfNeeded()
        }
    }
    
    func setupFromKeychainIfNeeded() {
        self.currentUserId = keychain.get("authUid") ?? "unknown"

        fetchPostDetails()
        fetchResponses()
        checkIfUserResponded()
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
                    self.star = data?["star"] as? Int ?? 0
                    self.message = data?["commentCount"] as? Int ?? 0
                    self.reward = data?["reward"] as? Int ?? 0
                    self.deadLine = formattedDate
                    self.upload = formattedDate2
                    self.code = data?["code"] as? String ?? ""
                    self.http = data?["http"] as? String ?? ""
                    
                    keychain.set(self.author, forKey: "authorName")
                    keychain.set(self.authorUid, forKey: "authorUid")
                    if(!isAnonymous){
                        // 檢查是否收藏
                        let favoritesRef = db.collection("users").document(currentUserId).collection("favorites").document(documentID)
                        favoritesRef.getDocument { document, error in
                            if let error = error {
                                print("檢查是否已收藏失敗: \(error.localizedDescription)")
                                return
                            }
                            
                            if let document = document, document.exists {
                                self.isStar = true
                            } else {
                                self.isStar = false
                            }
                        }
                        
                        // 檢查是否按讚
                        if let likes = data?["likes"] as? [String], likes.contains(currentUserId) {
                            self.like = true
                        } else {
                            self.like = false
                        }
                        
                        db.collection("users").document(authorUid).getDocument { document, error in
                            if let error = error {
                                print("獲取使用者資料失敗: \(error.localizedDescription)")
                                return
                            }
                            
                            if let document = document, document.exists {
                                let data = document.data()
                                exp = data?["exp"] as? Int ?? 0
                                
                                let registrationTime = data?["registrationTime"] as? Timestamp ?? Timestamp()
                                let authRegistTime = formatTimestamp(registrationTime)
                                keychain.set(authRegistTime, forKey: "authRegistTime")
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
    
    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
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
            var userOwnResponse: Response? = nil
            
            for doc in documents {
                let data = doc.data()
                let id = doc.documentID
                let responseText = data["response"] as? String ?? ""
                let heart = data["heart"] as? Int ?? 0
                let author = data["author"] as? String ?? "未知"
                let authorUid = data["authorUid"] as? String ?? ""
                let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd mm:ss"
                let formattedDate = dateFormatter.string(from: timestamp)
                let likes = data["likes"] as? [String] ?? []
                let isLiked = likes.contains(currentUserId)
                
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
                        timestamp: formattedDate,
                        exp: exp,
                        like: isLiked
                    )
                    
                    if authorUid == currentUserId {
                        userOwnResponse = response
                    } else {
                        tempResponses.append(response)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                // 排序回覆（按時間或按熱度）
                tempResponses.sort {
                    order ? $0.timestamp > $1.timestamp : $0.heart > $1.heart
                }
                
                if let ownResponse = userOwnResponse {
                    tempResponses.insert(ownResponse, at: 0)
                }
                
                self.responses = tempResponses
                self.isResponse = true
                self.hasResponded = userOwnResponse != nil
            }
        }
    }
    
    func checkIfUserResponded() {
        let targetCollection = categoryToCollection[category] ?? "life"
        let responseRef = db.collection(targetCollection)
            .document(documentID)
            .collection("response")
            .whereField("authorUid", isEqualTo: currentUserId)
        
        responseRef.getDocuments { snapshot, error in
            if let error = error {
                print("(PostDetailView)檢查使用者回覆失敗：\(error.localizedDescription)")
                return
            }
            
            if let documents = snapshot?.documents, !documents.isEmpty {
                self.hasResponded = true
                print("(PostDetailView)使用者已經回覆過了")
            } else {
                self.hasResponded = false
            }
        }
    }
    
    func uploadToFirebase() {
        let time = Timestamp()
        let data: [String: Any] = [
            "response": response,
            "timestamp": time,
            "heart": 0,
            "author": keychain.get("userName") ?? "路過的旅人",
            "authorUid": keychain.get("authUid") ?? "wybTvK80tjfkltfK8TBXTyy1hIf1"
        ]
        
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID).collection("response").document()
        let documentId = postRef.documentID
        
        // 保存response数据
        postRef.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document successfully added!")
            }
        }
        
        // 在用户的 response 集合中保存 documentId
        db.collection("users").document(keychain.get("authUid") ?? "wybTvK80tjfkltfK8TBXTyy1hIf1").collection("response").document(documentId)
            .setData(["documentId": documentID, "collection": targetCollection, "createdAt": time]) { error in
                if let error = error {
                    print("(PostDetailView) 儲存 documentId 失敗: \(error.localizedDescription)")
                } else {
                    print("(PostDetailView) 成功儲存 documentId 到 response")
                }
            }
        
        let postDocRef = db.collection(targetCollection).document(documentID)
        
        postDocRef.updateData([
            "commentCount": FieldValue.increment(Int64(1)),
            "lastComment": time
        ]) { error in
            if let error = error {
                print("(PostDetailView) 更新文件的 commentCount 或 lastComment 失败: \(error.localizedDescription)")
            } else {
                print("(PostDetailView) 成功更新 commentCount 和 lastComment")
            }
        }
        
        self.response = ""
        self.fetchResponses()
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
    
    // 收藏問題處理
    func saveToFavorites() {
        star += 1
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID)
        
        postRef.updateData([
            "star": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("(PostDetailView) 更新 star 欄位失敗: \(error.localizedDescription)")
                return
            }
            
            db.collection("users").document(currentUserId).collection("favorites").document(documentID)
                .setData(["documentId": documentID, "collection": targetCollection, "createdAt": Timestamp()]) { error in
                    if let error = error {
                        print("(PostDetailView) 儲存 documentId 失敗: \(error.localizedDescription)")
                    } else {
                        print("(PostDetailView) 成功儲存 documentId 到 favorites")
                    }
                }
        }
    }
    
    func deleteFromFavorites() {
        star -= 1
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID)
        
        postRef.updateData([
            "star": FieldValue.increment(Int64(-1))
        ]) { error in
            if let error = error {
                print("(PostDetailView) 更新 star 欄位失敗: \(error.localizedDescription)")
                return
            }
            
            db.collection("users").document(currentUserId).collection("favorites").document(documentID)
                .delete { error in
                    if let error = error {
                        print("(PostDetailView) 刪除收藏失敗: \(error.localizedDescription)")
                    } else {
                        print("(PostDetailView) 成功刪除收藏")
                    }
                }
        }
    }
    
    // 按讚處理
    func saveToHeart() {
        heart += 1
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID)
        
        postRef.updateData([
            "heart": FieldValue.increment(Int64(1)),
            "likes": FieldValue.arrayUnion([currentUserId])  // 在 'likes' 中加入當前用戶的 UID
        ]) { error in
            if let error = error {
                print("(PostDetailView) 更新 heart 欄位或 likes 失敗: \(error.localizedDescription)")
                return
            }
            
            let authorRef = db.collection("users").document(authorUid)
            authorRef.updateData([
                "hearts": FieldValue.increment(Int64(1))
            ]) { error in
                if let error = error {
                    print("(PostDetailView) 更新作者的 hearts 失敗: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    func deleteFromHeart() {
        heart -= 1
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID)
        
        postRef.updateData([
            "heart": FieldValue.increment(Int64(-1)),
            "likes": FieldValue.arrayRemove([currentUserId])
        ]) { error in
            if let error = error {
                print("(PostDetailView) 更新 heart 欄位或移除 likes 失敗: \(error.localizedDescription)")
                return
            }
            
            let authorRef = db.collection("users").document(authorUid)
            authorRef.updateData([
                "hearts": FieldValue.increment(Int64(-1))
            ]) { error in
                if let error = error {
                    print("(PostDetailView) 更新作者的 hearts 失敗: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    func toggleResponseHeart(docId: String, authorId: String, isLiked: Bool) {
        let targetCollection = categoryToCollection[category] ?? "life"
        let postRef = db.collection(targetCollection).document(documentID).collection("response").document(docId)
        
        let heartUpdate = FieldValue.increment(Int64(isLiked ? -1 : 1))
        let likesUpdate = isLiked ? FieldValue.arrayRemove([currentUserId]) : FieldValue.arrayUnion([currentUserId])
        
        postRef.updateData([
            "heart": heartUpdate,
            "likes": likesUpdate
        ]) { error in
            if let error = error {
                print("(PostDetailView) 更新 heart 或 likes 失敗: \(error.localizedDescription)")
                return
            }
            
            let authorRef = db.collection("users").document(authorId)
            authorRef.updateData([
                "hearts": FieldValue.increment(Int64(isLiked ? -1 : 1))
            ]) { error in
                if let error = error {
                    print("(PostDetailView) 更新作者 hearts 失敗: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}

#Preview {
    PostDetailView(category: "12", documentID: "12", isMyDisplayView: true)
}
