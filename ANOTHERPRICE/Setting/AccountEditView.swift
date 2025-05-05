//
//  temp7.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct AccountEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var account: String = ""
    @State private var isAccountDuplicate: Bool = false
    @State private var showPointAlert = false
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .frame(width: 80)
                Spacer()
                Text("變更帳號")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        Task {
                            await updateAccount()
                        }
                    } label: {
                        Text("變更")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.gray)
                            .frame(height: 36)
                    }
                    .padding(.trailing, 10)
                    .disabled(account.isEmpty || isAccountDuplicate || showPointAlert)                }
                .frame(width: 80)
            }
            .frame(height: 36)
            .background(Color.white)
            HStack{
                TextField("請輸入新帳號", text: $account)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .onChange(of: account) {
                        checkAccount{ isDuplicate in
                            DispatchQueue.main.async {
                                isAccountDuplicate = isDuplicate
                            }
                        }
                    }
                if !account.isEmpty {
                    Image(systemName: isAccountDuplicate ? "exclamationmark.triangle.fill" :"checkmark")
                        .font(.system(size: 14))
                        .foregroundColor(isAccountDuplicate ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
                }
            }
                .padding(.horizontal, 15)
                .padding(.top, 10)
                .frame(height: 24)
            Rectangle()
                .fill(ColorConstants.systemMainColor)
                .frame(height: 1.5)
                .padding(.horizontal, 15)
            HStack{
                Text("修改帳號需要消耗 100 點")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, -5)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .alert("點數不足", isPresented: $showPointAlert) {
            Button("確認") { }
        } message: {
            Text("變更暱稱需要 100 點，請前往任務中心獲得更多點數")
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
    
    private func updateAccount() async{
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userUid)
        
        do {
            let snapshot = try await userRef.getDocument()
            if let data = snapshot.data(),
               let currentPoints = data["point"] as? Int,
               currentPoints >= 100 {
                
                try await userRef.updateData([
                    "account": account,
                    "point": currentPoints - 100
                ])
                dismiss()
                
            } else {
                showPointAlert = true
                print("(userNameEditView)點數不足")            }
        } catch {
            print("(userNameEditView)更新暱稱失敗：\(error.localizedDescription)")
        }
    }
}

#Preview {
    AccountEditView()
}
