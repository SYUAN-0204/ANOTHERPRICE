//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct FavoritesView: View {
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
    
    struct Draft: Identifiable, Equatable {
        var id: String
        var board: String
        var title: String
        var description: String
        var isSelected: Bool = false
        var creatAt: Date
        var upLoadDate: String
        var lastCommentDate: String
        var heart: Int
        var commentCount: Int
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
                Text("我的收藏")
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
                .frame(width: 80)
            }
            .frame(height: 36)
            if isLoading {
                VStack {
                    Text("加載中...")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else if drafts.isEmpty && !hasMoreData {
                Text(noDraftsMessage ?? "誠實精靈翻了翻收藏箱，發現你還沒收藏過問題")
                    .foregroundColor(.gray)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .padding(.vertical, 10)
                    .padding(.top, 20)
                Button {
                    dismiss()
                } label: {
                    ZStack {
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
                                    selecte: $isMultiSelect, trashcanState: $isTrashSelected, board: draft.board, title: draft.title, date: "Upload At : \(draft.upLoadDate) - Last Comment : \(draft.lastCommentDate)", content: draft.description, heart: draft.heart, message: draft.commentCount, author: "誠實精靈", code: "TS4F64WX23DW", http: "http://anotherprice.com/TS4F64WX23DW"
                                )
                            } else {
                                NavigationLink(destination:                     PostDetailView(category: "12",documentID:"123",isMyDisplayView: false)) {
                                    UIComplexUploadArticle(isSelected: .constant(false),selecte: .constant(false), trashcanState: .constant(false), board: draft.board, title: draft.title, date: "Last Upload : \(draft.upLoadDate) ; Last Comment : \(draft.lastCommentDate)", content: draft.description, heart: draft.heart, message: draft.commentCount, author: "誠實精靈", code: "TS4F64WX23DW", http: "http://anotherprice.com/TS4F64WX23DW")
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
                        Text("沒有更多提問了")
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
        
        var query: Query = db.collection("users").document(userUid).collection("favorites")
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
                    
                    let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    let lastComment = (data["lastComment"] as? Timestamp)?.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: createdAt)
                    let lastCommentDate = lastComment != nil ? dateFormatter.string(from: lastComment!) : ""
                    
                    let draft = Draft(
                        id: documentId,
                        board: (data["category"] as! String),
                        title: data["title"] as? String ?? "無標題",
                        description: data["description"] as? String ?? "無描述",
                        creatAt: createdAt,
                        upLoadDate: formattedDate,
                        lastCommentDate: lastCommentDate,
                        heart: data["heart"] as! Int,
                        commentCount: data["commentCount"] as! Int
                    )
                    newDrafts.append(draft)
                }
            }
            
            group.notify(queue: .main) {
                if initial {
                       drafts = newDrafts.sorted { $0.creatAt > $1.creatAt }
                   } else {
                       drafts.append(contentsOf: newDrafts.sorted { $0.creatAt > $1.creatAt })
                   }
                
                lastDocument = snapshot.documents.last
                hasMoreData = newDrafts.count >= (initial ? 8 : 5)
            }
        }
    }
}

#Preview {
    FavoritesView()
}
