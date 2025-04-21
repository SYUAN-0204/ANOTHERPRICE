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
    @State private var reward:String = ""
    @State private var balance:Int = 34
    @State private var selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var 匿名 = false
    @State private var selected匿名:String = "off"
    @State private var 匿名List = ["on", "off"]
    
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    
    @EnvironmentObject var nav: NavigationCoordinator
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"  // 自定義格式
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
                        nav.push(.publish)
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
                        Picker("Options", selection: $selected匿名) {
                            ForEach(匿名List, id: \.self) { order in
                                Text(order)
                            }
                        }
                    } label: {
                        Text(selected匿名)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(selected匿名.isEmpty ? .gray.opacity(0.5): ColorConstants.systemDarkColor.opacity(0.9))
                        Spacer()
                    }
                    .onChange(of: selected匿名) {
                        if selected匿名 == "on" {
                            匿名 = true
                        }
                        else {
                            匿名 = false
                        }
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
                    TextField("至多五個，以空格分隔 #標籤（選填）", text: $tags)
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
                                else if number > balance {
                                    reward = String(balance)
                                }
                            }
                        }
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
            HStack {
                NavigationLink{
                    tempView()
                } label: {
                    if 匿名 {
                        Image(uiImage: userAvatar)
                            .resizable()
                            .scaledToFill() // 確保填滿圓形
                            .frame(width: 40, height: 40) // 限制大小
                            .background(Color(.systemGray6))
                            .clipShape(Circle()) // 剪裁為圓形
                            .overlay(
                                Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                            )
                        Text("匿名精靈")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                            .foregroundColor(ColorConstants.systemSubColor)
                    }
                    else {
                        Image(uiImage: userAvatar)
                            .resizable()
                            .scaledToFill() // 確保填滿圓形
                            .frame(width: 40, height: 40) // 限制大小
                            .background(Color(.systemGray6))
                            .clipShape(Circle()) // 剪裁為圓形
                            .overlay(
                                Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                            )
                        Text("這是另外的價錢")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                            .foregroundColor(ColorConstants.systemSubColor)
                    }
                }
                .disabled(匿名)
                if !匿名 {
                    UITextLevel(totalExp: 3564)
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
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
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
                        Text("Point : \(balance)")
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
        }
    }
    
    func publicDraft() {
        guard let userUid = keychain.get("authUid") else {
            print("(IssueSettingView) 用戶未登入")
            return
        }
        
        let publicRef = db.collection("public").document()
        let documentId = publicRef.documentID
        
        let draftData: [String: Any] = [
            "author": userUid,
            "title": title,
            "description": description,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]
        
        publicRef.setData(draftData) { error in
            if let error = error {
                print("(IssueSettingView) 上傳草稿失敗: \(error.localizedDescription)")
                return
            }
            
            print("(IssueSettingView) 成功上傳 public 文件 documentID 是: \(documentId)")
            
            self.db.collection("users")
                .document(userUid)
                .collection("publish")
                .document(documentId)
                .setData(["documentId": documentId,"updatedAt":  Timestamp()]) { error in
                    if let error = error {
                        print("(IssueSettingView) 儲存 documentId 失敗: \(error.localizedDescription)")
                    } else {
                        print("(IssueSettingView) 成功儲存 documentId 到 publish")
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
        }
    }
    
}

#Preview {
    IssueSettingView()
        .environmentObject(NavigationCoordinator())
}
