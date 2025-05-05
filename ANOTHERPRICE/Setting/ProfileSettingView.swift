//
//  Untitled.swift
//  ANOTHERPRICE
//
//  Created by 宜真on 2025/3/22.
//

import SwiftUI
import PhotosUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var userAvatar: UIImage = UIImage(named: "Advertise") ?? UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var selectedItem: PhotosPickerItem? // 用於 iOS 16+ PhotosPicker

    var body: some View {
        VStack{
            UINavigationBar(title: "帳號資料")
            VStack(spacing: 0){
                Button(){
                    self.showPhotoOptions.toggle()
                } label: {
                    HStack {
                        Text("頭像")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        UIProfileImage(photo: userAvatar, width: 60, height: 60)
                            .padding(.trailing, -5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                }
                .photosPicker(isPresented: $showPhotoOptions, selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let newItem = selectedItem,
                           let data = try? await newItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            // 裁剪成正方形後再更新頭像
                            if let croppedImage = image.cropToSquare() {
                                userAvatar = croppedImage
                            } else {
                                userAvatar = image
                            }
                        }
                    }
                }
                .frame(height: 80)
                UIRectangleLine(opacity: 0.1)
                NavigationLink{
                    AccountEditView()
                } label: {
                    HStack {
                        Text("帳號")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text("HonestElf")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                            .padding(.trailing, -5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                }
                .frame(height: 50)
                UIRectangleLine(opacity: 0.1)
                NavigationLink{
                    UserNameEditView()
                } label: {
                    HStack {
                        Text("暱稱")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text("誠實精靈")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                            .padding(.trailing, -5)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                }
                .frame(height: 50)
            }
            .background(.white)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ProfileSettingView()
}
