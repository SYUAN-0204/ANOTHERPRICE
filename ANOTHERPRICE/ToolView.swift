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
    @StateObject private var nav = NavigationCoordinator()
    @State private var 訊息數量: Int = 24543
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        NavigationStack(path: $nav.path){
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("首頁", systemImage: "house")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(TabIdentifier.home)
                temp1()
                    .tabItem {
                        Label("搜尋", systemImage: "magnifyingglass")
                    }
                    .tag(TabIdentifier.search)
                IssueView()
                    .tabItem {
                        Label("提問", systemImage: "questionmark.message")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(TabIdentifier.issue)
                temp6()
                    .tabItem {
                        Label("訊息", systemImage: "envelope")
                            .environment(\.symbolVariants, .none)
                    }
                    .tag(TabIdentifier.message)
                    .badge(訊息數量 > 0 ? (訊息數量 > 999 ? "999+" : "\(訊息數量)") : nil)
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
                    IssueEditView(isDraft: isDraft, draftId: draftId, title: title, description: description)
                case .issueSetting:
                    IssueSettingView()
                case .publish:
                    PublishView(isFromIssue: true, selectedTab: $selectedTab)//temp()
                case .draft:
                    DraftsView(selectedTab: $selectedTab)
                }
            }
        }
        .onAppear {
            if let token = keychain.get("authUid"), !token.isEmpty {
                isLoggedIn = true
            }
        }
        .environmentObject(nav)
    }
}

#Preview {
    ToolView()
}
