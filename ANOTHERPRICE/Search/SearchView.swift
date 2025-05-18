//
//  temp1.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/29.
//

import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    @State var 抓到的Draft: Draft? = nil
    @State var 搜尋: String = ""
    @State var 關鍵字搜尋結果: Bool = false
    @State var 口令搜尋結果: Bool = false
    @State var 展開更多: Bool = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var 是否存在口令: Bool = false
    @State private var 歷史記錄: String = "一劍霜寒十四州出處"
    @State private var keywordSearchResults: [Draft] = []
    @State private var relatedUsers: [String: String] = [:]
    @State private var 熱門草稿: [Draft] = []
    @State private var 搜尋歷史記錄: [String] = []
    
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
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(ColorConstants.systemMainColor)
                        TextField("", text: $搜尋)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        if !搜尋.isEmpty {
                            Button(){
                                搜尋 = ""
                                關鍵字搜尋結果 = false
                                口令搜尋結果 = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.4))
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                Button {
                    saveToHistory(搜尋)
                    關鍵字搜尋結果 = true
                    let trimmed = 搜尋.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.hasPrefix("/*") && trimmed.hasSuffix("*/") {
                        口令搜尋結果 = true
                        fetchDraftFromCode(trimmed) { draft in
                            if let draft = draft {
                                是否存在口令 = true
                                self.抓到的Draft = draft
                            } else {
                                是否存在口令 = false
                            }
                        }
                    } else {
                        口令搜尋結果 = false
                        searchDraftsByKeyword(trimmed) { results in
                            self.keywordSearchResults = results
                        }
                        searchUsersByUserName(trimmed) { users in
                            self.relatedUsers = users
                        }
                    }
                } label: {
                    Text("搜尋")
                        .foregroundColor(ColorConstants.systemMainColor)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                }
                .disabled(搜尋.isEmpty)
                .padding(.horizontal, 7)
            }
            .frame(height: 32)
            .padding(.horizontal, 15)
            UIRectangleLine(opacity: 0.1)
            if 關鍵字搜尋結果 {
                if 口令搜尋結果 {
                    ScrollView{
                        HStack{
                            Text("口令結果")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        if 是否存在口令 {
                            if let draft = 抓到的Draft {
                                UIComplexIssueCard(
                                    destination: PostDetailView(category: draft.board, documentID: draft.id, isMyDisplayView: false),
                                    title: draft.title,
                                    date: draft.deadLine,
                                    common: draft.lastCommentDate,
                                    coin: draft.reward,
                                    content: draft.description,
                                    like: false,
                                    heart: draft.heart,
                                    message: draft.commentCount,
                                    author: "誠實精靈",
                                    code: "/*\(draft.board)_\(draft.id)*/",
                                    http: "https://www.anotherprice.com"
                                )
                                .padding(.vertical, -10)
                                .padding(.horizontal, 5)
                            }
                        }
                        else {
                            Text("查無口令 \(搜尋)")
                                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        }
                        HStack{
                            Text("熱門提問")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        ForEach(熱門草稿) { draft in
                            UIComplexIssueCard(
                                destination: PostDetailView(category: draft.board, documentID: draft.id, isMyDisplayView: false),
                                title: draft.title,
                                date: draft.deadLine,
                                common: draft.lastCommentDate,
                                coin: draft.reward,
                                content: draft.description,
                                like: false,
                                heart: draft.heart,
                                message: draft.commentCount,
                                author: "誠實精靈",
                                code: "/*\(draft.board)_\(draft.id)*/",
                                http: "https://www.anotherprice.com"
                            )
                            .padding(.vertical, -5)
                        }
                        .padding(.horizontal, 5)
                    }
                }
                else {
                    ScrollView(showsIndicators: false){
                        VStack{
                            HStack{
                                Text("相關用戶")
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                Spacer()
                                NavigationLink{
                                    ResultUserView(keyword: 搜尋)
                                } label: {
                                    Text("查看更多")
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                        .padding(.trailing, -2)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10))
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                        .padding(.leading, -4)
                                }
                            }
                            HStack{
                                ForEach(Array(relatedUsers.keys.prefix(5)), id: \.self) { uid in
                                    if let userName = relatedUsers[uid] {
                                        NavigationLink {
                                            DisplayView(isMyDisplayView: false)
                                        } label: {
                                            VStack {
                                                UIProfileImage(photo: userAvatar, width: 50, height: 50)
                                                Text(userName)  // 顯示用戶名稱
                                                    .foregroundColor(ColorConstants.systemDarkColor)
                                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 66)
                                            .padding(.horizontal, 1)
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            HStack{
                                Text("相關提問")
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                Spacer()
                            }
                            .padding(.vertical, 7)
                        }
                        .padding(.horizontal, 15)
                        ForEach(keywordSearchResults) { draft in
                            UIComplexIssueCard(
                                destination: PostDetailView(category: draft.board, documentID: draft.id, isMyDisplayView: false),
                                title: draft.title,
                                date: draft.deadLine,
                                common: draft.lastCommentDate,
                                coin: draft.reward,
                                content: draft.description,
                                like: false,
                                heart: draft.heart,
                                message: draft.commentCount,
                                author: "?",
                                code: "/*\(draft.board)_\(draft.id)*/",
                                http: "https://www.anotherprice.com"
                            )
                            .padding(.vertical, -5)
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            else {
                ScrollView(showsIndicators: false){
                    VStack{
                        HStack{
                            Text("歷史記錄")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                            Button(){
                                UserDefaults.standard.removeObject(forKey: "searchHistory")
                                    self.搜尋歷史記錄 = []
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                    .font(.system(size: 14))
                                    .frame(width: 28, height: 28)
                            }
                        }
                        //這裡預設五筆資料
                        ForEach(Array(搜尋歷史記錄.prefix(展開更多 ? 20 : 5).enumerated()), id: \.offset) { index, record in
                            Button {
                                搜尋 = record
                                saveToHistory(record)
                                // 執行搜尋
                            } label: {
                                HStack {
                                    Text(record)
                                        .foregroundColor(ColorConstants.systemDarkColor)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    Spacer()
                                    Button {
                                        removeHistory(at: index)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                    }
                                }
                            }
                            UIRectangleLine(opacity: 0.1)
                        }

                        HStack{
                            Spacer()
                            Button(){
                                展開更多.toggle()
                            } label: {
                                if !展開更多 {
                                    Text("展開更多")
                                        .foregroundColor(ColorConstants.systemSubColor)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                }
                                else {
                                    Text("收合")
                                        .foregroundColor(ColorConstants.systemSubColor)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                }
                            }
                        }
                        HStack{
                            Text("近期熱門提問")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                    }
                    .padding(.horizontal, 15)
                    ForEach(熱門草稿) { draft in
                        UIComplexIssueCard(
                            destination: PostDetailView(category: draft.board, documentID: draft.id, isMyDisplayView: false),
                            title: draft.title,
                            date: draft.deadLine,
                            common: draft.lastCommentDate,
                            coin: draft.reward,
                            content: draft.description,
                            like: false,
                            heart: draft.heart,
                            message: draft.commentCount,
                            author: "誠實精靈",
                            code: "/*\(draft.board)_\(draft.id)*/",
                            http: "https://www.anotherprice.com"
                        )
                        .padding(.vertical, -5)
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
        .onAppear {
            fetchHotDrafts()
            loadHistory()
        }
    }
    
    // 口令搜尋處理
    func parseCommand(_ input: String) -> (category: String, draftID: String)? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("/*") && trimmed.hasSuffix("*/") else {
            print("(SearchView)無效的口令格式")
            return nil
        }
        
        let inner = trimmed.dropFirst(2).dropLast(2)
        
        let components = inner.split(separator: "_", maxSplits: 2, omittingEmptySubsequences: true)
        if components.count == 3 {
            let category = "\(components[0])_\(components[1])"
            let draftID = String(components[2])
            return (category, draftID)
        } else {
            return nil
        }
    }
    
    func fetchDraftFromCode(_ code: String, completion: @escaping (SearchView.Draft?) -> Void) {
        guard let result = parseCommand(code) else {
            print("(SearchView)無效的口令")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection(result.category).document(result.draftID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                let draft = SearchView.Draft(
                    id: document.documentID,
                    board: data["category"] as? String ?? "生活",
                    title: data["title"] as? String ?? "無標題",
                    description: data["description"] as? String ?? "無描述",
                    createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                    deadLine: data["deadLine"] as? String ?? "無期限",
                    lastCommentDate: data["lastCommentDate"] as? String ?? "尚無留言",
                    heart: data["heart"] as? Int ?? 0,
                    commentCount: data["commentCount"] as? Int ?? 0,
                    reward: data["reward"] as? Int ?? 0
                )
                completion(draft)
            } else {
                print("(SearchView)查無該文檔，錯誤訊息：\(error?.localizedDescription ?? "無錯誤訊息")")
                completion(nil)
            }
        }
    }
    
    func searchDraftsByKeyword(_ keyword: String, completion: @escaping ([Draft]) -> Void) {
        let db = Firestore.firestore()
        var allResults: [Draft] = []
        let group = DispatchGroup()
        
        for (category, collection) in categoryToCollection {
            group.enter()
            db.collection(collection)
                .whereField("title", isGreaterThanOrEqualTo: keyword)
                .whereField("title", isLessThanOrEqualTo: keyword + "\u{f8ff}")
                .getDocuments { snapshot, error in
                    if let documents = snapshot?.documents {
                        let drafts = documents.map { doc in
                            let data = doc.data()
                            return Draft(
                                id: doc.documentID,
                                board: category,
                                title: data["title"] as? String ?? "無標題",
                                description: data["description"] as? String ?? "無描述",
                                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                                deadLine: data["deadLine"] as? String ?? "無期限",
                                lastCommentDate: data["lastCommentDate"] as? String ?? "尚無留言",
                                heart: data["heart"] as? Int ?? 0,
                                commentCount: data["commentCount"] as? Int ?? 0,
                                reward: data["reward"] as? Int ?? 0
                            )
                        }
                        allResults.append(contentsOf: drafts)
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            completion(allResults)
        }
    }
    
    func searchUsersByUserName(_ keyword: String, completion: @escaping ([String: String]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("userName", isGreaterThanOrEqualTo: keyword)
            .whereField("userName", isLessThanOrEqualTo: keyword + "\u{f8ff}")
            .limit(to: 5)
            .getDocuments { snapshot, error in
                if let snapshot = snapshot {
                    let results: [String: String] = snapshot.documents.reduce(into: [:]) { acc, doc in
                        let uid = doc.documentID
                        let name = doc.data()["userName"] as? String ?? "未知用戶"
                        acc[uid] = name
                    }
                    completion(results)
                } else {
                    print("(SearchView) 使用者搜尋錯誤：\(error?.localizedDescription ?? "未知錯誤")")
                    completion([:])
                }
            }
    }
    
    func fetchHotDrafts() {
        let db = Firestore.firestore()
        var results: [Draft] = []
        let group = DispatchGroup()
        
        for (category, collection) in categoryToCollection.shuffled().prefix(5) {
            group.enter()
            db.collection(collection)
                .order(by: "heart", descending: true)
                .limit(to: 2)
                .getDocuments { snapshot, error in
                    if let documents = snapshot?.documents {
                        let drafts = documents.map { doc in
                            let data = doc.data()
                            return Draft(
                                id: doc.documentID,
                                board: category,
                                title: data["title"] as? String ?? "無標題",
                                description: data["description"] as? String ?? "無描述",
                                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                                deadLine: data["deadLine"] as? String ?? "無期限",
                                lastCommentDate: data["lastCommentDate"] as? String ?? "尚無留言",
                                heart: data["heart"] as? Int ?? 0,
                                commentCount: data["commentCount"] as? Int ?? 0,
                                reward: data["reward"] as? Int ?? 0
                            )
                        }
                        results.append(contentsOf: drafts)
                    }
                    group.leave()
                }
        }
        
        group.notify(queue: .main) {
            self.熱門草稿 = results.shuffled().prefix(5).map { $0 }
        }
    }

    
    // 儲存搜尋紀錄
    func saveToHistory(_ keyword: String) {
        var history = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
        
        // 移除重複項目，將最新的放最前面
        history.removeAll { $0 == keyword }
        history.insert(keyword, at: 0)
        
        // 限制最多儲存 20 筆
        if history.count > 20 {
            history = Array(history.prefix(20))
        }
        
        UserDefaults.standard.set(history, forKey: "searchHistory")
        self.搜尋歷史記錄 = history
    }
    
    // 載入搜尋紀錄
    func loadHistory() {
        let history = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
        self.搜尋歷史記錄 = history
    }

    // 移除單筆紀錄
    func removeHistory(at index: Int) {
        var history = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
        if index < history.count {
            history.remove(at: index)
            UserDefaults.standard.set(history, forKey: "searchHistory")
            self.搜尋歷史記錄 = history
        }
    }

}

#Preview {
    SearchView()
}
