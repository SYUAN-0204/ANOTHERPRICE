//
//  temp7.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI

struct SystemMessageView: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    
    @State var userAvatar: UIImage = UIImage(named: "Advertise") ?? UIImage()
    @State var showAlert: Bool = false
    @State var isRead: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
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
                Text(title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .alert("提示", isPresented: $showAlert) {
                    Button("全部已讀") {
                    }
                    Button("全部刪除", role: .destructive) {
                    }
                    Button("取消", role: .cancel) {
                        showAlert = false
                    }
                } message: {
                    Text("用戶 用戶名稱 的提問")
                }
            }
            .frame(height: 36)
            .background(Color.white)
            ScrollView {
                ForEach(0..<10, id: \.self) { _ in
                    //這裡要收合成UI，但是變數有點複雜，等你綁完我再來收
                    NavigationLink{
                        PostDetailView(category: "12",documentID:"123",isMyDisplayView: false)
                    } label: {
                        HStack{
                            UIProfileImage(photo: userAvatar, width: 40, height: 40)
                                .padding(.leading, 5)
                            VStack(alignment: .leading){
                                HStack{
                                    if title == "我的提問" {
                                        Text("用戶名稱 回答了你的提問")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                                            .foregroundColor(ColorConstants.systemDarkColor)
                                    }
                                    if title == "我的獲讚" {
                                        Text("用戶名稱 點讚了你的提問")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                                            .foregroundColor(ColorConstants.systemDarkColor)
                                        /*
                                         Text("用戶名稱 點讚了你的回答")
                                         .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                                         .foregroundColor(ColorConstants.systemDarkColor)
                                         */
                                    }
                                    if title == "我的關注" {
                                        Text("用戶名稱 發布了一篇問答")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                                            .foregroundColor(ColorConstants.systemDarkColor)
                                    }
                                    if title == "系統通知" {
                                        Text("異地登入提示")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                                            .foregroundColor(ColorConstants.systemDarkColor)
                                    }
                                    Spacer()
                                    Text("4-22")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                        .padding(.trailing, 5)
                                }
                                HStack{
                                    if title == "系統通知" {
                                        Text("您的帳號於 4-22 17:54 在其他裝置登入")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                                            .lineLimit(1)
                                    }
                                    else {
                                    Text("提問標題")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 15))
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                                        .lineLimit(1)
                                    }
                                    Spacer()
                                    if !isRead {
                                        Rectangle()
                                            .fill(ColorConstants.systemMainColor)
                                            .frame(width: 4, height: 4)
                                            .cornerRadius(2)
                                            .padding(.trailing, 15)
                                    }
                                }
                                .padding(.top, -5)
                            }
                        }
                    }
                    .contextMenu {
                        Button {
                            print("刪除通知")
                        } label: {
                            Label("刪除通知", systemImage: "trash")
                        }
                        Button {
                            isRead = true
                            print("標記已讀")
                        } label: {
                            Label("標記已讀", systemImage: "envelope.open")
                        }
                    }
                    UIRectangleLine(opacity: 0.1)
                        .padding(.horizontal, 3)
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SystemMessageView(title: "我的")
}
