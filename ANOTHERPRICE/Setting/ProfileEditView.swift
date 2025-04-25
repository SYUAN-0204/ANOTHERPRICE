//
//  Untitled.swift
//  ANOTHERPRICE
//
//  Created by 宜真on 2025/3/22.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var userAvatar: UIImage = UIImage(named: "Advertise") ?? UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var selectedItem: PhotosPickerItem? // 用於 iOS 16+ PhotosPicker

    var body: some View {
        VStack{
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
                Text("帳號資料")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .opacity(0)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 36)
            .background(Color.white)
            VStack(spacing: 0){
                Button(){
                    self.showPhotoOptions.toggle()
                } label: {
                    HStack {
                        Text("頭像")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Image(uiImage: userAvatar)
                            .resizable()
                            .scaledToFill() // 確保填滿圓形
                            .frame(width: 60, height: 60) // 限制大小
                            .background(Color(.systemGray6))
                            .clipShape(Circle()) // 剪裁為圓形
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
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 1)
                NavigationLink{
                    temp7()
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
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 1)
                NavigationLink{
                    userNameEditView()
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
    ProfileEditView()
}
