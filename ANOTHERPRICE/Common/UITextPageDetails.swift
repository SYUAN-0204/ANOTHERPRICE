//
//  UITextPageDetails.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/22.
//

import SwiftUI

struct UITextPageDetails: View {
    @Binding var detailInput: Int
    @State var detailTitle: String
    
    var body: some View {
        VStack{
            Text("\(detailInput >= 1_000_000 ? String(format: "%.1fM", Double(detailInput) / 1_000_000) : detailInput >= 1000 ? String(format: "%.1fk", Double(detailInput) / 1000) : "\(detailInput)")")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                .foregroundColor(.white.opacity(0.9))
            Text(detailTitle)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 40)
    }
}

#Preview {
    UITextPageDetails(detailInput: .constant(10000), detailTitle: "Title")
}
