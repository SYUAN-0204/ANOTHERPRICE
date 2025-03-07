//
//  ProfileView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI
import KeychainSwift

struct ProfileView: View {
    
    @State private var showLoginView = false
    @State private var authUid: String? = nil
    private let keychain = KeychainSwift()
    
    var body: some View {
        VStack {
            Text(authUid?.isEmpty == false ? "Logged In" : "Not Logged In")
                .padding()
            
            Button(action: {
                if let authUid = authUid, !authUid.isEmpty {
                    self.keychain.delete("authUid")
                    self.authUid = nil
                } else {
                    self.showLoginView = true
                }
            }) {
                Text(authUid?.isEmpty == false ? "Logout" : "Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(authUid?.isEmpty == false ? Color.red : Color.blue)
                    .cornerRadius(8)
            }
            .sheet(isPresented: $showLoginView) {
                LoginView()
                .presentationDetents([.fraction(0.9)])
            }
        }
        .onAppear {
            self.authUid = keychain.get("authUid")
        }
    }
}

#Preview {
    ProfileView()
}
