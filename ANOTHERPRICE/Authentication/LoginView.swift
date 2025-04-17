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
            Image("Title")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 80)
                .padding(.vertical, 10)
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                VStack{
                    UITextTitle(title: "帳號登入")
                    UITextFieldCustom(title: "帳號/E-mail", input: $account)
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
                    UIButtonAccountCustom(title: "登入", action: loginAction)
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
        
        if isValidEmail(account) {
            loginWithEmail(account)
        } else {
            loginWithFirestoreAccount(account)
        }
    }
    
    private func loginWithEmail(_ email: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                self.handleAuthError(error)
            } else {
                handleSuccessfulLogin(authResult)
            }
        }
    }
    
    private func loginWithFirestoreAccount(_ account: String) {
        let db = Firestore.firestore()
        db.collection("users").whereField("account", isEqualTo: account).getDocuments { (querySnapshot, error) in
            if error != nil {
                self.showAlertWithMessage("網路錯誤，請稍後再試")
                return
            }
            
            guard let snapshot = querySnapshot, !snapshot.isEmpty else {
                self.showAlertWithMessage("帳號不存在")
                return
            }
            
            if let document = snapshot.documents.first, let email = document.data()["email"] as? String {
                self.loginWithEmail(email)
            } else {
                self.showAlertWithMessage("帳號不存在")
            }
        }
    }
    
    private func handleAuthError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
            var errorMessage = ""
            
            switch errorCode {
            case .userNotFound:
                errorMessage = "帳號不存在"
            case .networkError:
                errorMessage = "網路錯誤，請稍後再試"
            default:
                errorMessage = "密碼錯誤"
            }
            
            self.showAlertWithMessage(errorMessage)
        } else {
            self.showAlertWithMessage("發生未知錯誤: \(error.localizedDescription)")
        }
    }
    
    private func handleSuccessfulLogin(_ authResult: AuthDataResult?) {
        let authUid = authResult?.user.uid ?? ""
        self.keychain.set(authUid, forKey: "authUid")
        print("(LoginView)登入成功，使用者 ID: \(authResult?.user.uid ?? "")")
        fetchUserDetails(uid: authUid)
    }
    
    private func fetchUserDetails(uid: String) {
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("獲取使用者資料失敗: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                let userName = data?["userName"] as? String ?? "未知使用者"
                let registrationTime = data?["registrationTime"] as? Timestamp ?? Timestamp()

                // 轉換 Firestore Timestamp 為日期格式
                let formattedDate = formatTimestamp(registrationTime)
                self.keychain.set(userName, forKey: "userName")
                self.keychain.set(formattedDate, forKey: "registDay")

                print("(LoginView)使用者名稱: \(userName)")
                print("(LoginView)註冊時間: \(formattedDate)")
                
            } else {
                print("(LoginView)使用者資料不存在")
            }
            
            self.isLoggedIn = true
            dismiss()
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func showAlertWithMessage(_ message: String) {
        errorMessage = message
        showAlert = true
    }
}

#Preview {
    LoginView()
}
