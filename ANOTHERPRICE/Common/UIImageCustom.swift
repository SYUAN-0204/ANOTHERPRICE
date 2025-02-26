//
//  UIImageCustom.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/26.
//

import SwiftUI

struct UIImageCustom: View {
    @State var imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    UIImageCustom(imageName: "")
}
