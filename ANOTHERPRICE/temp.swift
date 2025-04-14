//
//  temp.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI

struct temp: View {
    @Environment(\.dismiss) var dismiss
    //let text: String = "好"
        //var onDelete: () -> Void

        @GestureState private var dragOffset: CGFloat = 0
        @State private var offsetX: CGFloat = 0
        private let maxOffset: CGFloat = -80
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 80)
                Spacer()
                Text("我的草稿")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18))
                            .foregroundColor(ColorConstants.systemMainColor)
                    }
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            
            ScrollView{
                    ForEach(0..<5){ i in
                        ZStack(alignment: .trailing) {
                                    // 背後的按鈕區
                                    HStack {
                                        Spacer()
                                        Button(){
                                            
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.white)
                                                .frame(width: 60, height: 80)
                                                .background(Color.red)
                                        }
                                    }
                                    .padding(.horizontal)

                                    // 前面的卡片
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(height: 80)
                                        .overlay(
                                            Text("text")
                                                .padding(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        )
                                        .offset(x: offsetX + dragOffset)
                                        .gesture(
                                            DragGesture()
                                                .updating($dragOffset) { value, state, _ in
                                                    if value.translation.width < 0 {
                                                        state = value.translation.width
                                                    }
                                                }
                                                .onEnded { value in
                                                    if value.translation.width < -40 {
                                                        // 展開到固定距離
                                                        withAnimation {
                                                            offsetX = maxOffset
                                                        }
                                                    } else {
                                                        // 回彈
                                                        withAnimation {
                                                            offsetX = 0
                                                        }
                                                    }
                                                }
                                        )
                                        .padding(.horizontal)
                            Rectangle()
                                .fill(.gray)
                                .frame(height: 1)
                                }
                    }
                }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp()
}
