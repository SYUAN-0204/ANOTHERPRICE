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
        UITabBar.appearance().backgroundColor = UIColor.white // 设置背景颜色
        }
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            Text("Ask")
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
            
            ProfileSettingView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .accentColor(ColorConstants.systemMainColor)
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
