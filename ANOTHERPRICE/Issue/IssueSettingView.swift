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
    @State private var isPublish: Bool = false
    @State private var inputText:String = ""
    @State private var selectedCategory:String = ""
    @State private var categoryList = ["生活", "學術", "科技", "健康", "理財", "情感", "娛樂", "其他"] //可以考慮從firebase抓資料，方便類別擴充
    @State private var tags:String = ""
    @State private var reward:String = ""
    @State private var balance:Int = 34
    @State private var selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    var body: some View {
        VStack{
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
                    .background(ColorConstants.systemMainColor.opacity(isPublish ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(isPublish)
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
                }
                .frame(height: 36)
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "標籤")
                    TextField("至多五個（選填）", text: $tags)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .frame(height: 36)
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "懸賞點數")
                    TextField("（選填）", text: $reward)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .keyboardType(.numberPad)
                        .frame(height: 36)
                    Text("點數：\(balance)")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                        .frame(height: 36)
                        .padding(.trailing, 10)
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "截止時間")
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .labelsHidden()
                    Spacer()
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
            }
            .padding(.horizontal, 10)
            ScrollView{
                Text("還沒想好預覽顯示排版\n\(title)\n\(description)")
            }
            .padding(.horizontal, 15)
            .padding(.top, 7)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.draftId = keychain.get("draftId") ?? ""
            self.description = keychain.get("description") ?? ""
            self.title = keychain.get("title") ?? ""
        }
    }
    
    func publicDraft() {
        // 確保 userUid 存在
        guard let userUid = keychain.get("authUid") else {
            print("用戶未登入")
            return
        }

        // 草稿資料
        let draftData: [String: Any] = [
            "author": userUid,
            "title": title,
            "description": description,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]
        
        // 上傳草稿資料到 'public' 集合
        db.collection("public").addDocument(data: draftData) { error in
            // 如果有錯誤，打印錯誤訊息並返回
            if let error = error {
                print("(IssueSettingView) 上傳草稿失敗: \(error.localizedDescription)")
                return
            }

            // 成功後，從 'public' collection 獲取文檔 ID
            let documentId = db.collection("public").document().documentID
            print("成功創建文檔，documentID 是: \(documentId)")

            // 儲存 documentID 到 'users/{userUid}/publish' 集合
            self.db.collection("users").document(userUid).collection("publish").document(documentId).setData([
                "documentId": documentId  // 只儲存 documentID
            ]) { error in
                if let error = error {
                    print("(IssueSettingView) 上傳 documentId 失敗: \(error.localizedDescription)")
                } else {
                    print("(IssueSettingView) 成功上傳 documentId: \(documentId)")
                }
            }
        }
        
        // 刪除舊草稿（如果有 draftId）
        if !draftId.isEmpty {
            db.collection("users")
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
    }

}

#Preview {
    IssueSettingView()
}
