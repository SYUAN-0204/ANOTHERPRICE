//
//  TempView2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct IssueEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isDraft:Bool
    @State var draftId:String?
    @State var showTip:Bool = false
    @State var title:String = ""
    @State var description:String = ""
    @State var keychain = KeychainSwift()
    @State var db = Firestore.firestore()

    
    var body: some View {
        
        VStack{
            HStack {
                HStack{
                    Button {
                        if title.isEmpty && description.isEmpty {
                            dismiss()
                        }
                        else{
                            showTip = true
                        }
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
                Text("提問")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("發布")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 30)
                    }
                    .background(ColorConstants.systemMainColor.opacity(title.isEmpty ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(title.isEmpty)
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            ScrollView{
                TextEditor(text: $title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    //這邊加了基本高度
                    .frame(height: 50)
                    .onChange(of: title) {
                        if title.count > 50 {
                            title = String(title.prefix(50))
                        }
                    }
                    .overlay(
                        Group {
                            if title.isEmpty {
                                HStack{
                                    Text("標題")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                            }
                        }
                    )
                    .padding(10)
                HStack{
                    Spacer()
                    Text("\(title.count)/50")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                TextEditor(text: $description)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    //這邊加了基本高度
                    .frame(height: 50)
                    .overlay(
                        Group {
                            if description.isEmpty {
                                HStack{
                                    Text("問題描述")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                            }
                        }
                    )
                    .padding(10)
                Spacer()
            }
            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 36)
                Text("工具列，還沒做")
            }
        }
        .alert("草稿", isPresented: $showTip) {
            if isDraft {
                Button("刪除草稿", role: .destructive) {
                    deleteDraft()
                    dismiss()
                }
                Button("儲存變更") {
                    updateDraft()
                    dismiss()
                }
            } else {
                Button("刪除草稿", role: .destructive) {
                    print("刪除草稿")
                    dismiss()
                }
                Button("儲存草稿") {
                    saveDraft()
                    dismiss()
                }
            }
            Button("取消", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(isDraft ? "你要如何處理這篇草稿？" : "你要如何處理新建的問題？")
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func deleteDraft() {
        let userUid = keychain.get("authUid") ?? nil
        if(userUid == nil) {
            return
        }
        
        db.collection("users").document(userUid!).collection("drafts").document(draftId!).delete() { error in
            if let error = error {
                print("刪除草稿失敗: \(error.localizedDescription)")
            } else {
                print("刪除\(draftId!)草稿成功")
            }
        }
    }
    
    func saveDraft() {
        let userUid = keychain.get("authUid") ?? nil
        if(userUid == nil) {
            return
        }
        
        let draftData: [String: Any] = [
            "title": title,
            "description": description,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]
        
        db.collection("users").document(userUid!).collection("drafts").addDocument(data: draftData) { error in
            if let error = error {
                print("儲存草稿失敗: \(error.localizedDescription)")
            } else {
                print("草稿儲存成功")
            }
        }
    }
    
    func updateDraft() {
        let userUid = keychain.get("authUid") ?? nil
        if(userUid == nil) {
            return
        }
        
        let db = Firestore.firestore()
        let updatedData: [String: Any] = [
            "title": title,
            "description": description,
            "updatedAt": Timestamp()
        ]
        
        db.collection("users").document(userUid!).collection("drafts").document(draftId!).updateData(updatedData) { error in
            if let error = error {
                print("更新草稿失敗: \(error.localizedDescription)")
            } else {
                print("草稿\(draftId!)更新成功")
            }
        }
    }
}

#Preview {
    IssueEditView(isDraft: false, draftId: nil)
}
