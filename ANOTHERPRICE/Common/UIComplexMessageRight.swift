//
//  UIComplexMessageRight.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIComplexMessageRight: View {
    let userAvatar: UIImage
    let content: String
    
    var body: some View {
        HStack(alignment: .top){
            Spacer()
            Text(content)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                .foregroundColor(ColorConstants.systemDarkColor)
                .padding(10)
                .background {
                    ZStack(alignment: .topTrailing){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: -2, y: 2)
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.leading, 10)
            UIProfileImage(photo: userAvatar, width: 40, height: 40)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    UIComplexMessageRight(userAvatar: UIImage(named: "Logo_122D3E") ?? UIImage(), content: "asdfghjkl")
}
