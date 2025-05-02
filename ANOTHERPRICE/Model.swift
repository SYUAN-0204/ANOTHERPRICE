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
    init(hex: String, opacity: Double = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.removeFirst()
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct ColorConstants {
    static let systemMainColor = Color(hex: "#3D708F")
    static let systemSubColor = Color(hex: "#122D3E")
    static let systemDarkColor = Color(hex: "#212529")
    static let beige = Color(hex: "#FFFFF0")
    static let emeraldGreen = Color(hex: "#2E8B57")
    static let tomatoRed = Color(hex: "#D94A38")
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

enum PhotoSource: Identifiable {
    case photoLibrary
    case camera
    
    var id: Int {
        hashValue
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

enum TabIdentifier: Hashable {
    case home, search, issue, message, profile
}

enum Route: Hashable {
    case issueEdit(isDraft: Bool, draftId: String?, title: String, description: String)
    case issueSetting
    case publish
    case draft
}

class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []
    
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func replace(with route: Route) {
        path = [route]
    }
}

extension UIImage {
    func cropToAspectRatio(widthRatio: CGFloat, heightRatio: CGFloat) -> UIImage? {
        let imageSize = self.size
        let targetRatio = widthRatio / heightRatio
        let imageRatio = imageSize.width / imageSize.height

        var cropRect = CGRect.zero
        if imageRatio > targetRatio {
            // 原圖太寬，裁左右
            let newWidth = imageSize.height * targetRatio
            let x = (imageSize.width - newWidth) / 2
            cropRect = CGRect(x: x, y: 0, width: newWidth, height: imageSize.height)
        } else {
            // 原圖太高，裁上下
            let newHeight = imageSize.width / targetRatio
            let y = (imageSize.height - newHeight) / 2
            cropRect = CGRect(x: 0, y: y, width: imageSize.width, height: newHeight)
        }

        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

extension Double {
    func f(_ places: Int) -> String {
        let rounded = (self * pow(10, Double(places))).rounded() / pow(10, Double(places))
        if rounded == floor(rounded) {
            return String(format: "%.0f", rounded) // 沒有小數
        } else {
            return String(format: "%.\(places)f", rounded) // 有小數
        }
    }
}
