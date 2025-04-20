//
//  UIComplexIssueCard.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI

struct UIComplexIssueCard<Destination: View>: View {
    let destination: Destination
    let title: String
    let date: String
    let coin: Int
    let content: String
    let like: Bool
    let heart: Int
    let message: Int
    let author: String
    let code: String
    let http: String
    
    var body: some View {
        NavigationLink{
            destination
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(height: 100)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                VStack(alignment: .leading) {
                    HStack{
                        VStack(alignment: .leading){
                            Text(title)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .lineLimit(1)
                            Text("Deadline : \(date)")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                            .padding(.trailing, -5)
                        Text("\(coin)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                            .foregroundColor(ColorConstants.systemMainColor)
                            .frame(width: 26, alignment: .leading)
                    }
                    Text(content + "\n\n")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                        .padding(.top, -8)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    HStack{
                        Spacer()
                        Button{
                            
                        } label: {
                            Image(systemName: like ? "heart.fill":"heart")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Text("\(heart)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Image(systemName: "ellipsis.message")
                            .font(.system(size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Text("\(message)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        ShareLink(item: "✨「\(author)發布了一則問答《\(title)》，快來看看吧！」\n打開 APP 搜尋口令：/*\(code)*/🪄\n🔗  \(http)") {
                            Image(systemName: "arrowshape.turn.up.right")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    .padding(.bottom, 7)
                }
                .padding(.horizontal, 10)
                .padding(.top, 7)
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)
        }
    }
}

#Preview {
    UIComplexIssueCard(destination: Text("預覽畫面"), title: "標題", date: "2025-04-05", coin: 23, content: "內容", like: true, heart: 34, message: 45, author: "作者", code: "/*fer*/", http: "https://www.anotherprice.com")
}
