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
    @State private var isLoading: Bool = true
    @State private var noDraftsMessage: String? = nil
    @State var keychain = KeychainSwift()
    
    // 定義草稿資料結構
    struct Draft: Identifiable {
        var id: String
        var title: String
        var description: String
    }
    
    var body: some View {
        VStack{
            NavigationLink{
                IssueEditView(isDraft: false, draftId: nil)
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
                ProgressView("加載中...")
                    .padding()
            } else {
                if let noDraftsMessage = noDraftsMessage {
                    Text(noDraftsMessage)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                }
                else{
                    ScrollView {
                        ForEach(drafts) { draft in
                            NavigationLink { IssueEditView(isDraft: true, draftId: draft.id)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(height: 80)
                                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                    VStack(alignment: .leading) {
                                        Text(draft.title)
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                            .foregroundColor(ColorConstants.systemDarkColor)
                                            .lineLimit(1)
                                        Text(draft.description)
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(.gray)
                                            .padding(.top, -10)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.horizontal, 10)
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                    .padding(.top, 5)
                }
            }
        }
        .padding(.horizontal, 10)
        .onAppear {
            fetchDrafts()
        }
        .padding(.horizontal, 10)
    }
    
    func fetchDrafts() {
        let userUid = keychain.get("authUid") ?? nil
        if(userUid == nil) {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userUid!).collection("drafts")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                if let documents = snapshot?.documents, !documents.isEmpty {
                    self.drafts = documents.compactMap { document in
                        let data = document.data()
                        return Draft(id: document.documentID,
                                     title: data["title"] as? String ?? "無標題",
                                     description: data["description"] as? String ?? "無描述")
                    }
                    self.noDraftsMessage = nil
                } else {
                    self.drafts = []
                    self.noDraftsMessage = "暫無草稿"
                }
            }
        self.isLoading = false
    }
    
}

#Preview {
    IssueView()
}
