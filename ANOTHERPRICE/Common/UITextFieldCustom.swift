//
//  UITextFieldCustom.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/26.
//

import SwiftUI

struct UITextFieldCustom: View {
    @State var title: String
    @Binding var input: String
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.custom("NotoSerifTC-Regular", size: 20))
                    .foregroundColor(ColorConstants.systemSubColor)
                Spacer()
            }
            .padding(.bottom, -5)
            TextField("" ,text: $input)
                .autocapitalization(.none)
                .font(.custom("NotoSerifTC-Regular", size: 18))
                .foregroundColor(ColorConstants.systemSubColor)
                .tracking(1)
                .padding(.vertical, 3)
                .padding(.horizontal, 3)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                }
        }
    }
}

#Preview {
    UITextFieldCustom(title: "title", input: .constant("input"))
}
