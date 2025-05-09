//
//  UIComplexIssueDeadline.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIComplexIssueDeadline: View {
    let date: String
    let title: String
    let content: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            VStack(alignment: .leading) {
                HStack{
                    Text("您的提問已到期，前往提問選擇最佳答案")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemDarkColor)
                    Spacer()
                }
                Text("題目：\(title)")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemDarkColor)
                    .lineLimit(1)
                    .padding(.top, -3)
                Text("內容：")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemDarkColor)
                    .lineLimit(5)
                    .padding(.top, -5)
                Text(content)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                    .lineLimit(5)
                    .padding(.top, -5)
                Text("系統將於 \(date) 自動選擇最高讚數回答")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                    .padding(.top, -3)
                UIRectangleLine(opacity: 0.1)
                NavigationLink{
                    PostDetailView(category: "12",documentID:"123",isMyDisplayView: false)
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                        Text("查看提問")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemMainColor)
                            .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 3)
            }
            .padding(10)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    UIComplexIssueDeadline(date: "0225-04-23", title: "rtr", content: "ghfs")
}
