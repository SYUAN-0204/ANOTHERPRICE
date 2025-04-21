//
//  UIComplexMyArticle.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI

struct UIComplexMyArticle: View {
    @Binding var isSelected: Bool
    @Binding var selecte: Bool
    @Binding var trashcanState: Bool
    let title: String
    let date: String
    let content: String
    let onDelete: () -> Void
    
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
                            Text(title)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .lineLimit(1)
                            Text(date)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                                .foregroundColor(.gray)
                            Text(content + "\n\n\n")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if selecte {
                            Button {
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
    UIComplexMyArticle(
        isSelected: .constant(false),
        selecte: .constant(true),
        trashcanState: .constant(false),
        title: "標題",
        date: "2025-04-04",
        content: "內容",
        onDelete: {
            print("刪除動作觸發")
        }
    )
}
