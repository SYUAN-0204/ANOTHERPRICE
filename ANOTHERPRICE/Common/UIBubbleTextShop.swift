//
//  UIBubbleTextShop.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIBubbleTextShop: View {
    
    let name: String
    let bubbleColor: Color
    let textColor: Color
    let opacity: Double
    
    @State private var showPurchasedAlert: Bool = false
    
    @Binding var isPurchased: Bool
    @Binding var isApplied: Bool
    
    var onApply: () -> Void
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(textColor.opacity(opacity))
                Text(name)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .foregroundColor(textColor)
                    .padding(10)
                    .background {
                        ZStack(alignment: .topLeading){
                            RoundedRectangle(cornerRadius: 10)
                                .fill(bubbleColor)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                            Rectangle()
                                .fill(bubbleColor)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .frame(width: 110, height: 110)
            }
            .frame(width: 110, height: 110)
            if !isPurchased{
                Button(){
                    showPurchasedAlert = true
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(ColorConstants.systemDarkColor.opacity(0.1))
                        Text("300點")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor)
                    }
                    .frame(width: 80, height: 30)
                }
                .padding(.top, 5)
                .alert("購買聊天氣泡", isPresented: $showPurchasedAlert) {
                    Button("取消", role: .cancel) { }
                    Button("確定", role: .destructive) {
                        onApply()
                    }
                } message: {
                    Text("是否確認購買 \(name) 聊天氣泡")
                }
            }
            else if isPurchased && !isApplied{
                Button(){
                    onApply()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(ColorConstants.systemDarkColor.opacity(0.1))
                        Text("套用")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor)
                    }
                    .frame(width: 80, height: 30)
                }
                .padding(.top, 5)
            }
            else if isPurchased && isApplied{
                Button(){
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(ColorConstants.systemDarkColor.opacity(0.1), lineWidth: 1)
                        Text("已套用")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor)
                    }
                    .frame(width: 80, height: 30)
                }
                .padding(.top, 5)
            }
        }
    }
    
    
}

#Preview {
    UIBubbleTextShop(name: "asd", bubbleColor: Color.black, textColor: Color.white, opacity: 0.3, isPurchased: .constant(true), isApplied: .constant(true), onApply: {})
}
