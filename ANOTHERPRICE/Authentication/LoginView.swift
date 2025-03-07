//
//  LoginView.swift
//  ANOTHERPRICE
//
//  Created by 宜真 on 2025/2/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import KeychainSwift

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var account = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var showForgotPasswordView = false
    @State private var showSignupView = false
    @State private var isLoggedIn = false
    
    private let keychain = KeychainSwift()
    
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
                    UITextFieldCustom(title: "帳號", input: $account)
                    UISecureFieldCustom(title: "密碼", input: $password)
                    HStack{
                        Spacer()
                        Button() {
                            showForgotPasswordView = true
                        } label: {
                            Text("忘記密碼")
                                .font(.custom("NotoSerifTC-Regular", size: 16))
                                .foregroundColor(ColorConstants.systemMainColor)
                                .fontWeight(.light)
                                .underline()
                        }
                        .padding(.top, -5)
                        .sheet(isPresented: $showForgotPasswordView) {
                            ForgotPasswordView()
                                .presentationDetents([.fraction(0.9)])
                        }
                    }
                    UIButtonCustom(title: "登入", action: loginAction)
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
                        .sheet(isPresented: $showSignupView) {
                            SignupView()
                                .presentationDetents([.fraction(0.9)])
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
        .padding(.top, 20)
    }
    
    private func loginAction() {
        guard !account.isEmpty else {
            showAlertWithMessage("請輸入帳號")
            return
        }
        guard !password.isEmpty else {
            showAlertWithMessage("請輸入密碼")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").whereField("account", isEqualTo: account).getDocuments { (querySnapshot, error) in
            if error != nil {                self.showAlertWithMessage("網路錯誤，請稍後再試")
                return
            }
            
            guard let snapshot = querySnapshot, !snapshot.isEmpty else {
                self.showAlertWithMessage("帳號不存在")
                return
            }
            if let document = snapshot.documents.first, let email = document.data()["email"] as? String {
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        self.handleLoginError(error)
                    } else {
                        let authUid = authResult?.user.uid ?? ""
                        self.keychain.set(authUid, forKey: "authUid")
                        print("登入成功，使用者 ID: \(authResult?.user.uid ?? "")")
                        self.isLoggedIn = true
                        dismiss()
                    }
                }
            } else {
                self.showAlertWithMessage("無法找到該帳號的資料")
            }
        }
    }
    
    private func showAlertWithMessage(_ message: String) {
        errorMessage = message
        showAlert = true
    }
    
    private func handleLoginError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
            switch errorCode {
            case .userNotFound:
                showAlertWithMessage("帳號不存在")
            default:
                showAlertWithMessage("密碼錯誤")
            }
        } else {
            showAlertWithMessage("發生未知錯誤: \(error.localizedDescription)")
        }
    }
}

#Preview {
    LoginView()
}
