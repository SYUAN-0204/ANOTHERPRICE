//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct HomeView: View {
    @State private var categoryList = ["生活", "學術", "科技", "健康", "理財", "情感", "娛樂", "其他"]
    @State private var selectedCategory: String = "生活"
    @State private var drafts: [Draft] = []
    @State private var isLoading = false
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var hasMoreData = true
    @State private var isFetchingMore = false
    @State private var db = Firestore.firestore()
    
    struct Draft: Identifiable {
        var id: String
        var board: String
        var title: String
        var description: String
        var createdAt: Date
        var deadLine: String
        var lastCommentDate: String
        var heart: Int
        var commentCount: Int
        var reward: Int
    }
    
    let categoryToCollection: [String: String] = [
        "生活": "public_life",
        "學術": "public_academic",
        "科技": "public_technology",
        "健康": "public_health",
        "理財": "public_finance",
        "情感": "public_emotion",
        "娛樂": "public_entertainment",
        "其他": "public_other"
    ]
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(categoryList, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            fetchDrafts(initial: true)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(selectedCategory == category ?
                                        .white.opacity(0.3) :
                                            Color.clear)
                                    .frame(height: 28)
                                Text(category)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
                .padding(.horizontal, 10)
            }
            .padding(.bottom, 3)
            .background(ColorConstants.systemMainColor)
            ScrollView {
                ForEach(drafts) { draft in
                    let category = categoryToCollection[draft.board] ?? "life"
                    UIComplexIssueCard(
                        destination: PostDetailView(category: draft.board,documentID: draft.id,isMyDisplayView: false),
                        title: draft.title,
                        date: draft.deadLine,
                        common: draft.lastCommentDate,
                        coin: draft.reward,
                        content: draft.description,
                        like: false,
                        heart: draft.heart,
                        message: draft.commentCount,
                        author: "誠實精靈",
                        code: "\(category)_\(draft.id)",
                        http: "https://www.anotherprice.com"
                    )
                }
                
                if isFetchingMore {
                    ProgressView("載入更多中...")
                        .padding(.vertical, 10)
                }
                
                if !hasMoreData && !drafts.isEmpty {
                    Text("沒有更多資料了")
                        .foregroundColor(.gray)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                        .padding(.vertical, 10)
                }
            }
        }
        .onAppear {
            fetchDrafts(initial: true)
        }
    }
    
    func fetchDrafts(initial: Bool) {
        isLoading = true
        
        let category = categoryToCollection[selectedCategory] ?? "life"
        var query: Query = db.collection(category)
            .order(by: "createdAt", descending: true)
        
        if initial {
            drafts.removeAll()
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
                
                group.enter()
                db.collection(category).document(documentId).getDocument { publicDoc, error in
                    defer { group.leave() }
                    
                    guard let data = publicDoc?.data() else {
                        print("(HomeView)讀取 \(category)/\(documentId) 失敗")
                        return
                    }
                    
                    let deadline = (data["deadline"] as? Timestamp)?.dateValue() ?? Date()
                    let lastComment = (data["lastComment"] as? Timestamp)?.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: deadline)
                    let lastCommentDate = lastComment != nil ? dateFormatter.string(from: lastComment!) : ""
                    
                    let draft = Draft(
                        id: documentId,
                        board: (data["category"] as! String),
                        title: data["title"] as? String ?? "無標題",
                        description: data["description"] as? String ?? "無敘述",
                        createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        deadLine: formattedDate,
                        lastCommentDate: lastCommentDate.isEmpty ? "none" : lastCommentDate,
                        heart: data["heart"] as? Int ?? 0,
                        commentCount: data["commentCount"] as? Int ?? 0,
                        reward: data["reward"] as? Int ?? 0
                    )
                    newDrafts.append(draft)
                }
            }
            
            group.notify(queue: .main) {
                if initial {
                    drafts = newDrafts.sorted { $0.createdAt > $1.createdAt }  // Sort by createdAt in descending order
                } else {
                    drafts.append(contentsOf: newDrafts.sorted { $0.createdAt > $1.createdAt })  // Ensure new drafts are sorted
                }
                
                lastDocument = snapshot.documents.last
                hasMoreData = newDrafts.count >= (initial ? 8 : 5)
            }
        }
    }
}

#Preview {
    HomeView()
}
