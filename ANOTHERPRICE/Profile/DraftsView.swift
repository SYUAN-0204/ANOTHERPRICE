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
        var isSelected: Bool = false
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
                            hasSelection = false
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
                            if(hasSelection){
                                for i in drafts.indices {
                                    drafts[i].isSelected = false
                                }
                                hasSelection = false
                            }else{
                                for i in drafts.indices {
                                    drafts[i].isSelected = true
                                }
                                hasSelection = true
                            }
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

                    Group {
                        if isMultiSelect {
                            // 多選狀態，不要包 NavigationLink
                            UIComplexMyArticle(
                                isSelected: $drafts[index].isSelected,
                                selecte: $isMultiSelect,
                                trashcanState: $isTrashSelected,
                                title: draft.title.isEmpty ? "無標題" : draft.title,
                                date: "Last Edit : 2025-04-03",
                                content: draft.description.isEmpty ? "無敘述" : draft.description
                            )
                        } else {
                            NavigationLink(
                                destination: LazyView(IssueEditView(
                                    isDraft: true,
                                    draftId: draft.id,
                                    title: draft.title,
                                    description: draft.description
                                ))
                            ) {
                                UIComplexMyArticle(
                                    isSelected: .constant(false),
                                    selecte: .constant(false),
                                    trashcanState: .constant(false),
                                    title: draft.title.isEmpty ? "無標題" : draft.title,
                                    date: "Last Edit : 2025-04-03",
                                    content: draft.description.isEmpty ? "無敘述" : draft.description
                                )
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
                    Text("沒有更多草稿了")
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
                        print("(DraftsView)被勾選的草稿有：")
                        for draft in selectedDrafts {
                            print("- \(draft.title) (\(draft.id))")
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
