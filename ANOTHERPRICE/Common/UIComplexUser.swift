//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/30.
//

import SwiftUI

struct UIComplexUser: View {
    @Binding var follow: Bool
    let userAvatar: UIImage
    let fans: Int
    
    var body: some View {
        NavigationLink{
            DisplayView(isMyDisplayView: false)
        } label: {
            HStack{
                UIProfileImage(photo: userAvatar, width: 50, height: 50)
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Text("用戶名稱")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemSubColor)
                        UITextLevel(totalExp: 832, width: 26, height: 12, size: 10)
                    }
                    Text("粉絲・\(fans)")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                        .foregroundColor(.gray)
                    Text("帳號・rfrerecd")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                UIButtonFollow(follow: $follow)
            }
        }
    }
}

#Preview {
    UIComplexUser(follow: .constant(true), userAvatar: UIImage(), fans: 35)
}
