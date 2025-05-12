//
//  temp11.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct ErrorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var countdown:Int = 5
    @State private var timerActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack{
            UINavigationBar(title: "頁面不存在")
            Text("您訪問的頁面已不存在")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                .foregroundColor(ColorConstants.systemDarkColor)
                .padding(.top, 30)
            Text("將在 \(countdown) 秒後自動返回")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                .padding(.top, 10)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            if countdown > 1 {
                countdown -= 1
            } else if timerActive {
                timerActive = false
                dismiss()
            }
        }
    }
}

#Preview {
    ErrorView()
}
