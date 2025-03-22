//
//  UIButtonSettingTool.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/18.
//

import SwiftUI

struct UIButtonSettingTool: View {
    @State var title: String
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack{
                Spacer()
                Text(title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(height: 50)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    UIButtonSettingTool(title: "標題")
}
