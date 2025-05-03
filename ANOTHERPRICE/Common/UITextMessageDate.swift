//
//  UITextMessageDate.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UITextMessageDate: View {
    let date: String
    
    var body: some View {
        Text(date)
            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
            .padding(.top, 10)
    }
}

#Preview {
    UITextMessageDate(date: "2025-04-22")
}
