//
//  ProfileSettingView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/11.
//

import SwiftUI
import PhotosUI

struct ProfileSettingView: View {
    
    @State var 用戶頭像: UIImage = UIImage(named: "Test") ?? UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var selectedItem: PhotosPickerItem? // 用於 iOS 16+ PhotosPicker
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        HStack {
            Image(uiImage: 用戶頭像)
                .resizable()
                .scaledToFill() // 確保填滿圓形
                .frame(width: 70, height: 70) // 限制大小
                .background(Color(.systemGray6))
                .clipShape(Circle()) // 剪裁為圓形
                .overlay(
                    Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                )
                .onTapGesture {
                    self.showPhotoOptions.toggle()
                }
            Spacer()
        }
        .padding()
        .photosPicker(isPresented: $showPhotoOptions, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) {
            Task {
                if let newItem = selectedItem,
                   let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    // 裁剪成正方形後再更新頭像
                    if let croppedImage = image.cropToSquare() {
                        用戶頭像 = croppedImage
                    } else {
                        用戶頭像 = image
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileSettingView()
}
