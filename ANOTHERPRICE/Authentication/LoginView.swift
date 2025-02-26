//
//  LoginView.swift
//  ANOTHERPRICE
//
//  Created by 宜真 on 2025/2/21.
//
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var showSignupView = false
    
    var body: some View {
        VStack{
            UIImageCustom(imageName: "Title")
                .padding(.horizontal, 80)
                .padding(.vertical, 10)
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                VStack{
                    UITextTitle(title: "帳號登入")
                    UITextFieldCustom(title: "帳號", input: $username)
                    UISecureFieldCustom(title: "密碼", input: $password)
                    HStack{
                        Spacer()
                        Button() {
                            
                        } label: {
                            Text("忘記密碼")
                                .font(.custom("NotoSerifTC-Regular", size: 16))
                                .foregroundColor(ColorConstants.systemMainColor)
                                .fontWeight(.light)
                                .underline()
                        }
                        .padding(.top, -5)
                    }
                    UIButtonCustom(title: "登入")
                        .padding(.top, 10)
                    HStack{
                        Spacer()
                        Text("還沒有帳號嗎？")
                            .font(.custom("NotoSerifTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemSubColor)
                            .fontWeight(.light)
                        Button() {
                            showSignupView = true
                        } label: {
                            Text("帳號註冊")
                                .font(.custom("NotoSerifTC-Regular", size: 16))
                                .foregroundColor(ColorConstants.systemMainColor)
                                .fontWeight(.light)
                                .underline()
                        }
                        .fullScreenCover(isPresented: $showSignupView) {
                            SignupView()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
            }
            .frame(height: 400)
            .padding(20)
            Spacer()
        }
        .alert("登入錯誤", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loginAction() {
        if username == "user" && password == "password" {
            errorMessage = "Login Successful!"
        } else {
            errorMessage = "Invalid username or password."
        }
    }
    
}

#Preview {
    LoginView()
}
