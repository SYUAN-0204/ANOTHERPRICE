//
//  TempView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/17.
//

import SwiftUI

struct IssueView: View {
    var body: some View {
        VStack{
            NavigationLink{
                IssueEditView(isDraft: false)
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .stroke(ColorConstants.systemMainColor, style: StrokeStyle(lineWidth: 1))
                    HStack{
                        Image(systemName: "pencil.line")
                            .font(.system(size: 20))
                            .foregroundColor(ColorConstants.systemMainColor)
                        Text("新建問題")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 80)
            }
            .padding(.top, 20)
            .padding(.horizontal, 8)
            HStack{
                Text("草稿記錄")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            ScrollView{
                ForEach(0..<10){_ in
                    NavigationLink{
                        IssueEditView(isDraft: true)
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)//gray.opacity(0.1))
                                .frame(height: 80)
                                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                            VStack(alignment: .leading){
                                Text("組裝6000元的電腦，要多少預算？")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    .foregroundColor(ColorConstants.systemDarkColor)
                                    .lineLimit(1)
                                Text("如題，我是一名即將升大一的高中生，我想購買一台桌機")
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                    .foregroundColor(.gray)
                                    .padding(.top, -10)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, 10)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    IssueView()
}
