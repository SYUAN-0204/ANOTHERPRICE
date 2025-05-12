//
//  temp8.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import KeychainSwift

struct DisplayView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var db = Firestore.firestore()
    @State private var authUid: String? = nil
    @State private var docID: String = ""
    @State private var keychain = KeychainSwift()
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var userName: String = "這是另外的價錢"
    @State var bio: String = "路過的旅人並未在此留下痕跡"
    @State var registrationDays: Int = 0
    @State var likesCount: Int = 0
    @State var followers: Int = 0
    @State var following: Int = 0
    @State var exp: Int = 0
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var selectedItem: PhotosPickerItem? // 用於 iOS 16+ PhotosPicker
    let isMyDisplayView: Bool
    @State private var isSelected: Bool = true
    @State private var follow: Bool = false
    @State private var cancelFollow: Bool = false
    @State private var isMessaging: Bool = false
    @State private var isVisitorBlocked: Bool = true
    @State private var isFanBlocked: Bool = true
    @State private var drafts: [Draft] = []
    @State private var isLoading = true
    @State private var isFetchingMore = false
    @State private var hasMoreData = true
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var noDraftsMessage: String? = nil
    
    struct Draft: Identifiable {
        var id: String
        var board: String
        var title: String
        var description: String
        var createdAt: Date
        var deadLine: String
        var lastCommentDate: String
        var heart: Int
        var commentCount: Int
        var reward: Int
    }
    
    var body: some View {
        ZStack(alignment: .top){
            Image(uiImage: userAvatar)
                .resizable()
                .scaledToFill()
                .frame(width: 402, height: 260)
                .clipped()
                .overlay(
                    Color.black.opacity(0.8)
                )
                .ignoresSafeArea(edges: .top)
            VStack{
                VStack{
                    HStack {
                        HStack{
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .frame(width: 80)
                        Spacer()
                        Text("")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .fontWeight(.semibold)
                        Spacer()
                        HStack{
                            Spacer()
                            Button {
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18))
                                    .opacity(0)
                            }
                            .disabled(true)
                        }
                        .frame(width: 80)
                    }
                    .frame(height: 36)
                    HStack{
                        Button(){
                            self.showPhotoOptions.toggle()
                        } label: {
                            UIProfileImage(photo: userAvatar, width: 70, height: 70)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 0.1)
                                )
                        }
                        .disabled(isMyDisplayView)
                        .photosPicker(isPresented: $showPhotoOptions, selection: $selectedItem, matching: .images)
                        .onChange(of: selectedItem) {
                            Task {
                                if let newItem = selectedItem,
                                   let data = try? await newItem.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    // 裁剪成正方形後再更新頭像
                                    if let croppedImage = image.cropToSquare() {
                                        userAvatar = croppedImage
                                    } else {
                                        userAvatar = image
                                    }
                                }
                            }
                        }
                        VStack{
                            HStack{
                                Text(userName)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    .foregroundColor(.white)
                                UITextLevel(totalExp: exp, width: 40, height: 18, size: 14)
                                HStack{
                                    Text("著陸 \(registrationDays) 天")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                            }
                            HStack{
                                HStack{
                                    UITextPageDetails(detailInput: $followers, detailTitle: "粉絲")
                                    Spacer()
                                    UITextPageDetails(detailInput: $following, detailTitle: "關注")
                                    Spacer()
                                    UITextPageDetails(detailInput: $likesCount, detailTitle: "獲讚")
                                }
                                .frame(width: 160)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .frame(height: 70)
                    Text(bio)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .frame(width: 370, alignment: .leading)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .frame(height: 200)
                HStack{
                    Button(){
                        isSelected = true
                        drafts = []
                        isLoading = true
                        isFetchingMore = false
                        hasMoreData = true
                    } label: {
                        VStack{
                            Text("提問")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .frame(width: 40)
                            Rectangle()
                                .fill(isSelected ? ColorConstants.systemMainColor:Color.clear)
                                .frame(height: 1.5)
                                .padding(.top, -10)
                                .frame(width: 46)
                        }
                    }
                    .disabled(isSelected)
                    .frame(width: 60)
                    .padding(.top, 10)
                    Button(){
                        isSelected = false
                        drafts = []
                        isLoading = true
                        isFetchingMore = false
                        hasMoreData = true
                    } label: {
                        VStack{
                            Text("回答")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .frame(width: 40)
                            Rectangle()
                                .fill(!isSelected ? ColorConstants.systemMainColor:Color.clear)
                                .frame(height: 1.5)
                                .padding(.top, -10)
                                .frame(width: 46)
                        }
                    }
                    .disabled(!isSelected)
                    .frame(width: 60)
                    .padding(.top, 10)
                    Spacer()
                    if !isMyDisplayView {
                        Button{
                            if !follow {
                                follow = true
                            }
                            else {
                                cancelFollow = true
                            }
                        } label: {
                            if follow {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                        .frame(width: 66, height: 24)
                                    HStack{
                                        Text("已關注")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(ColorConstants.systemMainColor)
                                    }
                                }
                            }
                            else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorConstants.systemMainColor)
                                        .frame(width: 66, height: 24)
                                    HStack{
                                        Image(systemName: "plus")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                            .padding(.trailing, -7)
                                        Text("關注")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(.trailing, 7)
                        .alert("取消關注 帳戶暱稱", isPresented: $cancelFollow) {
                            Button("取消", role: .cancel) { }
                            Button("確定", role: .destructive) {
                                follow = false
                            }
                        }
                        Button{
                            selfMessage()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                    .frame(width: 66, height: 24)
                                HStack{
                                    Image(systemName: "ellipsis.message")
                                        .font(.system(size: 12))
                                        .foregroundColor(ColorConstants.systemMainColor)
                                        .padding(.trailing, -7)
                                    Text("私訊")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                        .foregroundColor(ColorConstants.systemMainColor)
                                }
                            }
                        }
                        .padding(.trailing, 7)
                        .sheet(isPresented: $isMessaging) {
                            MessageDetailView(docID: docID, otherUid: authUid ?? "error", name: userName)
                                .presentationDetents([.fraction(0.7)])
                        }
                    }
                }
                .frame(height: 20)
                .padding(.horizontal, 5)
                
                if isSelected {
                    ScrollView{
                        if isVisitorBlocked && !isMyDisplayView {
                            Text("\(userName)沒有向\(isFanBlocked ? " 訪客 ":" 任何用戶 ")開放他的提問")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            Text("\(isFanBlocked ? "\n關注後查看":"")")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, -20)
                            Image(systemName: "lock")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        else {
                            LazyVStack {
                                ForEach(drafts) { draft in
                                    UIComplexIssueCard(destination: LazyView(ErrorView()), title: draft.title, date: draft.deadLine, common: draft.lastCommentDate, coin: draft.reward, content: draft.title, like: false, heart: draft.heart, message: draft.commentCount, author: "author", code: "code", http: "http")
                                        .onAppear {
                                            if draft.id == drafts.last?.id && hasMoreData && !isFetchingMore {
                                                fetchDrafts(initial: false, selectName: "publish")
                                            }
                                        }
                                }
                            }
                            .onAppear {
                                if drafts.isEmpty {
                                    fetchDrafts(initial: true, selectName: "publish")
                                }
                            }
                        }
                        if isFetchingMore {
                            ProgressView("載入更多中...")
                                .padding(.vertical, 10)
                        }
                        
                        if !hasMoreData && !drafts.isEmpty {
                            Text("沒有更多提問了")
                                .foregroundColor(.gray)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                .padding(.vertical, 10)
                        }
                    }
                }
                else {
                    ScrollView{
                        if isVisitorBlocked && !isMyDisplayView {
                            Text("\(userName)沒有向\(isFanBlocked ? " 訪客 ":" 任何用戶 ")開放他的回答")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            Text("\(isFanBlocked ? "\n關注後查看":"")")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, -20)
                            Image(systemName: "lock")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        else {
                            LazyVStack {
                                ForEach(drafts) { draft in
                                    UIComplexIssueCard(destination: LazyView(ErrorView()), title: draft.title, date: draft.deadLine, common: draft.lastCommentDate, coin: draft.reward, content: draft.title, like: false, heart: draft.heart, message: draft.commentCount, author: "author", code: "code", http: "http")
                                        .onAppear {
                                            if draft.id == drafts.last?.id && hasMoreData && !isFetchingMore {
                                                fetchDrafts(initial: false, selectName: "favorites")
                                            }
                                        }
                                }
                            }
                            .onAppear {
                                if drafts.isEmpty {
                                    fetchDrafts(initial: true,selectName: "favorites")
                                }
                            }
                        }
                        if isFetchingMore {
                            ProgressView("載入更多中...")
                                .padding(.vertical, 10)
                        }
                        
                        if !hasMoreData && !drafts.isEmpty {
                            Text("沒有更多提問了")
                                .foregroundColor(.gray)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                .padding(.vertical, 10)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if(isMyDisplayView){
                self.authUid = keychain.get("authUid")
                self.userName = keychain.get("userName") ?? "這是另外"
            } else {
                self.authUid = keychain.get("authorUid")
                self.userName = keychain.get("authorName") ?? "這是另外"
            }
            self.registrationDays = daysSinceRegistration() + 1
            fetchUserDetails()
        }
    }
    
    private func fetchUserDetails() {
        let userUid: String?
        
        if isMyDisplayView {
            userUid = keychain.get("authUid")
        } else {
            userUid = keychain.get("authorUid")
        }
        
        guard let userUid = userUid else { return }
        
        db.collection("users").document(userUid).getDocument { document, error in
            if let error = error {
                print("獲取使用者資料失敗: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                likesCount = data?["hearts"] as? Int ?? 0
                bio = data?["bio"] as? String ?? "路過的旅人並未在此留下痕跡"
                if(bio.isEmpty){
                    bio = "路過的旅人並未在此留下痕跡"
                }
                followers = data?["followers"] as? Int ?? 0
                following = data?["following"] as? Int ?? 0
                exp = data?["exp"] as? Int ?? 0
            } else {
                print("(ProfileView)文件不存在")
            }
        }
    }
    
    private func daysSinceRegistration() -> Int {
        let registDayString: String?
        
        if isMyDisplayView {
            registDayString = keychain.get("registDay")
        } else {
            registDayString = keychain.get("authRegistTime")
        }
        
        guard let registDayString = registDayString else { return 0}
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        
        guard let registDate = dateFormatter.date(from: registDayString) else {
            return 0
        }
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: registDate)
        
        let components = calendar.dateComponents([.day], from: startOfDay, to: Date())
        
        return components.day ?? 0
    }
    
    func fetchDrafts(initial: Bool, selectName: String) {
        guard let userUid = keychain.get("authUid") else { return }
        guard !isFetchingMore else { return }
        
        var query: Query = db.collection("users").document(userUid).collection(selectName)
            .order(by: "createdAt", descending: true)
        
        if initial {
            isLoading = true
            query = query.limit(to: 8)
        } else {
            query = query.limit(to: 5)
            isFetchingMore = true
            if let last = lastDocument {
                query = query.start(afterDocument: last)
            }
        }
        
        query.getDocuments { snapshot, error in
            if initial {
                isLoading = false
            } else {
                isFetchingMore = false
            }
            
            guard error == nil, let snapshot = snapshot else {
                print("(PublishView)獲取 publish 錯誤: \(error?.localizedDescription ?? "未知錯誤")")
                return
            }
            
            let group = DispatchGroup()
            var newDrafts: [Draft] = []
            
            for doc in snapshot.documents {
                let documentId = doc.documentID
                guard let collection = doc.data()["collection"] as? String else {
                    print("(PublishView)缺少 collection 欄位: \(documentId)")
                    continue
                }
                group.enter()
                db.collection(collection).document(documentId).getDocument { publicDoc, error in
                    defer { group.leave() }
                    
                    if let error = error {
                        print("(PublishView)讀取 \(collection)/\(documentId) 失敗: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = publicDoc?.data() else {
                        print("(PublishView)\(collection)/\(documentId) 無資料")
                        return
                    }
                    
                    let deadline = (data["deadline"] as? Timestamp)?.dateValue() ?? Date()
                    let lastComment = (data["lastComment"] as? Timestamp)?.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: deadline)
                    let lastCommentDate = lastComment != nil ? dateFormatter.string(from: lastComment!) : ""
                    
                    let draft = Draft(
                        id: documentId,
                        board: (data["category"] as! String),
                        title: data["title"] as? String ?? "無標題",
                        description: data["description"] as? String ?? "無敘述",
                        createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        deadLine: formattedDate,
                        lastCommentDate: lastCommentDate,
                        heart: data["heart"] as? Int ?? 0,
                        commentCount: data["commentCount"] as? Int ?? 0,
                        reward: data["reward"] as? Int ?? 0
                    )
                    newDrafts.append(draft)
                }
            }
            
            group.notify(queue: .main) {
                if initial {
                    drafts = newDrafts.sorted { $0.createdAt > $1.createdAt }
                } else {
                    drafts.append(contentsOf: newDrafts.sorted { $0.createdAt > $1.createdAt })
                }
                
                lastDocument = snapshot.documents.last
                hasMoreData = newDrafts.count >= (initial ? 8 : 5)
            }
        }
    }
    
    //message
    private func selfMessage(){
        guard let myUid = keychain.get("authUid") else { return }
        guard let myName = keychain.get("userName") else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(myUid).collection("message")
            .whereField("friendUid", isEqualTo: authUid ?? "error")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("查詢私訊失敗：\(error)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    // 聊天室已存在
                    docID = document.documentID
                    
                    if !docID.isEmpty {
                        isMessaging = true
                    }
                } else {
                    // 建立新的聊天室
                    let newDocID = UUID().uuidString
                    docID = newDocID
                    
                    let myMessageData: [String: Any] = [
                        "friendUid": authUid ?? "error",
                        "friendName": userName,
                        "lastMessage": "",
                        "lastUpdated": FieldValue.serverTimestamp(),
                        "badgeCount": 0
                    ]
                    let otherMessageData: [String: Any] = [
                        "friendUid": myUid,
                        "friendName": myName,
                        "lastMessage": "",
                        "lastUpdated": FieldValue.serverTimestamp(),
                        "badgeCount": 0
                    ]
                    
                    db.collection("users").document(myUid).collection("message").document(newDocID).setData(myMessageData)
                    db.collection("users").document(authUid ?? "error").collection("message").document(newDocID).setData(otherMessageData)
                    
                    if !docID.isEmpty {
                        isMessaging = true
                    }
                }
            }
    }
}

#Preview {
    DisplayView(isMyDisplayView: false)
}
