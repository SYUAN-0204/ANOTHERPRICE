//
//  temp4.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI

struct temp4: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var 輸入文字: String
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                        .padding(.trailing, 5)
                }
            }
            .padding(.top, 10)
            TextEditor(text: $輸入文字)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                .frame(minHeight: 200)
                .overlay(
                    Group {
                        if 輸入文字.isEmpty {
                            VStack{
                                HStack{
                                    Text("睡著了也等不到你的回答")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                .padding(.top, 8)
                                Spacer()
                            }
                        }
                    }
                )
            HStack{
                Spacer()
                Button{
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(ColorConstants.systemMainColor.opacity(輸入文字.isEmpty ? 0.7 : 1.0))
                        Text("送出")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 60, height: 28)
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    temp4(輸入文字: .constant(""))
}
