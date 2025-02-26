//
//  UIButtonCustom.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/26.
//

import SwiftUI

struct UIButtonCustom: View {
    var title: String
    var body: some View {
        Button() {
            
        } label: {
            ZStack{
                ColorConstants.systemMainColor
                Text(title)
                    .font(.custom("NotoSerifTC-Regular", size: 20))
                    .foregroundColor(.white)
            }
            .frame(height: 38)
            .cornerRadius(5)
        }
    }
}

#Preview {
    UIButtonCustom(title: "")
}
