//
//  Model.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/18.
//

import Foundation
import SwiftUI

//16進位色票轉換
extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

struct ColorConstants {
    static let systemMainColor = Color(hex: 0x3D708F)
    static let systemSubColor = Color(hex: 0x122D3E)
    static let systemDarkColor = Color(hex: 0x212529)
}
