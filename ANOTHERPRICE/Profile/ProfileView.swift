//
//  ProfileView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/4.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import KeychainSwift
import Foundation

struct ProfileView: View {
    @State private var showLoginView = false
    @State private var authUid: String? = nil
    @State private var keychain = KeychainSwift()
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var userName: String? = "這是另外的價錢"
    @State var registrationDays: Int = 0
    @State var likesCount: Int = 0
    @State var peopleHelped: Int = 0
    @State var followers: Int = 0
    @State var following: Int = 0
    @State var exp: Int = 0
    @EnvironmentObject var nav: NavigationCoordinator
    
    @Binding var selectedTab: TabIdentifier
    
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
                            UITextLevel(totalExp: exp, width: 40, height: 18, size: 14)
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
                        NavigationLink{
                            DisplayView(isMyDisplayView: true)
                        } label: {
                            HStack{
                                Text("個人主頁")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                Image(systemName: "chevron.right")
                                    .padding(.leading, -8)
                            }
                            .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .frame(height: 90)
                HStack{
                    UITextProfileDetails(detailInput: $likesCount, detailTitle: "獲讚數")
                    Spacer()
                    UITextProfileDetails(detailInput: $peopleHelped, detailTitle: "幫助數")
                    Spacer()
                    NavigationLink{
                        FansView()
                    } label: {
                        UITextProfileDetails(detailInput: $followers, detailTitle: "粉絲")
                    }
                    Spacer()
                    NavigationLink{
                        FollowView()
                    } label: {
                        UITextProfileDetails(detailInput: $following, detailTitle: "關注")
                    }
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                ScrollView{
                    ZStack{
                        Color.white
                        HStack{
                            UINavigationLinkProfileTool(destination: PublishView(isFromIssue: false, selectedTab: $selectedTab), icon: "tray.full", title: "我的提問")
                            Spacer()
                            Button(){
                                nav.push(.draft)
                            } label: {
                                VStack{
                                    Image(systemName: "pencil.line")
                                        .font(.system(size: 24))
                                        .frame(height: 30)
                                    Text("我的草稿")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                                }
                            }
                            Spacer()
                            UINavigationLinkProfileTool(destination: FavoritesView(), icon: "book.pages", title: "我的收藏")
                            Spacer()
                            UINavigationLinkProfileTool(destination: ShopView(), icon: "bag", title: "點數商城")
                        }
                        .padding(.horizontal, 30)
                    }
                    .frame(height: 80)
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
                    .frame(height: 70)
                    .background(ColorConstants.beige)
                    .cornerRadius(10)
                    .padding(.top, 2)
                    ZStack{
                        Color.white
                        VStack(alignment: .leading){
                            HStack{
                                Text("每日任務")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                Spacer()
                                NavigationLink{
                                    TasksView(selectedTab: $selectedTab)
                                } label: {
                                    Text("任務中心")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                        .foregroundColor(.gray)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.leading, -4)
                                }
                            }
                            Text("問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試問題標題五十個字測試")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .lineLimit(1)
                                .padding(.top, -3)
                            Text("問題標題五\n十個字測試問題標題五十個字測試問題\n標題五十個字測試問題標題五十個字測試問題標題五十個字測試")//控製版面無條件三行（幫我加上換行）
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                .foregroundColor(.gray)
                            HStack{
                                NavigationLink{
                                    PostDetailView(category: "12",documentID:"123",isMyDisplayView: false)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 80, height: 20)
                                        HStack{
                                            Text("前往答題")
                                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                                                .foregroundColor(.white)
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 10))
                                                .foregroundColor(.white)
                                                .padding(.leading, -4)
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 15)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    }
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.top, 2)
                    VStack{
                        HStack{
                            Text("其他服務")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.top, 10)
                        NavigationLink {
                            LazyView(ErrorView())
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
                                
                                fetchUserDetails()
                                print("(ProfileView)Auth UID: \(authUid ?? "nil")")
                                print("(ProfileView)User Name: \(userName ?? "nil")")
                                print("(ProfileView)Registration Days: \(registrationDays)")
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
            fetchUserDetails()
        }
        .onDisappear() {
            likesCount = 0
            peopleHelped = 0
            followers = 0
            following =  0
            exp = 0
        }
    }
    
    private func fetchUserDetails() {
        let db = Firestore.firestore()
        guard let userUid = keychain.get("authUid") else { return }

        db.collection("users").document(userUid).getDocument { document, error in
            if let error = error {
                print("獲取使用者資料失敗: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                likesCount = data?["hearts"] as? Int ?? 0
                peopleHelped = data?["helps"] as? Int ?? 0
                followers = data?["followers"] as? Int ?? 0
                following = data?["following"] as? Int ?? 0
                exp = data?["exp"] as? Int ?? 0
            } else {
                print("(ProfileView)文件不存在")
            }
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
        let startOfDay = calendar.startOfDay(for: registDate)
        
        let components = calendar.dateComponents([.day], from: startOfDay, to: Date())
        
        return components.day ?? 0
    }
}

#Preview {
    ProfileView(selectedTab: .constant(.profile))
        .environmentObject(NavigationCoordinator())
}
