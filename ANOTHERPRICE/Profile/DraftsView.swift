//
//  temp.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct DraftsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isMultiSelect: Bool = false
    @State private var isSelected: Bool = false
    @State private var isTrashSelected: Bool = false
    @State private var hasSelection: Bool = false
    @State private var keychain = KeychainSwift()
    @State private var isFetchingMore = false
    @State private var authUid: String? = nil
    @State private var drafts: [Draft] = []
    @State private var isLoading = true
    @State private var hasMoreData = true
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var noDraftsMessage: String? = nil
    
    
    struct Draft: Identifiable, Equatable {
        var id: String
        var title: String
        var description: String
    }
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    if isMultiSelect {
                        Button() {
                            isMultiSelect = false
                        } label: {
                            Text("取消")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    else {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 80)
                Spacer()
                Text("我的草稿")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    if isMultiSelect {
                        Button() {
                            
                        } label: {
                            Text("全選")
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
                .frame(width: 80)
            }
            .frame(height: 36)
            ScrollView{
                ForEach(drafts.indices, id: \.self) { index in
                    let draft = drafts[index]
                    NavigationLink {
                        LazyView(IssueEditView(isDraft: true, draftId: draft.id, title: draft.title, description: draft.description))
                    } label: {
                        UIComplexMyArticle(selecte: $isMultiSelect, trashcanState: $isTrashSelected, title: draft.title, date: "Last Edit : 2025-04-03", content: draft.description)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                }
            }
            Spacer()
            if isMultiSelect {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                Button() {
                    
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
        guard !isFetchingMore else { return } // 避免重複請求
        
        let db = Firestore.firestore()
        var query: Query = db.collection("users").document(userUid).collection("drafts")
            .order(by: "updatedAt", descending: true)
        
        // 一開始至少要有8筆，不然就會視為已滑到底
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
                print("獲取草稿錯誤: \(error?.localizedDescription ?? "未知錯誤")")
                return
            }
            
            let newDrafts = snapshot.documents.map { doc in
                Draft(
                    id: doc.documentID,
                    title: doc.data()["title"] as? String ?? "無標題",
                    description: doc.data()["description"] as? String ?? "無描述"
                )
            }
            
            if initial {
                drafts = newDrafts
            } else {
                drafts.append(contentsOf: newDrafts)
            }
            
            lastDocument = snapshot.documents.last
            
            // 根據載入的資料決定是否有更多資料
            hasMoreData = newDrafts.count >= (initial ? 8 : 5)
            
            if drafts.isEmpty {
                noDraftsMessage = "暫無草稿"
            } else {
                noDraftsMessage = nil
            }
        }
    }
}

#Preview {
    DraftsView()
}
