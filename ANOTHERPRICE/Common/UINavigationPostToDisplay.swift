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
    let author: String
    var body: some View {
        NavigationLink{
            DisplayView(isMyDisplayView: isSelfIssue)
        } label: {
            UIProfileImage(photo: userAvatar, width: 40, height: 40)
            Text(isAnonymous ? "匿名精靈":author)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                .foregroundColor(ColorConstants.systemSubColor)
        }
        .disabled(isAnonymous)
    }
}

#Preview {
    UINavigationPostToDisplay(isSelfIssue: true, userAvatar: UIImage(), isAnonymous: true, author: "用戶名稱")
}
