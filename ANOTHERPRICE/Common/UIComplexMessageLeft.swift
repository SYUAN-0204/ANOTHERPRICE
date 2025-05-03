//
//  UIComplexMessageLeft.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIComplexMessageLeft: View {
    let userAvatar: UIImage
    let content: String
    let bubbleColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(alignment: .top){
            UIProfileImage(photo: userAvatar, width: 40, height: 40)
            Text(content)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .foregroundColor(textColor)
                    .padding(10)
                    .background {
                        ZStack(alignment: .topLeading){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(bubbleColor)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                            Rectangle()
                                .fill(bubbleColor)
                                .frame(width: 20, height: 20)
                        }
                    }
            .padding(.trailing, 10)
            Spacer()
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    UIComplexMessageLeft(userAvatar: UIImage(named: "Logo_122D3E") ?? UIImage(), content: "asdfghjkl", bubbleColor: .blue, textColor: .white)
}
