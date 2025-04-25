//
//  temp8.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI
import PhotosUI

struct DisplayView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var selectedItem: PhotosPickerItem? // 用於 iOS 16+ PhotosPicker
    
    let isMyDisplayView: Bool
    @State private var isSelected: Bool = true
    @State private var isFollowing: Bool = false
    @State private var isUnfollowed: Bool = false
    @State private var isMessaging: Bool = false
    @State private var isVisitorBlocked: Bool = true
    @State private var isFanBlocked: Bool = true
    
    var body: some View {
        ZStack(alignment: .top){
            Image(uiImage: userAvatar)
                .resizable()
                .scaledToFill()
                .frame(width: 402, height: 260)
                .clipped()
                .overlay(
                    Color.black.opacity(0.8)
                )
                .ignoresSafeArea(edges: .top)
            VStack{
                VStack{
                    HStack {
                        HStack{
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .frame(width: 80)
                        Spacer()
                        Text("")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .fontWeight(.semibold)
                        Spacer()
                        HStack{
                            Spacer()
                            Button {
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 80)
                    }
                    .frame(height: 36)
                    HStack{
                        Button(){
                            self.showPhotoOptions.toggle()
                        } label: {
                            Image(uiImage: userAvatar)
                                .resizable()
                                .scaledToFill() // 確保填滿圓形
                                .frame(width: 70, height: 70) // 限制大小
                                .background(Color(.systemGray6))
                                .clipShape(Circle()) // 剪裁為圓形
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 0.1)
                                )
                        }
                        .disabled(isMyDisplayView)
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
                        VStack{
                            HStack{
                                Text("這是另外")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    .foregroundColor(.white)
                                UITextLevel(totalExp: 14534, width: 40, height: 18, size: 14)
                                HStack{
                                    Text("著陸 56 天")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                            }
                            HStack{
                                HStack{
                                    UITextPageDetails(detailInput: 1000000, detailTitle: "粉絲")
                                    Spacer()
                                    UITextPageDetails(detailInput: 0, detailTitle: "關注")
                                    Spacer()
                                    UITextPageDetails(detailInput: 0, detailTitle: "獲讚")
                                }
                                .frame(width: 160)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .frame(height: 70)
                    Text("路過的旅人並未在此留下痕跡")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .frame(width: 370, alignment: .leading)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .frame(height: 200)
                HStack{
                    Button(){
                        isSelected = true
                    } label: {
                        VStack{
                            Text("提問")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .frame(width: 40)
                            Rectangle()
                                .fill(isSelected ? ColorConstants.systemMainColor:Color.clear)
                                .frame(height: 1.5)
                                .padding(.top, -10)
                                .frame(width: 46)
                        }
                    }
                    .disabled(isSelected)
                    .frame(width: 60)
                    .padding(.top, 10)
                    Button(){
                        isSelected = false
                    } label: {
                        VStack{
                            Text("回答")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .frame(width: 40)
                            Rectangle()
                                .fill(!isSelected ? ColorConstants.systemMainColor:Color.clear)
                                .frame(height: 1.5)
                                .padding(.top, -10)
                                .frame(width: 46)
                        }
                    }
                    .disabled(!isSelected)
                    .frame(width: 60)
                    .padding(.top, 10)
                    Spacer()
                    if !isMyDisplayView {
                        Button{
                            if !isFollowing {
                                isFollowing = true
                            }
                            else {
                                isUnfollowed = true
                            }
                        } label: {
                            if isFollowing {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                    .frame(width: 66, height: 24)
                                    HStack{
                                        Text("已關注")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(ColorConstants.systemMainColor)
                                    }
                                }
                            }
                            else {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(ColorConstants.systemMainColor)
                                        .frame(width: 66, height: 24)
                                    HStack{
                                        Image(systemName: "plus")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                            .padding(.trailing, -7)
                                        Text("關注")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(.trailing, 7)
                        Button{
                            isMessaging = true
                        } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                        .frame(width: 66, height: 24)
                                    HStack{
                                        Image(systemName: "ellipsis.message")
                                            .font(.system(size: 12))
                                            .foregroundColor(ColorConstants.systemMainColor)
                                            .padding(.trailing, -7)
                                        Text("私訊")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(ColorConstants.systemMainColor)
                                    }
                                }
                        }
                        .padding(.trailing, 7)
                        .sheet(isPresented: $isMessaging) {
                            tempView()
                                .presentationDetents([.fraction(0.7)])
                        }
                    }
                }
                .frame(height: 20)
                .padding(.horizontal, 5)
                if isSelected {
                    ScrollView{
                        if isVisitorBlocked && !isMyDisplayView {
                            Text("這是另外的價錢沒有向\(isFanBlocked ? " 訪客 ":" 任何用戶 ")開放他的提問")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            Text("\(isFanBlocked ? "\n關注後查看":"")")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, -20)
                            Image(systemName: "lock")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        else {
                            ForEach(0..<12) { _ in
                                UIComplexIssueCard(destination: PostDetailView(來自主頁: false), title: "標題", date: "2025-09-04", common: "2025-04-23", coin: 344, content: "好東西", like: true, heart: 3, message: 4, author: "author", code: "code", http: "http")
                            }
                        }
                    }
                }
                else {
                    ScrollView{
                        if isVisitorBlocked && !isMyDisplayView {
                            Text("這是另外的價錢沒有向\(isFanBlocked ? " 訪客 ":" 任何用戶 ")開放他的回答")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            Text("\(isFanBlocked ? "\n關注後查看":"")")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.gray)
                                .padding(.top, -20)
                            Image(systemName: "lock")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        else {
                            ForEach(0..<12) { _ in
                                UIComplexIssueCard(destination: PostDetailView(來自主頁: true), title: "標題", date: "2025-09-04", common: "2025-04-23", coin: 344, content: "好東西", like: true, heart: 3, message: 4, author: "author", code: "code", http: "http")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationBarBackButtonHidden(true)
        .alert("取消關注 帳戶暱稱", isPresented: $isUnfollowed) {
            Button("取消", role: .cancel) { }
            Button("確定", role: .destructive) {
                isFollowing = false
            }
        }
    }
}

#Preview {
    DisplayView(isMyDisplayView: true)
}
