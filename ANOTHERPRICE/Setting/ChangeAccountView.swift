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
                Text("切換帳號")
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
                    UIButtonSwitchAccount(switchAccount: $isSwitchingAccount, photo: userAvatar, isLogin: false)
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 1)
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
