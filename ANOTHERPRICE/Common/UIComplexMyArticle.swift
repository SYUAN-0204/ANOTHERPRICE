//
//  UIComplexMyArticle.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI

struct UIComplexMyArticle: View {
    @Binding var selecte: Bool
    @Binding var trashcanState: Bool
    let title: String
    let date: String
    let content: String
    
    @State private var selected: Bool = false
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    private let maxOffset: CGFloat = -80
    
    var body: some View {
        VStack{
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Button(){
                        //垃圾桶功能
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 110)
                            .background(ColorConstants.tomatoRed)
                    }
                }
                .padding(.horizontal)
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
                                Button() {
                                    selected.toggle()
                                } label: {
                                    Image(systemName: selected ? "checkmark.square" : "square")
                                        .font(.system(size: 20))
                                        .foregroundColor(ColorConstants.systemDarkColor)
                                }
                                .padding(.bottom, 80)
                            }
                        }
                    )
                    .offset(x: offsetX + dragOffset)
                    .simultaneousGesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                if value.translation.width < 0 {
                                    state = value.translation.width
                                }
                            }
                            .onEnded { value in
                                if value.translation.width < -40 {
                                    withAnimation {
                                        offsetX = maxOffset
                                        trashcanState = true
                                        selecte = false
                                    }
                                } else {
                                    withAnimation {
                                        offsetX = 0
                                        trashcanState = false
                                    }
                                }
                                print(trashcanState)
                            }
                    )
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    UIComplexMyArticle(selecte: .constant(true), trashcanState: .constant(true), title: "標題", date: "2025-04-04", content: "內容")
}
