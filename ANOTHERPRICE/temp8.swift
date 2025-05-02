//
//  temp8.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI

struct temp8: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    @State private var 獎勵是否領取: Bool = true
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                Spacer()
                Text(name)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .opacity(0)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 30)
            .background(Color.white)
            ScrollView{
                Text("2025-04-23")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                    .padding(.top, 10)
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    VStack(alignment: .leading) {
                        HStack{
                            Text("您的回答已被選為最佳答案，獲得獎勵 50 點")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(ColorConstants.systemDarkColor)
                            Spacer()
                        }
                        Text("題目：")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor)
                            .lineLimit(1)
                            .padding(.top, -3)
                        Text("內容：")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor)
                            .lineLimit(5)
                            .padding(.top, -5)
                        Text("這樣那樣的內容")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                            .lineLimit(5)
                            .padding(.top, -5)
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(height: 1)
                        HStack{
                            NavigationLink{
                                PostDetailView(isMyDisplayView: false)
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
                            if !獎勵是否領取 {
                                //在想是領取提示，還是是否確認領取，或是連續提示，到時候改
                                Button(){
                                    showAlert = true
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(ColorConstants.systemMainColor)
                                            .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                        Text("領取獎勵")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 5)
                                    }
                                }
                                .padding(.horizontal, 3)
                            }
                        }
                    }
                    .padding(10)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
            }
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp8(name: "qwe")
}
