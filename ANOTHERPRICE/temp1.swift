//
//  temp1.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/29.
//

import SwiftUI

struct temp1: View {
    @State var 搜尋: String = ""
    @State var 關鍵字搜尋結果: Bool = false
    @State var 口令搜尋結果: Bool = false
    @State var 展開更多: Bool = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    @State var 展開關注列表: Bool = false
    @State var 是否存在口令: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(ColorConstants.systemMainColor)
                        TextField("", text: $搜尋)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        if !搜尋.isEmpty {
                            Button(){
                                搜尋 = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.4))
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                Button(){
                    關鍵字搜尋結果 = true
                    let trimmed = 搜尋.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.hasPrefix("/*") && trimmed.hasSuffix("*/") {
                        口令搜尋結果 = true
                    }
                } label: {
                    Text("搜尋")
                        .foregroundColor(ColorConstants.systemMainColor)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                }
                .disabled(搜尋.isEmpty)
                .padding(.horizontal, 7)
            }
            .frame(height: 32)
            .padding(.horizontal, 15)
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 1)
            if 關鍵字搜尋結果 {
                if 口令搜尋結果 {
                    ScrollView{
                        HStack{
                            Text("口令結果")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        if 是否存在口令 {
                            UIComplexIssueCard(
                                destination: PostDetailView(isMyDisplayView: false),
                                title: "draft.title",
                                date: "draft.deadLine",
                                common: "draft.lastCommentDate",
                                coin: 45,
                                content: "draft.description",
                                like: true,
                                heart: 24,
                                message: 78,
                                author: "誠實精靈",
                                code: "/*edwefwec8*/",
                                http: "https://www.anotherprice.com"
                            )
                            .padding(.vertical, -10)
                            .padding(.horizontal, 5)
                        }
                        else {
                            Text("查無口令 \(搜尋)")
                                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        }
                        HStack{
                            Text("熱門提問")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        ForEach(0..<5){_ in
                            UIComplexIssueCard(
                                destination: PostDetailView(isMyDisplayView: false),
                                title: "draft.title",
                                date: "draft.deadLine",
                                common: "draft.lastCommentDate",
                                coin: 45,
                                content: "draft.description",
                                like: true,
                                heart: 24,
                                message: 78,
                                author: "誠實精靈",
                                code: "/*edwefwec8*/",
                                http: "https://www.anotherprice.com"
                            )
                            .padding(.vertical, -10)
                        }
                        .padding(.horizontal, 5)
                    }
                }
                else {
                    ScrollView(showsIndicators: false){
                        VStack{
                            HStack{
                                Text("相關用戶")
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                Spacer()
                                Button(){
                                    展開關注列表 = true
                                } label: {
                                    Text("查看更多")
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                                }
                                .sheet(isPresented: $展開關注列表) {
                                    tempView()
                                        .presentationDetents([.fraction(0.92)])
                                }
                            }
                            HStack{
                                ForEach(0..<5){_ in
                                    NavigationLink{
                                        DisplayView(isMyDisplayView: false)
                                    } label: {
                                        VStack{
                                            Image(uiImage: userAvatar)
                                                .resizable()
                                                .scaledToFill() // 確保填滿圓形
                                                .frame(width: 50, height: 50) // 限制大小
                                                .background(Color(.systemGray6))
                                                .clipShape(Circle()) // 剪裁為圓形
                                            Text("相關用戶名")
                                                .foregroundColor(ColorConstants.systemDarkColor)
                                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                                                .lineLimit(1)
                                        }
                                        .frame(width: 66)
                                        .padding(.horizontal, 1)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                            HStack{
                                Text("相關提問")
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                Spacer()
                            }
                            .padding(.vertical, 7)
                        }
                        .padding(.horizontal, 15)
                        ForEach(0..<5){_ in
                            UIComplexIssueCard(
                                destination: PostDetailView(isMyDisplayView: false),
                                title: "draft.title",
                                date: "draft.deadLine",
                                common: "draft.lastCommentDate",
                                coin: 45,
                                content: "draft.description",
                                like: true,
                                heart: 24,
                                message: 78,
                                author: "誠實精靈",
                                code: "/*edwefwec8*/",
                                http: "https://www.anotherprice.com"
                            )
                            .padding(.vertical, -10)
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            else {
                ScrollView(showsIndicators: false){
                    VStack{
                        HStack{
                            Text("歷史記錄")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                            Button(){
                                
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                    .font(.system(size: 14))
                                    .frame(width: 28, height: 28)
                            }
                        }
                        //這裡預設五筆資料
                        ForEach(0..<5){_ in
                            HStack{
                                Text("一劍霜寒十四州出處")
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                Spacer()
                                Button(){
                                    
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                                        .font(.system(size: 14))
                                        .frame(width: 28, height: 28)
                                }
                            }
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 1)
                        }
                        HStack{
                            Spacer()
                            Button(){
                                展開更多.toggle()
                            } label: {
                                if 展開更多 {
                                    Text("展開更多")
                                        .foregroundColor(ColorConstants.systemSubColor)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                }
                                else {
                                    Text("收合")
                                        .foregroundColor(ColorConstants.systemSubColor)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                }
                            }
                        }
                        HStack{
                            Text("近期熱門提問")
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                    }
                    .padding(.horizontal, 15)
                    ForEach(0..<5){_ in
                        UIComplexIssueCard(
                            destination: PostDetailView(isMyDisplayView: false),
                            title: "draft.title",
                            date: "draft.deadLine",
                            common: "draft.lastCommentDate",
                            coin: 45,
                            content: "draft.description",
                            like: true,
                            heart: 24,
                            message: 78,
                            author: "誠實精靈",
                            code: "/*edwefwec8*/",
                            http: "https://www.anotherprice.com"
                        )
                        .padding(.vertical, -10)
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
    }
}

#Preview {
    temp1()
}
