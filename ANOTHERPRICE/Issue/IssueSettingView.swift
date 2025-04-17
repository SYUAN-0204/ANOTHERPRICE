//
//  IssueSettingView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/13.
//

import SwiftUI

struct IssueSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isPublish: Bool = false
    @State private var inputText:String = ""
    @State private var selectedCategory:String = ""
    @State private var categoryList = ["生活", "學術", "科技", "健康", "理財", "情感", "娛樂", "其他"] //可以考慮從firebase抓資料，方便類別擴充
    @State private var tags:String = ""
    @State private var reward:String = ""
    @State private var balance:Int = 34
    @State private var selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
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
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 80)
                Spacer()
                Text("預覽")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button() {
                        
                    } label: {
                        Text("發布")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 30)
                    }
                    .background(ColorConstants.systemMainColor.opacity(isPublish ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(isPublish)
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            VStack{
                HStack{
                    UITextIssueSettingTitle(title: "類別")
                    Menu {
                        Picker("Options", selection: $selectedCategory) {
                            ForEach(categoryList, id: \.self) { order in
                                Text(order)
                            }
                        }
                    } label: {
                        Text(selectedCategory.isEmpty ? "點擊選擇" : selectedCategory)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(selectedCategory.isEmpty ? .gray.opacity(0.5): ColorConstants.systemDarkColor.opacity(0.9))
                        Spacer()
                    }
                }
                .frame(height: 36)
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "標籤")
                    TextField("至多五個（選填）", text: $tags)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .frame(height: 36)
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "懸賞點數")
                    TextField("（選填）", text: $reward)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .keyboardType(.numberPad)
                        .frame(height: 36)
                    Text("點數：\(balance)")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.7))
                        .frame(height: 36)
                        .padding(.trailing, 10)
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
                HStack{
                    UITextIssueSettingTitle(title: "截止時間")
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .labelsHidden()
                    Spacer()
                }
                .padding(.horizontal, 5)
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.top, -5)
            }
            .padding(.horizontal, 10)
            ScrollView{
                Text("還沒想好預覽顯示排版")
            }
            .padding(.horizontal, 15)
            .padding(.top, 7)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    IssueSettingView()
}
