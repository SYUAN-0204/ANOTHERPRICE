//
//  UIComplexReward.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIComplexReward: View {
    let point: Int
    let title: String
    let content: String
    
    let issueExist: Bool
    @Binding var rewardExist: Bool
    
    @State private var showAlert: Bool = false
    @State private var showRewardAlert: Bool = false
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            VStack(alignment: .leading) {
                HStack{
                    Text("您的回答已被選為最佳答案，獲得獎勵 \(point) 點")
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
                UIRectangleLine(opacity: 0.1)
                HStack{
                    NavigationLink{
                        if issueExist {
                            PostDetailView(category: "12",documentID:"123",isMyDisplayView: false)
                        }
                        else {
                            LazyView(ErrorView())
                        }
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
                    if !rewardExist {
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
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .alert("是否領取獎勵", isPresented: $showAlert) {
            Button("取消", role: .cancel) { }
            Button("確定", role: .destructive) {
                rewardExist = false
                showRewardAlert = true
            }
        } message: {
            Text("是否領取獎勵 \(point) 點")
        }
        .alert("成功領取獎勵", isPresented: $showRewardAlert) {
            Button("確定", role: .cancel) {
                rewardExist = false
            }
        } message: {
            Text("成功領取獎勵 \(point) 點")
        }
    }
}

#Preview {
    UIComplexReward(point: 34, title: "ert", content: "wer", issueExist: false, rewardExist: .constant(false))
}
