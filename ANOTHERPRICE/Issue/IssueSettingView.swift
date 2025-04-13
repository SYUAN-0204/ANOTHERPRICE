//
//  IssueSettingView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/13.
//

import SwiftUI

struct IssueSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var 可以發佈: Bool = false
    @State private var 輸入文字:String = ""
    @State private var 選擇項目:String = ""
    @State private var 選項列表 = ["生活", "學術", "科技", "健康", "理財", "情感", "娛樂", "其他"] //可以考慮從firebase抓資料，方便類別擴充
    @State private var 標籤:String = ""
    @State private var 懸賞:String = ""
    @State private var 餘額:Int = 34
    @State private var 選擇日期 = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
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
                    .background(ColorConstants.systemMainColor.opacity(可以發佈 ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(可以發佈)
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            VStack{
                HStack{
                    UITextIssueSettingTitle(title: "類別")
                    Menu {
                        Picker("Options", selection: $選擇項目) {
                            ForEach(選項列表, id: \.self) { order in
                                Text(order)
                            }
                        }
                    } label: {
                        Text(選擇項目.isEmpty ? "點擊選擇" : 選擇項目)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                            .foregroundColor(選擇項目.isEmpty ? .gray.opacity(0.5): ColorConstants.systemDarkColor.opacity(0.9))
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
                    TextField("至多五個（選填）", text: $標籤)
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
                    TextField("（選填）", text: $懸賞)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.9))
                        .keyboardType(.numberPad)
                        .frame(height: 36)
                    Text("餘額：\(餘額)")
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
                    DatePicker("", selection: $選擇日期, displayedComponents: [.date, .hourAndMinute])
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
                //預覽還沒做，準備真實輸出用同一套介面
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
