//
//  TempView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/17.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct IssueView: View {
    @State private var drafts: [Draft] = []
    @State private var isLoading = true
    @State private var isFetchingMore = false
    @State private var hasMoreData = true
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var keychain = KeychainSwift()
    @State private var authUid: String? = nil
    @State private var noDraftsMessage: String? = nil
    @State private var showLoginView = false
    
    @EnvironmentObject var nav: NavigationCoordinator
    
    struct Draft: Identifiable, Equatable {
        var id: String
        var title: String
        var description: String
    }
    
    var body: some View {
        ZStack{
            VStack{
                Button(){
                    nav.push(.issueEdit(isDraft: false, draftId: nil, title: "", description: ""))
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .stroke(ColorConstants.systemMainColor, style: StrokeStyle(lineWidth: 1))
                        HStack{
                            Image(systemName: "pencil.line")
                                .font(.system(size: 20))
                                .foregroundColor(ColorConstants.systemMainColor)
                            Text("新建問題")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 80)
                }
                .padding(.top, 20)
                .padding(.horizontal, 8)
                HStack {
                    Text("草稿記錄")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.top, 12)
                
                if isLoading {
                    VStack {
                        Text("加載中...")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }else {
                    if let noDraftsMessage = noDraftsMessage {
                        Text(noDraftsMessage)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                            .multilineTextAlignment(.center)
                    }
                    else{
                        ScrollView {
                            LazyVStack {
                                ForEach(drafts.indices, id: \.self) { index in
                                    let draft = drafts[index]
                                    Button(){
                                        nav.push(.issueEdit(isDraft: true, draftId: draft.id, title: draft.title, description: draft.description))
                                    } label:{
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .frame(height: 80)
                                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                            VStack(alignment: .leading) {
                                                Text(draft.title.isEmpty ? "無標題":draft.title)
                                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                                    .foregroundColor(ColorConstants.systemDarkColor)
                                                    .lineLimit(1)
                                                Text(draft.description.isEmpty ? "無描述\n":draft.description + "\n")
                                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                                    .foregroundColor(.gray)
                                                    .padding(.top, -10)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                                HStack{
                                                    Spacer()
                                                }
                                            }
                                            .padding(.horizontal, 10)
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                    .onAppear {
                                        if index == drafts.count - 1 && hasMoreData && !isFetchingMore {
                                            fetchDrafts(initial: false)
                                        }
                                    }
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
                        }
                    }
                    
                    Spacer()
                }
            }
            if (authUid == nil){
                Color.white.opacity(0.9)
                VStack {
                    Text("登入即可體驗完整功能")
                        .font(.custom("NotoSerifTC-Regular", size: 20))
                        .foregroundColor(ColorConstants.systemSubColor)
                    UIButtonAccountCustom(title: "登入", action: {
                        showLoginView = true
                    })
                    .frame(width: 160)
                    .sheet(isPresented: $showLoginView) {
                        LoginView()
                            .onDisappear {
                                self.authUid = keychain.get("authUid")
                                
                                print("(IssueView)Auth UID: \(authUid ?? "nil")")
                            }
                            .presentationDetents([.fraction(0.9)])
                    }
                }
            }
        }
        .padding(.horizontal, 10)
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
    IssueView()
        .environmentObject(NavigationCoordinator())
}
