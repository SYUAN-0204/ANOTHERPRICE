//
//  ForgotPasswordView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var account = ""
    @State private var showAlert = false
    @State private var message = ""
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 7)
                    .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                VStack{
                    UITextTitle(title: "忘記密碼")
                    UITextFieldCustom(title: "帳號/E-mail", input: $account)
                    UIButtonAccountCustom(title: "申請", action:{sendPasswordReset()})
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
        .alert("訊息", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(message)
        }
        .padding(.top, 20)
    }
    
    private func sendPasswordReset() {
        guard !account.isEmpty else {
            self.message = "請輸入帳號/E-mail"
            self.showAlert = true
            return
        }
        
        if isValidEmail(account) {
            sendPasswordResetToEmail(account)
        } else {
            sendPasswordResetToFirestoreAccount(account)
        }
    }
    
    private func sendPasswordResetToEmail(_ email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            handlePasswordResetError(error)
        }
    }
    
    private func sendPasswordResetToFirestoreAccount(_ account: String) {
        let db = Firestore.firestore()
        db.collection("users").whereField("account", isEqualTo: account).getDocuments { (querySnapshot, error) in
            if error != nil {
                self.message = "網路錯誤，請稍後再試"
                self.showAlert = true
                return
            }
            
            guard let snapshot = querySnapshot, !snapshot.isEmpty else {
                self.message = "帳號不存在"
                self.showAlert = true
                return
            }
            
            if let document = snapshot.documents.first, let email = document.data()["email"] as? String {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    handlePasswordResetError(error)
                }
            } else {
                self.message = "無法找到該帳號的資料"
                self.showAlert = true
            }
        }
    }
    
    private func handlePasswordResetError(_ error: Error?) {
        if let error = error {
            self.message = error.localizedDescription
        } else {
            self.message = "密碼重置郵件已發送，請檢查您的信箱"
        }
        self.showAlert = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    ForgotPasswordView()
}
