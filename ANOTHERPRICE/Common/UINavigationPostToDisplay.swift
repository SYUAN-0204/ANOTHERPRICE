//
//  UINavigationPostToDisplay.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/29.
//

import SwiftUI

struct UINavigationPostToDisplay: View {
    let isSelfIssue: Bool
    let userAvatar: UIImage
    let isAnonymous: Bool
    var body: some View {
        NavigationLink{
            DisplayView(isMyDisplayView: isSelfIssue)
        } label: {
            Image(uiImage: userAvatar)
                .resizable()
                .scaledToFill() // 確保填滿圓形
                .frame(width: 40, height: 40) // 限制大小
                .background(Color(.systemGray6))
                .clipShape(Circle()) // 剪裁為圓形
            Text(isAnonymous ? "匿名精靈":"用戶名稱")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                .foregroundColor(ColorConstants.systemSubColor)
        }
        .disabled(isAnonymous)
    }
}

#Preview {
    UINavigationPostToDisplay(isSelfIssue: true, userAvatar: UIImage(), isAnonymous: true)
}
