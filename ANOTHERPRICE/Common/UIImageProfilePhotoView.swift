//
//  UIImageProfilePhotoView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/2.
//

import SwiftUI

struct UIImageProfilePhotoView: View {
    @State var imageName: String
    @State var size: CGFloat
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .clipShape(Circle())
    }
}

#Preview {
    UIImageProfilePhotoView(imageName: "Test", size: 100)
}
