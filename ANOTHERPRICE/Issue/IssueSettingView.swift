//
//  IssueSettingView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct IssueSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var keychain = KeychainSwift()
    @State private var db = Firestore.firestore()
    @State private var draftId:String = ""
    @State private var title:String = ""
    @State private var description:String = ""
    @State private var inputText:String = ""
    @State private var selectedCategory:String = ""
    @State private var categoryList = ["生活", "學術", "科技", "健康", "理財", "情感", "娛樂", "其他"] //可以考慮從firebase抓資料，方便類別擴充
    @State private var tags:String = ""
    @State private var userName:String = ""
    @State private var reward:String = ""
    @State private var point:Int = 0
    @State private var exp:Int = 0
    @State private var selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var isAnonymous = false
    @State private var selectAnonymous:String = "off"
    @State private var anonymousOptions = ["on", "off"]
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @EnvironmentObject var nav: NavigationCoordinator
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
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
                .frame(width: 80)
                Spacer()
                Text("預覽")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button() {
                        publicDraft()
                    } label: {
                        Text("發布")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 30)
                    }
                    .background(ColorConstants.systemMainColor.opacity(selectedCategory.isEmpty ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(selectedCategory.isEmpty)
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            VStack{
                HStack{
                    UITextIssueSettingTitle(title: "類別")
                    Menu {
                        Picker("Options", selection: $selectedCategory) {
                            ForEach(categoryList, id: \.self) { order in
                                Text(order)
                            }
                        }
                    } label: {
                        Text(selectedCategory.isEmpty ? "點擊選擇" : selectedCategory)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(selectedCategory.isEmpty ? .gray.opacity(0.5): ColorConstants.systemDarkColor.opacity(0.9))
                        Spacer()
                    }
                    UITextIssueSettingTitle(title: "匿名")
                    Menu {
                        Picker("Options", selection: $selectAnonymous) {
                            ForEach(anonymousOptions, id: \.self) { order in
                                Text(order)
                            }
                        }
                    } label: {
                        Text(selectAnonymous)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(selectAnonymous.isEmpty ? .gray.opacity(0.5): ColorConstants.systemDarkColor.opacity(0.9))
                        Spacer()
                    }
                    .onChange(of: selectAnonymous) {
                        if selectAnonymous == "on" {
                            isAnonymous = true
                        }
                        else {
                            isAnonymous = false
                        }
                    }
                }
                .frame(height: 36)
                .padding(.horizontal, 5)
                UIRectangleLine(opacity: 0.7)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "標籤")
                    TextField("至多五個，以空格分隔 #標籤（選填）", text: $tags)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .frame(height: 36)
                        .onChange(of: tags) { oldValue, newValue in
                                var tagArray = newValue.split(separator: " ").map { String($0) }.filter { !$0.isEmpty }
                                if tagArray.count > 5 {
                                    tagArray = Array(tagArray.prefix(5))
                                    tags = tagArray.joined(separator: " ")
                                }
                            }
                }
                .padding(.horizontal, 5)
                UIRectangleLine(opacity: 0.7)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "懸賞點數")
                    TextField("（選填）", text: $reward)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .keyboardType(.numberPad)
                        .frame(height: 36)
                        .onChange(of: reward) {
                            let filtered = reward.filter { $0.isNumber }
                            if filtered != reward {
                                reward = filtered
                            }
                            if filtered.isEmpty {
                                reward = ""
                            }
                            if let number = Int(filtered) {
                                if number < 0 {
                                    reward = String(0)
                                }
                                else if number > point {
                                    reward = String(point)
                                }
                            }
                        }
                    Text("點數：\(point)")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                        .frame(height: 36)
                        .padding(.trailing, 10)
                }
                .padding(.horizontal, 5)
                UIRectangleLine(opacity: 0.7)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "截止時間")
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .labelsHidden()
                    Spacer()
                }
                .padding(.horizontal, 5)
                UIRectangleLine(opacity: 0.7)
                    .padding(.top, -5)
            }
            .padding(.horizontal, 10)
            HStack {
                if isAnonymous {
                    UIProfileImage(photo: userAvatar, width: 40, height: 40)
                    Text("匿名精靈")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                        .foregroundColor(ColorConstants.systemSubColor)
                }
                else {
                    UIProfileImage(photo: userAvatar, width: 40, height: 40)
                    Text(userName)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                        .foregroundColor(ColorConstants.systemSubColor)
                }
                
                if !isAnonymous {
                    UITextLevel(totalExp: exp, width: 32, height: 14, size: 12)
                    Spacer()
                    Button{
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                .frame(width: 66, height: 24)
                            HStack{
                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                    .foregroundColor(ColorConstants.systemMainColor)
                                    .padding(.trailing, -7)
                                Text("關注")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                    .foregroundColor(ColorConstants.systemMainColor)
                            }
                        }
                    }
                    .disabled(true)
                }
            }
            .padding(.horizontal, 15)
            UIRectangleLine(opacity: 0.7)
                .padding(.horizontal, 10)
            ScrollView{
                VStack(alignment: .leading){
                    Text(title)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                        .foregroundColor(ColorConstants.systemDarkColor)
                    HStack{
                        if !selectedCategory.isEmpty {
                            Text(selectedCategory)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .lineLimit(1)
                                .padding(.horizontal, 3)
                                .background(ColorConstants.systemMainColor.opacity(0.2))
                                .cornerRadius(3)
                        }
                        Text("Deadline : \(dateFormatter.string(from: selectedDate))")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("-")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("Point : \(reward)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
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
                }
            }
            .padding(.horizontal, 15)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.draftId = keychain.get("draftId") ?? ""
            self.description = keychain.get("description") ?? ""
            self.title = keychain.get("title") ?? ""
            self.userName = keychain.get("userName") ?? ""
            loadpoint()
        }
    }
    
    func loadpoint() {
        guard let userUid = keychain.get("authUid") else {
            print("(IssueSettingView) 無法取得用戶 UID")
            return
        }
        
        db.collection("users").document(userUid).getDocument { document, error in
            if let document = document, document.exists {
                
                self.point = document.data()?["point"] as? Int ?? 0
                self.exp = document.data()?["exp"] as? Int ?? 0
            }
        }
    }
    
    func publicDraft() {
        guard let userUid = keychain.get("authUid") else {
            print("(IssueSettingView) 用戶未登入")
            return
        }
        
        let categoryToCollection: [String: String] = [
            "生活": "life",
            "學術": "academic",
            "科技": "technology",
            "健康": "health",
            "理財": "finance",
            "情感": "emotion",
            "娛樂": "entertainment",
            "其他": "other"
        ]
        
        let tagsArray = tags.components(separatedBy: " ").filter { !$0.isEmpty && $0.starts(with: "#") }.prefix(5)
        var targetCollection = "public_general"
        
        if let categorySuffix = categoryToCollection[selectedCategory] {
            targetCollection = "public_" + categorySuffix
        }
        let postRef = db.collection(targetCollection).document()
        let documentId = postRef.documentID
        
        let author = if(isAnonymous) { "匿名精靈" } else { keychain.get("userName")!}
        
        let draftData: [String: Any] = [
            "authorUid": userUid,
            "author": author,
            "title": title,
            "description": description,
            "category": selectedCategory,
            "isAnonymous": isAnonymous,
            "tags": Array(tagsArray),
            "reward": Int(reward) ?? 0,
            "deadline": selectedDate,
            "createdAt": Timestamp(),
            "heart": 0,
            "commentCount": 0,
            "star": 0
        ]
        
        postRef.setData(draftData) { error in
            if let error = error {
                print("(IssueSettingView) 上傳到 \(targetCollection) 失敗: \(error.localizedDescription)")
                return
            }
            
            print("(IssueSettingView) 成功上傳到 \(targetCollection) 文件 documentID 是: \(documentId)")
            
            for tag in tagsArray {
                let indexData: [String: Any] = [
                    "tag": String(tag.dropFirst()),
                    "postId": documentId,
                    "collection": targetCollection,
                    "createdAt": Timestamp()
                ]
                
                db.collection("search").addDocument(data: indexData) { error in
                    if let error = error {
                        print("(IssueSettingView) 建立標籤索引失敗 for \(tag): \(error.localizedDescription)")
                    } else {
                        print("(IssueSettingView) 成功建立標籤索引 for \(tag)")
                    }
                }
            }
            
            self.db.collection("users")
                .document(userUid)
                .collection("publish")
                .document(documentId)
                .setData(["documentId": documentId, "collection": targetCollection, "createdAt": Timestamp()]) { error in
                    if let error = error {
                        print("(IssueSettingView) 儲存 documentId 失敗: \(error.localizedDescription)")
                    } else {
                        print("(IssueSettingView) 成功儲存 documentId 到 publish")
                    }
                }
            
            if let rewardPoint = Int(reward), rewardPoint > 0 {
                self.db.collection("users")
                    .document(userUid)
                    .updateData(["point": FieldValue.increment(Int64(-rewardPoint))]) { error in
                        if let error = error {
                            print("(IssueSettingView) 扣除點數失敗：\(error.localizedDescription)")
                        } else {
                            print("(IssueSettingView) 成功扣除 \(rewardPoint) 點")
                        }
                    }
            }
            
            if !draftId.isEmpty {
                self.db.collection("users")
                    .document(userUid)
                    .collection("drafts")
                    .document(draftId)
                    .delete { error in
                        if let error = error {
                            print("(IssueSettingView) 刪除舊草稿失敗: \(error.localizedDescription)")
                        } else {
                            print("(IssueSettingView) 成功刪除舊草稿 \(draftId)")
                        }
                    }
            }
            
            DispatchQueue.main.async {
                nav.push(.publish)
            }
        }
    }
}

#Preview {
    IssueSettingView()
        .environmentObject(NavigationCoordinator())
}
