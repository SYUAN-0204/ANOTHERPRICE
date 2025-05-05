//
//  UINavigationPersonalMessage.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI

struct UINavigationPersonalMessage<Destination: View>: View {
    let destination: Destination
    let userAvatar: UIImage
    let name: String
    let date: String
    let content: String
    let badgeCount: Int
    
    var body: some View {
        NavigationLink{
            destination
        } label: {
            HStack{
                UIProfileImage(photo: userAvatar, width: 46, height: 46)
                    .padding(.leading, 5)
                VStack(alignment: .leading){
                    HStack{
                        Text(name)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                            .foregroundColor(ColorConstants.systemDarkColor)
                        Spacer()
                        Text(date)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                    }
                    .padding(.trailing, 3)
                    HStack{
                        Text(content)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                            .lineLimit(1)
                            .padding(.leading, 2)
                        Spacer()
                        if badgeCount > 0 {
                            let badgeText = badgeCount > 99 ? "99+" : "\(badgeCount)"
                            Text(badgeText)
                                .font(.system(size: 11))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 1)
                                .background(Color.red)
                                .clipShape(Capsule())
                                .fixedSize()
                        }
                    }
                    .padding(.top, -7)
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 10)
        }
        .badge(3)
        .contextMenu {
            Button {
                print("刪除訊息")
            } label: {
                Label("刪除訊息", systemImage: "trash")
            }
            Button {
                print("標記已讀")
            } label: {
                Label("標記已讀", systemImage: "envelope.open")
            }
        }
        UIRectangleLine(opacity: 0.1)
            .padding(.horizontal, 5)
    }
}

#Preview {
    UINavigationPersonalMessage(destination: Text("預覽畫面"), userAvatar: UIImage(), name: "name", date: "2-4", content: "內容", badgeCount: 54)
}
