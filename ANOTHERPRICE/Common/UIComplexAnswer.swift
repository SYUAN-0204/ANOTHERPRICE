//
//  UIComplexAnswer.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI

struct UIComplexAnswer: View {
    let userAvatar: UIImage
    let anonymous: Bool
    let comment: String
    let totalExp: Int
    @State var expand: Bool = false
    @Binding var like: Bool
    let heart: Int
    var body: some View {
        NavigationLink{
            temp8(我的主頁: false)
        } label: {
            HStack{
                Image(uiImage: userAvatar)
                    .resizable()
                    .scaledToFill() // 確保填滿圓形
                    .frame(width: 30, height: 30) // 限制大小
                    .background(Color(.systemGray6))
                    .clipShape(Circle()) // 剪裁為圓形
                    .overlay(
                        Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                    )
                VStack(alignment: .leading){
                    HStack{
                        Text(anonymous ? "神秘旅人":"用戶名稱")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                            .foregroundColor(ColorConstants.systemSubColor)
                        UITextLevel(totalExp: totalExp, width: 26, height: 12, size: 10)
                    }
                    Text("2025-04-13 16:32")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                        .foregroundColor(.gray)
                }
                Spacer()
                Button{
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24, alignment: .trailing)
                        .padding(.trailing, 8)
                }
            }
        }
        .padding(.horizontal, 5)
        VStack(alignment: .leading){
            Text(comment)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                .foregroundColor(ColorConstants.systemDarkColor)
                .lineLimit(expand ? nil:3)
            if comment.count > 50 {
                Button(action: {
                    expand.toggle()
                }) {
                    Text(expand ? "收起" : "展開")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                        .foregroundColor(ColorConstants.systemMainColor)
                }
            }
            HStack{
                Spacer()
                Button{
                    like.toggle()
                } label: {
                    Image(systemName: like ? "heart.fill":"heart")
                        .font(.system(size: 14))
                        .foregroundColor(ColorConstants.systemMainColor)
                }
                Text("\(heart)")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemMainColor)
            }
            .padding(.trailing, 8)
        }
        .padding(.leading, 38)
        .padding(.horizontal, 5)
        Rectangle()
            .fill(.gray.opacity(0.3))
            .frame(height: 1)
            .padding(.bottom, 5)

    }
}

#Preview {
    UIComplexAnswer(userAvatar: UIImage(named: "Logo_122D3E") ?? UIImage(), anonymous: false, comment: "这是用户的评论内容", totalExp: 123, like: .constant(false), heart: 12)
}
