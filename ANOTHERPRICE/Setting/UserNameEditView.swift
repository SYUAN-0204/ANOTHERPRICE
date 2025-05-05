//
//  temp6.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct UserNameEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var userName: String = ""
    @State private var isUserNameDuplicate: Bool = false
    @State private var length: Double = 0
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
                Text("變更暱稱")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        Task {
                            await updateUserName()
                        }
                    } label: {
                        Text("變更")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.gray)
                            .frame(height: 36)
                    }
                    .padding(.trailing, 10)
                    .disabled(userName.isEmpty || isUserNameDuplicate || showPointAlert)
                }
                .frame(width: 80)
            }
            .frame(height: 36)
            .background(Color.white)
            HStack{
                TextField("請輸入新暱稱", text: $userName)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .onChange(of: userName) {
                        userName = userName.replacingOccurrences(of: "\n", with: "")
                        
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
                        length = totalLength
                        userName = result
                        checkUserName { isDuplicate in
                            DispatchQueue.main.async {
                                isUserNameDuplicate = isDuplicate
                            }
                        }
                    }
                if !userName.isEmpty {
                    Image(systemName: isUserNameDuplicate ? "exclamationmark.triangle.fill" :"checkmark")
                        .font(.system(size: 14))
                        .foregroundColor(isUserNameDuplicate ? ColorConstants.tomatoRed : ColorConstants.emeraldGreen)
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
                Text("修改暱稱需要消耗 100 點")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(length.f(1))/8")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(.gray)
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
    
    private func updateUserName() async{
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
                    "userName": userName,
                    "point": currentPoints - 100
                ])
                keychain.set(userName, forKey: "userName")
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
    UserNameEditView()
}
