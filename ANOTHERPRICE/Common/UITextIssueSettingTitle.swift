//
//  UITextIssueSettingTitle.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/13.
//

import SwiftUI

struct UITextIssueSettingTitle: View {
    @State var title: String
    var body: some View {
        Text(title)
            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
            .foregroundColor(ColorConstants.systemDarkColor)
            .padding(.trailing, 5)
    }
}

#Preview {
    UITextIssueSettingTitle(title: "title")
}
