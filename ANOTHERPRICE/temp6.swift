//
//  temp6.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI

struct temp6: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var 簽名: String = ""
    @State private var 佔用: Bool = false
    
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
                    .padding(.leading, 10)
                    Spacer()
                }
                .frame(width: 80)
                Spacer()
                Text("變更暱稱")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("變更")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.gray)
                            .frame(height: 36)
                    }
                    .padding(.trailing, 10)
                    .disabled(簽名.isEmpty)
                }
                .frame(width: 80)
            }
            .frame(height: 36)
            .background(Color.white)
            HStack{
                TextField("請輸入新暱稱", text: $簽名)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .onChange(of: 簽名) {
                        簽名 = 簽名.replacingOccurrences(of: "\n", with: "")
                        if 簽名.count > 8 {
                            簽名 = String(簽名.prefix(8))
                        }
                    }
                if !簽名.isEmpty {
                    Image(systemName: 佔用 ? "exclamationmark.triangle.fill" :"checkmark")
                        .font(.system(size: 14))
                        .foregroundColor(佔用 ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
                }
            }
                .padding(.horizontal, 15)
                .padding(.top, 10)
                .frame(height: 24)
            Rectangle()
                .fill(ColorConstants.systemMainColor)
                .frame(height: 1.5)
                .padding(.horizontal, 15)
            HStack{
                Text("修改暱稱需要消耗 100 點")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(簽名.count)/8")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.top, -5)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp6()
}
