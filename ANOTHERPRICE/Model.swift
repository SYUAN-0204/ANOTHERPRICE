//
//  Model.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/18.
//

import Foundation
import SwiftUI
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

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
    static let beige = Color(hex: 0xFFFFF0)
    static let emeraldGreen = Color(hex: 0x2E8B57)
    static let tomatoRed = Color(hex: 0xD94A38)
}

extension UIImage {
    func cropToSquare() -> UIImage? {
        let contextImage = UIImage(cgImage: self.cgImage!)
        let contextSize = contextImage.size
        
        let length = min(contextSize.width, contextSize.height)
        let posX = (contextSize.width - length) / 2
        let posY = (contextSize.height - length) / 2
        
        let rect = CGRect(x: posX, y: posY, width: length, height: length)
        
        guard let imageRef = contextImage.cgImage?.cropping(to: rect) else {
            return nil
        }
        
        return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
