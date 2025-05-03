//
//  temp.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI

struct ChangeAccountView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var isSwitchingAccount: Bool = false
    
    var body: some View {
        VStack{
            UINavigationBar(title: "切換帳號")
            ScrollView(){
                VStack(spacing: 0){
                    UIButtonSwitchAccount(switchAccount: $isSwitchingAccount, photo: userAvatar, isLogin: false)
                    UIRectangleLine(opacity: 0.1)
                    UIButtonSwitchAccount(switchAccount: $isSwitchingAccount, photo: userAvatar, isLogin: true)
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .alert("帳號切換", isPresented: $isSwitchingAccount) {
            Button("取消", role: .cancel) { }
            Button("確定", role: .destructive) {
                
            }
        } message: {
            Text("帳號名稱")
        }
    }
}

#Preview {
    ChangeAccountView()
}
