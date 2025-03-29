//
//  SettingView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/18.
//

import SwiftUI
import KeychainSwift

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @State var logout: Bool = false
    @State private var authUid: String? = KeychainSwift().get("authUid")
    
    private let keychain = KeychainSwift()
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                Spacer()
                Text("設定")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                Button {} label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .opacity(0)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 36)
            .background(Color.white)
            ScrollView(){
                VStack(spacing: 0){
                    HStack{
                        Text("帳號資料")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 1)
                    HStack{
                        Text("訊息設定")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                }
                .background(Color.white)
                
                VStack(spacing: 0){
                    UIButtonSettingTool(title: "帳號切換")
                }
                .background(Color.white)
                .padding(.top, 10)
                
                VStack(spacing: 0){
                    UIButtonSettingTool(title: "帳號登出", action: {
                        logout = true
                    })
                }
                .background(Color.white)
                .padding(.top, 10)
            }
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .alert("帳號登出", isPresented: $logout) {
            Button("取消", role: .cancel) { }
            Button("確定", role: .destructive) {
                logoutAction()
            }
        }

    }
    
    private func logoutAction() {
            keychain.delete("authUid")
            keychain.delete("userName")
            keychain.delete("registDay")
            dismiss()
        }
}

#Preview {
    SettingView()
}
