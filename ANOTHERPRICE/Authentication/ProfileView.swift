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
    
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var userName: String = "這是另外的價錢錢"
    @State var registrationDays: Int = 0
    
    @State var 獲讚數: Int = 43250
    @State var 幫助的人: Int = 123
    @State var 粉絲: Int = 456
    @State var  關注: Int = 789
    
    var body: some View {
        ZStack{
            VStack{
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
                        .padding(.leading, 5)
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
                HStack{
                    UITextProfileDetails(detailInput: 獲讚數, detailTitle: "獲讚數")
                    Spacer()
                    UITextProfileDetails(detailInput: 幫助的人, detailTitle: "幫助數")
                    Spacer()
                    UITextProfileDetails(detailInput: 粉絲, detailTitle: "粉絲")
                    Spacer()
                    UITextProfileDetails(detailInput: 關注, detailTitle: "關注")
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                NavigationStack{
                    ScrollView{
                        HStack{
                            Color.white
                        }
                        .frame(height: 90)
                        .cornerRadius(10)
                        HStack{
                            VStack{
                                HStack{
                                    Text("選擇適合自己的粉底液")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                    Spacer()
                                }
                                HStack{
                                    Text("今晚8點 Tommy老師的變美小課堂")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.top, -5)
                            }
                            .padding(.leading, 10)
                            ZStack {
                                Image("Advertise")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200)
                                LinearGradient(gradient: Gradient(colors: [ColorConstants.beige, Color.clear]),
                                               startPoint: .leading,
                                               endPoint: .trailing)
                                .frame(width: 200)
                            }
                        }
                        .frame(height: 80)
                        .background(ColorConstants.beige)
                        .cornerRadius(10)
                        ZStack{
                            Color.brown
                        }
                        .frame(height: 140)
                        .cornerRadius(10)
                        VStack{
                            HStack{
                                Text("其他服務")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                Spacer()
                            }
                            .padding(.top, 10)
                            NavigationLink {
                                TempView()
                            } label: {
                                UIImageExtoolCustom(imageName: "headset", toolTitle: "客服中心")
                            }
                            .padding(.top, 10)
                            NavigationLink {
                                TempView()
                            } label: {
                                UIImageExtoolCustom(imageName: "gearshape", toolTitle: "設定")
                            }
                            .padding(.top, 10)
                            Spacer()
                        }
                        .padding(.leading, 10)
                    }
                    .background(Color.gray.opacity(0.1))
                }
            }
            .padding(.horizontal, 15)
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
        .background(Color.gray.opacity(0.1))
        .onAppear {
            self.authUid = keychain.get("authUid")
        }
    }
}

#Preview {
    ProfileView()
}
