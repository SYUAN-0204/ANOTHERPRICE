//
//  ProfileView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showLoginView = false
    
    var body: some View {
        //暫時的入口
        Button() {
            showLoginView = true
        } label: {
            Text("Login")
        }
        .sheet(isPresented: $showLoginView) {
            LoginView()
                .presentationDetents([.fraction(0.9)])
        }
    }
}

#Preview {
    ProfileView()
}
