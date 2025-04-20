//
//  temp3.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct PublishView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var keychain = KeychainSwift()
    @State private var isLoading = true
    @State private var authUid: String? = nil
    @State private var isMultiSelect: Bool = false
    @State private var isSelected: Bool = false
    @State private var isTrashSelected: Bool = false
    private var hasSelection: Bool {
        drafts.contains(where: { $0.isSelected })
    }
    @State private var drafts: [Draft] = []
    @State private var isFetchingMore = false
    @State private var hasMoreData = true
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var noDraftsMessage: String? = nil
    @State private var db = Firestore.firestore()
    
    @EnvironmentObject var nav: NavigationCoordinator
    let isFromIssue: Bool
    @Binding var selectedTab: TabIdentifier
    
    struct Draft: Identifiable, Equatable {
        var id: String
        var title: String
        var description: String
        var isSelected: Bool = false
        var formattedDate: String
    }
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    if isMultiSelect {
                        Button() {
                            for i in drafts.indices {
                                drafts[i].isSelected = false
                            }
                            isMultiSelect = false
                        } label: {
                            Text("取消")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    else {
                        Button {
                            if isFromIssue {
                                nav.popToRoot()
                            }
                            else {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 120)
                Spacer()
                Text("我的提問")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    if isMultiSelect {
                        Button() {
                            if(hasSelection){
                                for i in drafts.indices {
                                    drafts[i].isSelected = false
                                }
                            }else{
                                for i in drafts.indices {
                                    drafts[i].isSelected = true
                                }
                            }
                        } label: {
                            Text(hasSelection ? "取消全選" : "全選")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    else {
                        Button {
                            isMultiSelect = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .padding(.trailing, 5)
                        }
                        .disabled(isTrashSelected)
                    }
                }
                .padding(.trailing, 10)
                .frame(width: 120)
            }
            .frame(height: 36)
            
            
            if drafts.isEmpty {
                Text(noDraftsMessage ?? "誠實精靈翻了翻提問箱，發現你還沒提過問題")
                    .foregroundColor(.gray)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .padding(.vertical, 10)
                    .padding(.top, 20)
                Button{
                    selectedTab = TabIdentifier.issue
                    dismiss()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                            .frame(width: 120, height: 30)
                        Text("建立提問")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemMainColor)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                    }
                }
                Spacer()
            }
            else {
                ScrollView{
                    ForEach(drafts.indices, id: \.self) { index in
                        let draft = drafts[index]
                        Group {
                            if isMultiSelect {
                                UIComplexUploadArticle(
                                    isSelected: $drafts[index].isSelected,
                                    selecte: $isMultiSelect, trashcanState: $isTrashSelected, board: "科技", title: draft.title, date: "Last Upload : \(draft.formattedDate) ; Last Comment : 2025-04-03", content: draft.description, heart: 34, message: 45, author: "誠實精靈", code: "TS4F64WX23DW", http: "http://anotherprice.com/TS4F64WX23DW"
                                )
                            } else {
                                NavigationLink(destination: tempView()) {
                                    UIComplexUploadArticle(isSelected: .constant(false),selecte: .constant(false), trashcanState: .constant(false), board: "科技", title: draft.title, date: "Last Upload : \(draft.formattedDate) ; Last Comment : 2025-04-03", content: draft.description, heart: 34, message: 45, author: "誠實精靈", code: "TS4F64WX23DW", http: "http://anotherprice.com/TS4F64WX23DW")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                        .onAppear {
                            if index == drafts.count - 1 && hasMoreData && !isFetchingMore {
                                fetchDrafts(initial: false)
                            }
                        }
                        
                        Rectangle()
                            .fill(.gray.opacity(0.4))
                            .frame(height: 1)
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
                Spacer()
                if isMultiSelect {
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                    Button() {
                        let selectedDrafts = drafts.filter { $0.isSelected }
                        //print("(DraftsView)被勾選的草稿有：")
                        for draft in selectedDrafts {
                            deleteDraft(draftId: draft.id)
                            //print("- \(draft.title) (\(draft.id))")
                        }
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(ColorConstants.tomatoRed.opacity(hasSelection ? 1.0 : 0.7))
                            Text("刪除")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.tomatoRed.opacity(hasSelection ? 1.0 : 0.7))
                        }
                    }
                    .frame(height: 28)
                    .disabled(!hasSelection)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.authUid = keychain.get("authUid")
            drafts.removeAll()
            lastDocument = nil
            hasMoreData = true
            fetchDrafts(initial: true)
        }
    }
    
    func fetchDrafts(initial: Bool) {
        guard let userUid = keychain.get("authUid") else { return }
        guard !isFetchingMore else { return }
        
        let db = Firestore.firestore()
        var query: Query = db.collection("users").document(userUid).collection("publish")
            .order(by: "updatedAt", descending: true)
        
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
                print("獲取 publish 錯誤: \(error?.localizedDescription ?? "未知錯誤")")
                return
            }
            
            let group = DispatchGroup()
            var newDrafts: [Draft] = []
            
            for doc in snapshot.documents {
                let documentId = doc.documentID
                
                group.enter()
                db.collection("public").document(documentId).getDocument { publicDoc, error in
                    defer { group.leave() }
                    
                    if let error = error {
                        print("讀取 public/\(documentId) 失敗: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let data = publicDoc?.data() else {
                        print("public/\(documentId) 不存在或無資料")
                        return
                    }
                    
                    let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: updatedAt)
                    
                    let draft = Draft(
                        id: documentId,
                        title: data["title"] as? String ?? "無標題",
                        description: data["description"] as? String ?? "無描述",
                        formattedDate: formattedDate
                    )
                    
                    newDrafts.append(draft)
                }
            }
            
            group.notify(queue: .main) {
                if initial {
                    drafts = newDrafts
                } else {
                    drafts.append(contentsOf: newDrafts)
                }
                
                lastDocument = snapshot.documents.last
                hasMoreData = newDrafts.count >= (initial ? 8 : 5)
                
                noDraftsMessage = drafts.isEmpty ? "誠實精靈翻了翻提問箱，發現你還沒提過問題" : nil
            }
        }
    }
    
    func deleteDraft(draftId: String) {
        guard let userUid = keychain.get("authUid") else { return }
        
        db.collection("public").document(draftId).delete() { error in
            if let error = error {
                print("刪除 public/{\(draftId)} 資料失敗: \(error.localizedDescription)")
            } else {
                print("(DraftsView) 刪除 public/{\(draftId)} 資料成功")
                
                db.collection("users").document(userUid).collection("drafts").document(draftId).delete() { error in
                    if let error = error {
                        print("刪除 users/{\(userUid)}/drafts 中的草稿失敗: \(error.localizedDescription)")
                    } else {
                        print("(DraftsView) 刪除 users/{\(userUid)}/drafts 中的草稿成功")
                    }
                }
            }
        }
    }
}

#Preview {
    PublishView(isFromIssue: true, selectedTab: .constant(.profile))
        .environmentObject(NavigationCoordinator())
}
