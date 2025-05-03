//
//  UINavigationBar.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UINavigationBar: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            .padding(.leading, 10)
            Spacer()
            Text(title)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                .fontWeight(.semibold)
            Spacer()
            Button {} label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .opacity(0)
            }
            .padding(.trailing, 10)
        }
        .frame(height: 36)
        .background(Color.white)
    }
}

#Preview {
    UINavigationBar(title: "標題")
}
