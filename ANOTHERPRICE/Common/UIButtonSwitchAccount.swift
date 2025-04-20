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
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill() // 確保填滿圓形
                    .frame(width: 40, height: 40) // 限制大小
                    .background(Color(.systemGray6))
                    .clipShape(Circle()) // 剪裁為圓形
                    .overlay(
                        Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                    )
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
