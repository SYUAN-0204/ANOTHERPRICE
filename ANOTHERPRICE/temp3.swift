//
//  temp3.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI

struct temp3: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var 匿名 = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State private var tags = "#標籤 #不同標籤"
    @State private var title: String = "標題"
    @State private var like: Bool = false
    @State private var star: Bool = false
    @State private var heart: Int = 54
    @State private var message: Int = 43
    @State private var author: String = "誠實精靈"
    @State private var code: String = "/*edwefwec8*/"
    @State private var http: String = "https://www.anotherprice.com"
    @State private var 排序方式: Bool = false
    @State private var input: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                HStack{
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 120)
                Spacer()
                Text("問題回答")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                }
                .padding(.trailing, 10)
                .frame(width: 120)
            }
            .frame(height: 36)
            HStack {
                NavigationLink{
                    tempView()
                } label: {
                        Image(uiImage: userAvatar)
                            .resizable()
                            .scaledToFill() // 確保填滿圓形
                            .frame(width: 40, height: 40) // 限制大小
                            .background(Color(.systemGray6))
                            .clipShape(Circle()) // 剪裁為圓形
                            .overlay(
                                Circle().stroke(ColorConstants.systemMainColor, lineWidth: 1)
                            )
                        Text(匿名 ? "匿名精靈":"用戶名稱")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                            .foregroundColor(ColorConstants.systemSubColor)
                }
                .disabled(匿名)
                if !匿名 {
                    UITextLevel(totalExp: 3564)
                    Spacer()
                    Button{
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(ColorConstants.systemMainColor, lineWidth: 1)
                                .frame(width: 66, height: 24)
                            HStack{
                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                    .foregroundColor(ColorConstants.systemMainColor)
                                    .padding(.trailing, -7)
                                Text("關注")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                    .foregroundColor(ColorConstants.systemMainColor)
                            }
                        }
                    }
                    .disabled(true)
                }
            }
            .padding(.horizontal, 15)
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 10)
            ScrollView{
                VStack(alignment: .leading){
                    HStack{
                        Text("title")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .foregroundColor(ColorConstants.systemDarkColor)
                        Spacer()
                        Button{
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 24, alignment: .trailing)
                        }
                    }
                    HStack{
                            Text("科技")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .lineLimit(1)
                                .padding(.horizontal, 3)
                                .background(ColorConstants.systemMainColor.opacity(0.2))
                                .cornerRadius(3)
                        Text("Deadline : 2025-05-23")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("-")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text("Point : 34")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.top, -7)
                    Text("description")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                        .padding(.top, -3)
                    let tagString = tags
                        .components(separatedBy: " ")
                        .filter { !$0.isEmpty && $0.starts(with: "#") }
                        .prefix(5)
                        .joined(separator: " ")
                    Text(tagString)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemMainColor)
                        .padding(.top, -3)
                        .padding(.top, 20)
                    HStack{
                        Button{
                            like.toggle()
                        } label: {
                            Image(systemName: like ? "heart.fill":"heart")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Text("\(heart)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Button{
                            star.toggle()
                        } label: {
                            Image(systemName: star ? "star.fill":"star")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Text("\(message)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Image(systemName: "ellipsis.message")
                            .font(.system(size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Text("\(message)")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemMainColor)
                        ShareLink(item: "✨「\(author)發布了一則問答《\(title)》，快來看看吧！」\n打開 APP 搜尋口令：/*\(code)*/🪄\n🔗  \(http)") {
                            Image(systemName: "arrowshape.turn.up.right")
                                .font(.system(size: 14))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                        Spacer()
                    }
                    .padding(.top, 5)
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                HStack{
                    Text("回答")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                    Spacer()
                    Button{
                        排序方式.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                        Text(排序方式 ? "按時間":"按熱度")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                    }
                }
                .padding(.horizontal, 5)
                Spacer()
            }
            .padding(.horizontal, 10)
            HStack{
                HStack{
                    TextField("" ,text: $input)
                        .autocapitalization(.none)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemSubColor)
                        .tracking(1)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 3)
                        .frame(height: 28)
                    Button{
                        
                    } label: {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                            .padding(.trailing, 5)
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
                            .fill(ColorConstants.systemMainColor.opacity(input.isEmpty ? 0.7 : 1.0))
                        Text("送出")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(.white)
                    }
                }
                .frame(width: 60, height: 28)
            }
            .padding(.horizontal, 15)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp3()
}
