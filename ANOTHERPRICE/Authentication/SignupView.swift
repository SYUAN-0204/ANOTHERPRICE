//
//  SignupView.swift
//  ANOTHERPRICE
//
//  Created by 宜真 on 2025/2/22.
//

import SwiftUI

struct SignupView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            UIImageCustom(imageName: "Title")
                .padding(.horizontal, 80)
                .padding(.vertical, 10)
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                VStack{
                    UITextTitle(title: "帳號註冊")
                    UITextFieldCustom(title: "姓名", input: $username)
                    UITextFieldCustom(title: "帳號", input: $username)
                    UISecureFieldCustom(title: "密碼", input: $password)
                    UISecureFieldCustom(title: "確認密碼", input: $password)
                    UITextFieldCustom(title: "Email", input: $username)
                    UIButtonCustom(title: "註冊")
                        .padding(.top, 26)
                    HStack{
                        Spacer()
                        Text("已經有帳號嗎？")
                            .font(.custom("NotoSerifTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemSubColor)
                            .fontWeight(.light)
                        Button() {
                            dismiss()
                        } label: {
                            Text("帳號登入")
                                .font(.custom("NotoSerifTC-Regular", size: 16))
                                .foregroundColor(ColorConstants.systemMainColor)
                                .fontWeight(.light)
                                .underline()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
            }
            .frame(height: 600)
            .padding(20)
            Spacer()
        }
    }
    
}

#Preview {
    SignupView()
}

