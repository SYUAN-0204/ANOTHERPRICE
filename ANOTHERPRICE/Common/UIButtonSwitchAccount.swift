//
//  UIButtonSwitchAccount.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI

struct UIButtonSwitchAccount: View {
    @Binding var switchAccount: Bool
    let photo: UIImage
    let isLogin: Bool
    
    var body: some View {
        Button(){
            switchAccount = true
        } label: {
            HStack {
                UIProfileImage(photo: photo, width: 40, height: 40)
                Text("這是另外的價錢")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .foregroundColor(.black)
                Spacer()
                if isLogin {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14))
                        .foregroundColor(ColorConstants.emeraldGreen)
                }
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}

#Preview {
    UIButtonSwitchAccount(switchAccount: .constant(false), photo: UIImage(named: "Logo_122D3E") ?? UIImage(), isLogin: true)
}
