//
//  ProfileView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI
import KeychainSwift
import Foundation

struct ProfileView: View {
    
    @State private var showLoginView = false
    @State private var authUid: String? = nil
    private let keychain = KeychainSwift()
    
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var userName: String? = "這是另外的價錢"
    @State var registrationDays: Int = 0
    @State var likesCount: Int = 0
    @State var peopleHelped: Int = 0
    @State var followers: Int = 0
    @State var following: Int = 0
    @State var level: Int = 1
    
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
                            Text(userName ?? "這是另外的價錢")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(ColorConstants.systemMainColor)
                                    .frame(width: 40, height: 18)
                                Text("Lv \(level)")
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
                    UITextProfileDetails(detailInput: likesCount, detailTitle: "獲讚數")
                    Spacer()
                    UITextProfileDetails(detailInput: peopleHelped, detailTitle: "幫助數")
                    Spacer()
                    UITextProfileDetails(detailInput: followers, detailTitle: "粉絲")
                    Spacer()
                    UITextProfileDetails(detailInput: following, detailTitle: "關注")
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
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
                            IssueView()
                        } label: {
                            UIImageExtoolCustom(imageName: "headset", toolTitle: "客服中心")
                        }
                        .padding(.top, 10)
                        NavigationLink {
                            SettingView()
                        } label: {
                            UIImageExtoolCustom(imageName: "gearshape", toolTitle: "設定")
                        }
                        .padding(.top, 10)
                        Spacer()
                    }
                    .padding(.leading, 10)
                }
            }
            .padding(.horizontal, 15)
            if (authUid == nil) {
                Color.white.opacity(0.9)
                VStack {
                    Text("登入即可體驗完整功能")
                        .font(.custom("NotoSerifTC-Regular", size: 20))
                        .foregroundColor(ColorConstants.systemSubColor)
                    UIButtonAccountCustom(title: "登入", action: {
                        showLoginView = true
                    })
                    .frame(width: 160)
                    .sheet(isPresented: $showLoginView) {
                        LoginView()
                            .onDisappear {
                                self.authUid = keychain.get("authUid")
                                self.userName = keychain.get("userName")
                                self.registrationDays = daysSinceRegistration() + 1
                                        
                                print("Auth UID: \(authUid ?? "nil")")
                                print("User Name: \(userName ?? "nil")")
                                print("Registration Days: \(registrationDays)")
                            }
                            .presentationDetents([.fraction(0.9)])
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .onAppear {
            self.authUid = keychain.get("authUid")
            self.userName = keychain.get("userName")
            self.registrationDays = daysSinceRegistration() + 1
        }
    }
    
    private func daysSinceRegistration() -> Int {
        guard let registDayString = keychain.get("registDay") else {
            return 0
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        
        guard let registDate = dateFormatter.date(from: registDayString) else {
            return 0
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: registDate, to: Date())
        
        return components.day ?? 0
    }
}

#Preview {
    ProfileView()
}
