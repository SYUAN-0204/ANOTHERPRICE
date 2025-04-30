//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/30.
//

import SwiftUI

struct UIComplexUser: View {
    @State private var cancelFollow: Bool = false
    @Binding var follow: Bool
    let userAvatar: UIImage
    let fans: Int
    
    var body: some View {
        NavigationLink{
            DisplayView(isMyDisplayView: false)
        } label: {
            HStack{
                Image(uiImage: userAvatar)
                    .resizable()
                    .scaledToFill() // 確保填滿圓形
                    .frame(width: 50, height: 50) // 限制大小
                    .background(Color(.systemGray6))
                    .clipShape(Circle()) // 剪裁為圓形
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
                Button{
                    if !follow {
                        follow = true
                    }
                    else {
                        cancelFollow = true
                    }
                } label: {
                    if follow {
                        ZStack{
                            RoundedRectangle(cornerRadius: 3)
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
                            RoundedRectangle(cornerRadius: 3)
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
                .alert("取消關注 帳戶暱稱", isPresented: $cancelFollow) {
                    Button("取消", role: .cancel) { }
                    Button("確定", role: .destructive) {
                        follow = false
                    }
                }
            }
        }
    }
}

#Preview {
    UIComplexUser(follow: .constant(true), userAvatar: UIImage(), fans: 35)
}
