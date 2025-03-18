//
//  SignupView.swift
//  ANOTHERPRICE
//
//  Created by 宜真 on 2025/2/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var username = ""
    @State private var account = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                VStack{
                    UITextTitle(title: "帳號註冊")
                    UITextFieldCustom(title: "姓名", input: $username)
                    UITextFieldCustom(title: "帳號", input: $account)
                    UISecureFieldCustom(title: "密碼", input: $password)
                    UISecureFieldCustom(title: "確認密碼", input: $confirmPassword)
                    UITextFieldCustom(title: "Email", input: $email)
                    UIButtonAccountCustom(title: "註冊", action: signupAction)
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
        .alert("註冊錯誤", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .padding(.top, 20)
    }
    
    private func signupAction() {
        // checkrule
        let checks: [(Bool, String)] = [
            (username.isEmpty, "請輸入姓名"),
            (account.isEmpty, "請輸入帳號"),
            (password.isEmpty, "請輸入密碼"),
            (confirmPassword.isEmpty, "請再次輸入密碼"),
            (password != confirmPassword, "密碼與確認密碼不一致"),
            (email.isEmpty || !email.contains("@"), "請提供有效的 Email")
        ]
        
        for check in checks {
            if check.0 {
                errorMessage = check.1
                showAlert = true
                return
            }
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                errorMessage = error.localizedDescription
                showAlert = true
            } else {
                // save relative data to Firestore
                guard let user = authResult?.user else { return }
                
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "username": username,
                    "email": email,
                    "account": account,
                    "registrationTime": Timestamp(date: Date())
                ]) { error in
                    if let error = error {
                        errorMessage = "儲存資料到 Firestore 時發生錯誤: \(error.localizedDescription)"
                        showAlert = true
                    } else {
                        print("帳號建立無誤")
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SignupView()
}

