//
//  UINavigationLinkProfileTool.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/13.
//

import SwiftUI

struct UINavigationLinkProfileTool<Destination: View>: View {
    let destination: Destination
    let icon: String
    let title: String
    
    var body: some View {
        NavigationLink{
            destination
        } label: {
            VStack{
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .frame(height: 30)
                Text(title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
            }
        }
    }
}

#Preview {
    UINavigationLinkProfileTool(destination: Text("預覽畫面"), icon: "", title: "")
}
