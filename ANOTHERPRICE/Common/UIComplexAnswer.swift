//
//  UIComplexAnswer.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI

struct UIComplexAnswer: View {
    let userName: String
    let isSelfIssue: Bool
    let userAvatar: UIImage
    let anonymous: Bool
    let comment: String
    let totalExp: Int
    let timestamp: String
    @State var expand: Bool = false
    @Binding var like: Bool
    let heart: Int
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationLink{
            DisplayView(isMyDisplayView: false)
        } label: {
            HStack{
                UIProfileImage(photo: userAvatar, width: 30, height: 30)
                VStack(alignment: .leading){
                    HStack{
                        Text(anonymous ? "神秘旅人":userName)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                            .foregroundColor(ColorConstants.systemSubColor)
                        UITextLevel(totalExp: totalExp, width: 26, height: 12, size: 10)
                    }
                    Text(timestamp)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                        .foregroundColor(.gray)
                }
                Spacer()
                Button{
                    showAlert = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24, alignment: .trailing)
                        .padding(.trailing, 8)
                }
                .alert("提示", isPresented: $showAlert) {
                    if isSelfIssue {
                        Button("選為最佳") {
                        }
                    }
                    Button("關注用戶") {
                    }
                    Button("檢舉回答", role: .destructive) {
                    }
                    Button("取消", role: .cancel) {
                        showAlert = false
                    }
                } message: {
                    Text("用戶 用戶名稱 的回答")
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
        UIRectangleLine(opacity: 0.3)
            .padding(.bottom, 5)
        
    }
}

#Preview {
    UIComplexAnswer(userName: "用戶名稱",isSelfIssue: true, userAvatar: UIImage(named: "Logo_122D3E") ?? UIImage(), anonymous: false, comment: "这是用户的评论内容", totalExp: 123, timestamp: "2012/03/22 12:22", like: .constant(false), heart: 12)
}
