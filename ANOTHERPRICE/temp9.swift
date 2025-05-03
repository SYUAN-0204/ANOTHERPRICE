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
                UITextMessageDate(date: "0225-04-21")
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageRight(userAvatar: userAvatar, content: "對話內容對話內容對話內容對話內容對話內容對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UITextMessageDate(date: "0225-04-21")
                UIComplexMessageRight(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
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
