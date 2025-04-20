//
//  ContentView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/18.
//

import SwiftUI
import KeychainSwift

struct ToolView: View {
    @State private var isLoggedIn = false
    private let keychain = KeychainSwift()
    
    @State private var selectedTab: TabIdentifier = .home
    @State private var path: [Route] = []
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        }
    
    var body: some View {
        NavigationStack(path: $path){
            TabView(selection: $selectedTab) {
            Text("Home")
                .tabItem {
                    Label("首頁", systemImage: "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabIdentifier.home)
            Text("Search")
                .tabItem {
                    Label("搜尋", systemImage: "magnifyingglass")
                }
                .tag(TabIdentifier.search)
            IssueView(path: $path)
                .tabItem {
                    Label("提問", systemImage: "questionmark.message")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabIdentifier.issue)
            ProfileEditView()
                .tabItem {
                    Label("訊息", systemImage: "envelope")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabIdentifier.message)
                ProfileView(selectedTab: $selectedTab)
                .tabItem {
                    Label("會員", systemImage: "person")
                        .environment(\.symbolVariants, .none)
                }
                .tag(TabIdentifier.profile)
        }
        .accentColor(ColorConstants.systemMainColor)
        .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .issueEdit(let isDraft, let draftId, let title, let description):
                            IssueEditView(isDraft: isDraft, draftId: draftId, title: title, description: description, path: $path)
                        case .issueSetting:
                            IssueSettingView(path: $path)
                        case .publish:
                            temp(path: $path)
                        }
                    }
        }
        .onAppear {
            if let token = keychain.get("authUid"), !token.isEmpty {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    ToolView()
}
