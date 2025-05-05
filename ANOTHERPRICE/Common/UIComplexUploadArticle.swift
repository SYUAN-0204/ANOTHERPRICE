//
//  UIComplexUploadArticle.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI

struct UIComplexUploadArticle: View {
    @Binding var isSelected: Bool
    @Binding var selecte: Bool
    @Binding var trashcanState: Bool
    let board: String
    let title: String
    let date: String
    let content: String
    let heart: Int
    let message: Int
    let author: String
    let code: String
    let http: String
    
    @State private var selected: Bool = false
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    private let maxOffset: CGFloat = -80
    
    var body: some View {
        VStack{
            Rectangle()
                .fill(Color.white)
                .frame(height: 110)
                .overlay(
                    HStack{
                        VStack(alignment: .leading) {
                            HStack{
                                ZStack{
                                    Text(board)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                        .foregroundColor(ColorConstants.systemDarkColor)
                                        .lineLimit(1)
                                        .padding(.horizontal, 3)
                                }
                                .background(ColorConstants.systemMainColor.opacity(0.2))
                                .cornerRadius(3)
                                Text(title)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .lineLimit(1)
                            }
                            Text(date)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                                .foregroundColor(.gray)
                            Text(content + "\n\n")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                            if !selecte {
                                HStack{
                                    Spacer()
                                    Image(systemName: "heart")
                                        .font(.system(size: 14))
                                        .foregroundColor(ColorConstants.systemMainColor)
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
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if selecte {
                            Button() {
                                isSelected.toggle()
                            } label: {
                                Image(systemName: isSelected ? "checkmark.square" : "square")
                                    .font(.system(size: 20))
                                    .foregroundColor(ColorConstants.systemDarkColor)
                            }
                            .padding(.bottom, 80)
                        }
                    }
                )
                .padding(.horizontal)
        }
    }
}

#Preview {
    UIComplexUploadArticle(
        isSelected: .constant(false),
        selecte: .constant(true), trashcanState: .constant(true), board: "科技", title: "標題", date: "2025-04-04", content: "內容", heart: 35, message: 53, author: "作者", code: "DHSOD35SD", http: "Link")
}
