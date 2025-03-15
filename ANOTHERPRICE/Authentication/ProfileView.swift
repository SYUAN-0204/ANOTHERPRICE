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
    
    @State var userAvatar: UIImage = UIImage(named: "AppIcon") ?? UIImage()
    @State var userName: String = "這是另外的價錢錢"
    @State var registrationDays: Int = 0
    
    var body: some View {
        ZStack{
            ScrollView{
                HStack{
                    Image(uiImage: userAvatar)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                        }
                        .padding(.top, 10)
                        .padding(.leading, 10)
                    VStack{
                        HStack{
                            Text(userName)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(ColorConstants.systemMainColor)
                                    .frame(width: 40, height: 18)
                                Text("Lv3")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        HStack{
                            Text("著陸 \(registrationDays) 天")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    VStack{
                        HStack{
                            Text("個人主頁")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            Image(systemName: "chevron.right")
                                .padding(.leading, -8)
                        }
                    }
                    .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.top, 10)
                .frame(height: 90)
                Spacer()
            }
            if ((authUid?.isEmpty) != nil) {
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
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.1))
        .onAppear {
            self.authUid = keychain.get("authUid")
        }
    }
}

#Preview {
    ProfileView()
}
