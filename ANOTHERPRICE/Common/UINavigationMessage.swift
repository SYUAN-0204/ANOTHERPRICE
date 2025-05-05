//
//  UINavigationMessage.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI

struct UINavigationMessage<Destination: View>: View {
    let destination: Destination
    let icon: String
    let color: Color
    let title: String
    let badgeCount: Int
    
    var body: some View {
        NavigationLink{
            destination
        } label: {
            VStack{
                ZStack {
                    GeometryReader { geo in
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(7)
                            .background(
                                Circle()
                                    .fill(color)
                                    .blur(radius: 10)
                                    .opacity(0.6)
                            )
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)

                        if badgeCount > 0 {
                            let badgeText = badgeCount > 99 ? "99+" : "\(badgeCount)"
                            Text(badgeText)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .clipShape(Capsule())
                                .fixedSize()
                                .position(x: geo.size.width - 2, y: 2) // 右上角貼齊
                        }
                    }
                    .frame(width: 60, height: 40) // 視圖容器大小視情況微調
                }
                Text(title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemDarkColor)
                    .padding(.top, -7)
            }
        }
    }
}

#Preview {
    UINavigationMessage(destination: Text("預覽畫面"), icon: "", color: Color.cyan, title: "", badgeCount: 9)
}
