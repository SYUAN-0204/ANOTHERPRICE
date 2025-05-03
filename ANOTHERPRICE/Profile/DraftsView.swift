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
    @State private var keychain = KeychainSwift()
    @State private var isFetchingMore = false
    @State private var authUid: String? = nil
    @State private var drafts: [Draft] = []
    @State private var isLoading = true
    @State private var hasMoreData = true
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var noDraftsMessage: String? = nil
    @State private var db = Firestore.firestore()
    private var hasSelection: Bool {
        drafts.contains(where: { $0.isSelected })
    }
    @State private var selectedDraft: Draft? = nil
    @State private var isNavigating = false
    
    struct Draft: Identifiable, Equatable {
        var id: String
        var title: String
        var description: String
        var isSelected: Bool = false
        var formattedDate: String 
    }
    
    @EnvironmentObject var nav: NavigationCoordinator
    @Binding var selectedTab: TabIdentifier
    
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
                .frame(width: 120)
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
                            }else{
                                for i in drafts.indices {
                                    drafts[i].isSelected = true
                                }
                            }
                        } label: {
                            Text(hasSelection ? "取消選擇" : "全選")
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
                Text(noDraftsMessage ?? "誠實精靈搖了搖草稿箱，發現一張草稿都沒有")
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
                        Text("建立草稿")
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
                                UIComplexMyArticle(
                                    isSelected: $drafts[index].isSelected,
                                    selecte: $isMultiSelect,
                                    trashcanState: $isTrashSelected,
                                    title: draft.title.isEmpty ? "無標題" : draft.title,
                                    date: "Last Edit : \(draft.formattedDate)",
                                    content: draft.description.isEmpty ? "無敘述" : draft.description,
                                    onDelete: {
                                        deleteDraft(draftId: draft.id)
                                    }
                                )
                            } else {
                                Button(){
                                    nav.push(.issueEdit(isDraft: true, draftId: draft.id, title: draft.title, description: draft.description))
                                } label:
                                /*NavigationLink(
                                 destination: /*LazyView(IssueEditView(
                                               isDraft: true,
                                               draftId: draft.id,
                                               title: draft.title,
                                               description: draft.description
                                               ))*/tempView()
                                 )*/ {
                                     UIComplexMyArticle(
                                        isSelected: .constant(false),
                                        selecte: .constant(false),
                                        trashcanState: .constant(false),
                                        title: draft.title.isEmpty ? "無標題" : draft.title,
                                        date: "Last Edit : 2025-04-03",
                                        content: draft.description.isEmpty ? "無敘述" : draft.description,
                                        onDelete: {
                                            deleteDraft(draftId: draft.id)
                                        }
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
                        UIRectangleLine(opacity: 0.3)
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
                    UIRectangleLine(opacity: 0.7)
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
        var query: Query = db.collection("users").document(userUid).collection("drafts")
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
                print("獲取草稿錯誤: \(error?.localizedDescription ?? "未知錯誤")")
                return
            }
            
            let newDrafts = snapshot.documents.map { doc in
                let updatedAtTimestamp = doc.data()["updatedAt"] as? Timestamp
                let updatedAt = updatedAtTimestamp?.dateValue() ?? Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = dateFormatter.string(from: updatedAt)
                
                return Draft(
                    id: doc.documentID,
                    title: doc.data()["title"] as? String ?? "無標題",
                    description: doc.data()["description"] as? String ?? "無描述",
                    formattedDate: formattedDate
                )
            }
            
            if initial {
                drafts = newDrafts
            } else {
                drafts.append(contentsOf: newDrafts)
            }
            
            lastDocument = snapshot.documents.last
            hasMoreData = newDrafts.count >= (initial ? 8 : 5)
            
            if drafts.isEmpty {
                noDraftsMessage = "誠實精靈搖了搖草稿箱，發現一張草稿都沒有"
            } else {
                noDraftsMessage = nil
            }
            
            //print("(DraftsView)檢查分頁載入：拿到 \(snapshot.documents.count) 筆草稿")
        }
    }
    
    func deleteDraft(draftId: String) {
        guard let userUid = keychain.get("authUid") else { return }
        
        db.collection("users").document(userUid).collection("drafts").document(draftId).delete() { error in
            if let error = error {
                print("刪除草稿失敗: \(error.localizedDescription)")
            } else {
                print("(DraftsView)刪除草稿 \(draftId) 成功")
                drafts.removeAll { $0.id == draftId }
            }
        }
    }
}

#Preview {
    DraftsView(selectedTab: .constant(.profile))
        .environmentObject(NavigationCoordinator())
}
