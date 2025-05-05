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
    
    @State private var userName = ""
    @State private var account = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var email = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var isAccountDuplicate: Bool? = nil
    @State private var isUserNameDuplicate: Bool? = nil
    
    var body: some View {
        ScrollView{
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                    VStack{
                        UITextTitle(title: "帳號註冊")
                        UITextFieldCustom(title: "暱稱", input: $userName)
                            .onChange(of: userName) {
                                checkUserName { isDuplicate in
                                    DispatchQueue.main.async {
                                        isUserNameDuplicate = isDuplicate
                                    }
                                }
                            }
                        if !userName.isEmpty, let isDuplicate = isUserNameDuplicate  {
                            HStack {
                                Image(systemName: isDuplicate ? "exclamationmark.triangle.fill" :"checkmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(isDuplicate ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
                                Text(isDuplicate ? "暱稱已被註冊" : "暱稱可以使用")
                                    .font(.custom("NotoSerifTC-Regular", size: 14))
                                    .foregroundColor(isDuplicate ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
                                Spacer()
                            }
                            .padding(.leading, 5)
                        }
                        UITextFieldCustom(title: "帳號", input: $account)
                            .onChange(of: account) {
                                checkAccount { isDuplicate in
                                    DispatchQueue.main.async {
                                        isAccountDuplicate = isDuplicate
                                    }
                                }
                            }
                        if !account.isEmpty, let isDuplicate = isAccountDuplicate  {
                            HStack {
                                Image(systemName: isDuplicate ? "exclamationmark.triangle.fill" :"checkmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(isDuplicate ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
                                Text(isDuplicate ? "帳號已被註冊" : "帳號可以使用")
                                    .font(.custom("NotoSerifTC-Regular", size: 14))
                                    .foregroundColor(isDuplicate ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
                                Spacer()
                            }
                            .padding(.leading, 5)
                        }
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
        }
        .alert("註冊錯誤", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .padding(.top, 20)
    }
    
    private func signupAction() {
        checkUserName { isDuplicate in
            if isDuplicate {
                errorMessage = "該暱稱已經被註冊"
                showAlert = true
                return
            }
        }
        
        checkAccount { isDuplicate in
            if isDuplicate {
                errorMessage = "該帳號名稱已經被註冊"
                showAlert = true
                return
            }
        }
        
        checkEmail { isDuplicate in
            if isDuplicate {
                errorMessage = "該 Email 已經被註冊"
                showAlert = true
                return
            }
        }
        
        // checkrule
        if !validateUserNameWidth() {
            errorMessage = "暱稱過長，最多8個中文或16個英文字"
            showAlert = true
            return
        }
        
        let checks: [(Bool, String)] = [
            (userName.isEmpty, "請輸入暱稱"),
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
                guard let user = authResult?.user else { return }
                
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "userName": userName,
                    "email": email,
                    "account": account,
                    "registrationTime": Timestamp(date: Date()),
                    "hearts":0,
                    "helps":0,
                    "followers": 0,
                    "following": 0,
                    "point": 100,
                    "exp": 100,
                    "bio": "",
                    "questionPrivacy": "公開",
                    "answerPrivacy": "公開",
                    "appliedThemeName": "經典黑白"
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
    
    private func checkUserName(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let accountQuery = db.collection("users").whereField("userName", isEqualTo: userName)
        
        accountQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("(SignupView)暱稱查詢錯誤: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(querySnapshot?.documents.isEmpty == false)
        }
    }
    
    private func checkAccount(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let accountQuery = db.collection("users").whereField("account", isEqualTo: account)
        
        accountQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("(SignupView)帳號查詢錯誤: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(querySnapshot?.documents.isEmpty == false) // 如果帳號已經存在，回傳 true
        }
    }
    
    private func checkEmail(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let emailQuery = db.collection("users").whereField("email", isEqualTo: email)
        
        emailQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("(SignupView)Email 查詢錯誤: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(querySnapshot?.documents.isEmpty == false) // 如果 Email 已經存在，回傳 true
        }
    }
    
    private func validateUserNameWidth() -> Bool {
        var totalLength: Double = 0
        var result = ""

        for char in userName {
            let scalarValue = char.unicodeScalars.first?.value ?? 0
            let isASCII = scalarValue <= 127

            if isASCII {
                totalLength += 0.5
            } else {
                totalLength += 1.0
            }

            if totalLength <= 8 {
                result.append(char)
            } else {
                break
            }
        }

        userName = result
        return totalLength <= 8
    }
}

#Preview {
    SignupView()
}

