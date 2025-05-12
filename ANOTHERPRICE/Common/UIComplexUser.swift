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
    let exp:Int
    let userName: String
    
    var body: some View {
        NavigationLink{
            //DisplayView(isMyDisplayView: false)
            ErrorView()
        } label: {
            HStack{
                UIProfileImage(photo: userAvatar, width: 50, height: 50)
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Text(userName)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemSubColor)
                        UITextLevel(totalExp: exp, width: 26, height: 12, size: 10)
                    }
                    Text("粉絲・\(fans)")
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
    UIComplexUser(follow: .constant(true), userAvatar: UIImage(), fans: 35,exp: 50,userName: "用戶名稱")
}
