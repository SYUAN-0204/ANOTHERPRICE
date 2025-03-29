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
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        }
    var body: some View {
        NavigationStack{
        TabView {
            Text("Home")
                .tabItem {
                    Label("首頁", systemImage: "house")
                        .environment(\.symbolVariants, .none)
                }
            
            Text("Search")
                .tabItem {
                    Label("搜尋", systemImage: "magnifyingglass")
                }
            
            IssueView()
                .tabItem {
                    Label("提問", systemImage: "questionmark.message")
                        .environment(\.symbolVariants, .none)
                }
            
            ProfileEditView()
                .tabItem {
                    Label("訊息", systemImage: "envelope")
                        .environment(\.symbolVariants, .none)
                }
            
            ProfileView()
                .tabItem {
                    Label("會員", systemImage: "person")
                        .environment(\.symbolVariants, .none)
                }
        }
        .accentColor(ColorConstants.systemMainColor)
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
