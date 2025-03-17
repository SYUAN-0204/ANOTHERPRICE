//
//  UITextProfileDetails.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/17.
//

import SwiftUI

struct UITextProfileDetails: View {
    @State var detailInput: Int
    @State var detailTitle: String
    
    var body: some View {
        VStack{
            Text("\(detailInput >= 10000 ? String(format: "%d万", detailInput / 10000) : "\(detailInput)")")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
            Text(detailTitle)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    UITextProfileDetails(detailInput: 0, detailTitle: "Title")
}
