//
//  temp9.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI

struct temp9: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    @State var userAvatar: UIImage = UIImage(named: "Advertise") ?? UIImage()
    @State private var response: String = ""
    @State private var 展開回覆: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                Spacer()
                Text(name)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .alert("提示", isPresented: $showAlert) {
                    Button("關注用戶") {
                    }
                    Button("檢舉用戶", role: .destructive) {
                    }
                    Button("取消", role: .cancel) {
                        showAlert = false
                    }
                } message: {
                    Text("用戶 用戶名稱 的聊天")
                }
            }
            .frame(height: 30)
            .background(Color.white)
            ScrollView {
                Text("2025-04-23")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                    .padding(.top, 10)
                HStack(alignment: .top){
                    Image(uiImage: userAvatar)
                        .resizable()
                        .scaledToFill() // 確保填滿圓形
                        .frame(width: 40, height: 40) // 限制大小
                        .background(Color(.systemGray6))
                        .clipShape(Circle()) // 剪裁為圓形
                        Text("訊息內容\n\n內容")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemDarkColor)
                            .padding(10)
                            .background {
                                ZStack(alignment: .topLeading){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 20)
                                }
                            }
                    .padding(.trailing, 10)
                    Spacer()
                }
                .padding(.bottom, 16)
                HStack(alignment: .top){
                    Spacer()
                        Text("訊息內容訊息內容訊息內容訊息內容訊息內容訊息內容訊息內容訊息內容訊息內容\n\n內容")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemDarkColor)
                            .padding(10)
                            .background {
                                ZStack(alignment: .topTrailing){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: -2, y: 2)
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 20)
                                }
                            }
                    .padding(.leading, 10)
                        Image(uiImage: userAvatar)
                            .resizable()
                            .scaledToFill() // 確保填滿圓形
                            .frame(width: 40, height: 40) // 限制大小
                            .background(Color(.systemGray6))
                            .clipShape(Circle()) // 剪裁為圓形
                }
            }
            .padding(.horizontal, 15)
            .background(Color.gray.opacity(0.1))
            HStack{
                HStack{
                    TextField("睡著了也等不到你的訊息" ,text: $response)
                        .autocapitalization(.none)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                        .foregroundColor(ColorConstants.systemSubColor)
                        .tracking(1)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 3)
                        .frame(height: 28)
                    Button{
                        展開回覆 = true
                    } label: {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                            .padding(.trailing, 5)
                    }
                    .sheet(isPresented: $展開回覆) {
                        temp4(input: $response, hint: "睡著了也等不到你的訊息", button: "傳送")
                            .presentationDetents([.fraction(0.96)])
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                }
                Button{
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(ColorConstants.systemMainColor.opacity(response.isEmpty ? 0.7 : 1.0))
                        Text("傳送")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 60, height: 28)
            }
            .padding(.horizontal, 15)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp9(name: "name")
}
