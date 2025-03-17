//
//  UIImageExtoolCustom.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/17.
//

import SwiftUI

struct UIImageExtoolCustom: View {
    @State var imageName: String
    @State var toolTitle: String
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .font(.system(size: 20))
                .foregroundColor(ColorConstants.systemMainColor)
            Text(toolTitle)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
        }
    }
}

#Preview {
    UIImageExtoolCustom(imageName: "headset", toolTitle: "聯絡客服")
}
