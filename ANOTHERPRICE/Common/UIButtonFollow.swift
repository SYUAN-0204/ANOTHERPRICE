//
//  UIButtonFollow.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIButtonFollow: View {
    @Binding var follow: Bool
    @State var cancelFollow: Bool = false
    
    var body: some View {
               Button{
                   if follow {
                       cancelFollow = true
                   } else {
                       follow.toggle()
                   }
               }  label: {
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
                follow.toggle()
            }
        }
    }
}

#Preview {
    UIButtonFollow(follow: .constant(true))
}
