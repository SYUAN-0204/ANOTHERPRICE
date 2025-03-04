//
//  UITextDetail.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/2.
//

import SwiftUI

struct UITextDetail: View {
    @State var title: String
    @State var detail: String
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.custom("NotoSerifTC-Regular", size: 20))
                    .foregroundColor(ColorConstants.systemSubColor)
                Spacer()
            }
            HStack{
                Text(detail)
                    .font(.custom("NotoSerifTC-Regular", size: 20))
                    .foregroundColor(ColorConstants.systemSubColor)
                Spacer()
            }
        }
    }
}

#Preview {
    UITextDetail(title: "標題", detail: "內容")
}
