//
//  SettingView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/18.
//

import SwiftUI
import KeychainSwift
import FirebaseAuth
import FirebaseFirestore

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var logout: Bool = false
    @State private var authUid: String? = KeychainSwift().get("authUid")
    
    private let keychain = KeychainSwift()
    
    var body: some View {
        VStack{
            UINavigationBar(title: "設定")
            VStack{
                VStack(spacing: 0){
                    NavigationLink{
                        ProfileSettingView()
                    } label: {
                        HStack{
                            Text("帳號資料")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    UIRectangleLine(opacity: 0.1)
                    NavigationLink{
                        DisplaySettingView()
                    } label: {
                        HStack{
                            Text("主頁設定")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    UIRectangleLine(opacity: 0.1)
                    NavigationLink{
                        MessageSettingView()
                    } label: {
                        HStack{
                            Text("訊息設定")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                }
                .background(Color.white)
                
                NavigationLink{
                    ChangeAccountView()
                } label: {
                    HStack{
                        Spacer()
                        Text("切換帳號")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 10)
                .background(Color.white)
                .padding(.top, 10)
                
                VStack(spacing: 0){
                    UIButtonSettingTool(title: "登出帳號", action: {
                        logout = true
                    })
                }
                .background(Color.white)
                
                VStack(spacing: 0){
                    Button(action: {
                        deleteAccountAction()
                    }) {
                        HStack{
                            Spacer()
                            Text("刪除帳號")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.tomatoRed)
                            Spacer()
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 10)
                    }
                }
                .background(Color.white)
                .padding(.top, 10)
            }
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .alert("登出帳號", isPresented: $logout) {
            Button("取消", role: .cancel) { }
            Button("確定", role: .destructive) {
                logoutAction()
            }
        }
        
    }
    
    private func logoutAction() {
        keychain.delete("authUid")
        keychain.delete("userName")
        keychain.delete("registDay")
        dismiss()
    }
    
    private func deleteAccountAction() {
        guard let userUid = KeychainSwift().get("authUid") else {
            return
        }
        
        let alertController = UIAlertController(title: "確定要刪除帳號嗎?", message: "此操作無法撤銷", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "確定", style: .destructive, handler: { _ in
            deleteAccountFromFirebase(userUid: userUid)
        }))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
    }
    
    private func deleteAccountFromFirebase(userUid: String) {
        let db = Firestore.firestore()
        
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("刪除帳戶失敗: \(error.localizedDescription)")
                return
            }
            print("(SettingView)帳號已成功刪除")
            
            db.collection("users").document(userUid).delete { error in
                if let error = error {
                    print("刪除用戶資料失敗: \(error.localizedDescription)")
                    return
                }
                print("(SettingView)用戶資料已成功刪除")
                
                logoutAction()
            }
        }
    }
}

#Preview {
    SettingView()
}
