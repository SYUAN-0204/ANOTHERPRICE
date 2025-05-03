//
//  UIProfileImage.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIProfileImage: View {
    let photo: UIImage
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Image(uiImage: photo)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .background(.white)
            .clipShape(Circle())
    }
}

#Preview {
    UIProfileImage(photo: UIImage(named: "Logo_122D3E") ?? UIImage(), width: 40, height: 40)
}
