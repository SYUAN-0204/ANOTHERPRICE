//
//  ProfileView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI
import KeychainSwift

struct ProfileView: View {
    
    @State private var showLoginView = false
    @State private var authUid: String? = nil
    private let keychain = KeychainSwift()
    
    
    @State var 用戶頭像: UIImage = UIImage(named: "Test") ?? UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Image(uiImage: 用戶頭像)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .background(Color(.systemGray6))
                        .overlay {
                            Circle()
                                .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                        }
                        .clipShape(Circle())
                        .onTapGesture {
                            self.showPhotoOptions.toggle()
                        }
                    Spacer()
                }
                Spacer()
            }
            if ((authUid?.isEmpty) == nil) {
                Color.white.opacity(0.9)
                VStack {
                    Text("登入即可體驗完整功能")
                        .font(.custom("NotoSerifTC-Regular", size: 20))
                        .foregroundColor(ColorConstants.systemSubColor)
                    Button(action: {
                        if let authUid = authUid, !authUid.isEmpty {
                            self.keychain.delete("authUid")
                            self.authUid = nil
                        } else {
                            self.showLoginView = true
                        }
                    }) {
                        UIButtonCustom(title: "登入", action: {})
                    }
                    .frame(width: 160)
                    .sheet(isPresented: $showLoginView) {
                        LoginView()
                            .presentationDetents([.fraction(0.9)])
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            self.authUid = keychain.get("authUid")
        }
    }
}

#Preview {
    ProfileView()
}
