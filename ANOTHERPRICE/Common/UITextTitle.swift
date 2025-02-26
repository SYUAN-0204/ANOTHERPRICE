//
//  UITextTitle.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/26.
//

import SwiftUI

struct UITextTitle: View {
    @State var title: String
    var body: some View {
        HStack{
            Text(title)
                .font(.custom("NotoSerifTC-Regular", size: 24))
                .foregroundColor(ColorConstants.systemSubColor)
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    UITextTitle(title: "Title")
}
