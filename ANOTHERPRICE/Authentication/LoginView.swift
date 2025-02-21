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
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            // 帳號輸入框
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding() // 給 TextField 增加內邊距
                .padding(.horizontal) // 給左右增加更多內邊距

            // 密碼輸入框
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding() // 給 SecureField 增加內邊距
                .padding(.horizontal) // 給左右增加更多內邊距

            // 錯誤訊息顯示
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // 登入按鈕
            Button(action: {
                loginAction()
            }) {
                Text("Login")
                    .font(.title)
                    .frame(width: 250, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
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

