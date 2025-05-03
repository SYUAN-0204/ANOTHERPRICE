//
//  UIMenuSetting.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIMenuSetting: View {
    let list: [String]
    let title: String
    @Binding var selected: String
    
    var body: some View {
        Menu {
            Picker("Options", selection: $selected) {
                ForEach(list, id: \.self) { order in
                    Text(order)
                }
            }
        } label: {
            HStack {
                Text(title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .foregroundColor(.black)
                Spacer()
                Text(selected)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                    .padding(.trailing, -5)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 50)
    }
}

#Preview {
    UIMenuSetting(list: [], title: "asd", selected: .constant("asd"))
}
