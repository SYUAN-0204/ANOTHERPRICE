//
//  UITextProfileDetails.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/17.
//

import SwiftUI

struct UITextProfileDetails: View {
    @Binding var detailInput: Int
    @State var detailTitle: String
    
    var body: some View {
        VStack{
            Text("\(detailInput >= 1_000_000 ? String(format: "%.1fM", Double(detailInput) / 1_000_000) : detailInput >= 1000 ? String(format: "%.1fk", Double(detailInput) / 1000) : "\(detailInput)")")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                .foregroundColor(ColorConstants.systemDarkColor)
            Text(detailTitle)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    UITextProfileDetails(detailInput: .constant(10000), detailTitle: "Title")
}
