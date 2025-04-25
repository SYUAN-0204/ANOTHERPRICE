//
//  temp9.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/22.
//

import SwiftUI
import PhotosUI

struct DisplaySettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var userAvatar: UIImage = UIImage(named: "Advertise") ?? UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var selectedItem: PhotosPickerItem? // 用於 iOS 16+ PhotosPicker
    @State private var questionPrivacy:String = "公開"
    @State private var answerPrivacy:String = "公開"
    @State private var privacyOptions = ["公開", "僅限粉絲", "僅限本人"]
    
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
                Text("主頁設定")
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
                        Text("主頁背景")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Image(uiImage: userAvatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 402*0.27, height: 260*0.27)
                                .clipped()
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
                            
                            // 使用比例裁剪 (402:260 ≈ 1.546)
                            let aspectWidth: CGFloat = 402
                            let aspectHeight: CGFloat = 260
                            
                            if let croppedImage = image.cropToAspectRatio(widthRatio: aspectWidth, heightRatio: aspectHeight) {
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
                    BioEditView()
                } label: {
                    HStack {
                        Text("個性簽名")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text("路過的旅人並未在此留下痕跡")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                            .lineLimit(1)
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
                Menu {
                    Picker("Options", selection: $questionPrivacy) {
                        ForEach(privacyOptions, id: \.self) { order in
                            Text(order)
                        }
                    }
                } label: {
                    HStack {
                        Text("提問")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text(questionPrivacy)
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
                Menu {
                    Picker("Options", selection: $answerPrivacy) {
                        ForEach(privacyOptions, id: \.self) { order in
                            Text(order)
                        }
                    }
                } label: {
                    HStack {
                        Text("回答")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Text(answerPrivacy)
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
            .background(Color.white)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DisplaySettingView()
}
