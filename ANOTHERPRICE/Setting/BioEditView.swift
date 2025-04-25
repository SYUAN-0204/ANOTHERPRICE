//
//  temp5.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct BioEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var bio: String = ""
    
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
                Text("個性簽名")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        updateBio()
                    } label: {
                        Text("儲存")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.gray)
                            .frame(height: 36)
                    }
                    .padding(.trailing, 10)
                }
                .frame(width: 80)
            }
            .frame(height: 36)
            .background(Color.white)
            TextEditor(text: $bio)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                .frame(height: 94)
                .scrollContentBackground(.hidden)
                .onChange(of: bio) {
                    bio = bio.replacingOccurrences(of: "\n", with: "")
                    if bio.count > 70 {
                        bio = String(bio.prefix(70))
                    }
                }
                .overlay(
                    Group {
                        if bio.isEmpty {
                            VStack{
                                HStack{
                                    Text("路過的旅人並未在此留下痕跡")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                                .padding(.top, 8)
                                Spacer()
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
            Rectangle()
                .fill(ColorConstants.systemMainColor)
                .frame(height: 1.5)
                .padding(.top, -7)
                .padding(.horizontal, 15)
            HStack{
                Spacer()
                Text("\(bio.count)/70")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadUserBio()
        }
    }
    
    private func loadUserBio() {
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("(BioEditView) 讀取個性簽名失敗：\(error.localizedDescription)")
            } else if let document = document, document.exists {
                self.bio = document.data()?["bio"] as? String ?? ""
            }
        }
    }
    
    private func updateBio(){
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userUid).updateData([
            "bio": bio
        ]) { error in
            if let error = error {
                print("(BioEditView)儲存失敗：\(error.localizedDescription)")
            } else {
                print("(BioEditView)儲存成功")
                dismiss()
            }
        }
    }
}

#Preview {
    BioEditView()
}
