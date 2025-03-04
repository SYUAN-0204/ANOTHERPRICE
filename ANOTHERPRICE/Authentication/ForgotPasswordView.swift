//
//  ForgotPasswordView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var account = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                VStack{
                    UITextTitle(title: "忘記密碼")
                    UITextFieldCustom(title: "帳號", input: $account)
                    UIButtonCustom(title: "申請", action: {})
                        .padding(.top, 26)
                    HStack{
                        Spacer()
                        Text("還沒有帳號嗎？")
                            .font(.custom("NotoSerifTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemSubColor)
                            .fontWeight(.light)
                        Button() {
                            dismiss()
                        } label: {
                            Text("帳號註冊")
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
            .frame(height: 300)
            .padding(20)
            Spacer()
        }
        .alert("登入錯誤", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .padding(.top, 20)
    }
}

#Preview {
    ForgotPasswordView()
}
