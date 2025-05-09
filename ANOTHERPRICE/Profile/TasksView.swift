//
//  temp4.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/15.
//

import SwiftUI

struct TasksView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var totalExperience: Int = 24341
    @State private var isCompleted: Bool = false
    
    @Binding var selectedTab: TabIdentifier
    
    var body: some View {
        VStack{
            UINavigationBar(title: "任務中心")
            HStack{
                UIComplexLevelBar(totalExp: totalExperience)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                Spacer()
                Text("今日獲得：65")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 14))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                    .padding(.trailing, 15)
                    .padding(.top, 1)
            }
            .frame(height: 50)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 15)
            ScrollView{
                VStack(alignment: .leading){
                    HStack{
                        Text("每日任務")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(ColorConstants.systemDarkColor)
                            .padding(.leading, 10)
                        Spacer()
                        Text("任務獲得（10/50）")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                            .padding(.trailing, 5)
                    }
                    .padding(.top, 10)
                    Spacer()
                    UIComplexTask(title: "指定答題", description: "回答指定題目，獲得任務獎勵 15 點", complish: false, destination: PostDetailView(category: "12",documentID:"123",isMyDisplayView: false), tabIdentifier: TabIdentifier.profile, isQuestion: true, selectedTab: $selectedTab)
                    UIRectangleLine(opacity: 0.1)
                        .padding(.horizontal, 3)
                    UIComplexTask(title: "任意答題", description: "回答任意題目，獲得任務獎勵 10 點", complish: false, destination: PostDetailView(category: "12",documentID:"123",isMyDisplayView: false), tabIdentifier: TabIdentifier.home, isQuestion: false, selectedTab: $selectedTab)
                    UIRectangleLine(opacity: 0.1)
                        .padding(.horizontal, 3)
                    UIComplexTask(title: "發布問答", description: "發布任意問答，獲得任務獎勵 15 點", complish: false, destination: IssueView(), tabIdentifier: TabIdentifier.issue, isQuestion: false, selectedTab: $selectedTab)
                    UIRectangleLine(opacity: 0.1)
                        .padding(.horizontal, 3)
                    UIComplexTask(title: "分享問答", description: "分享任意問答，獲得任務獎勵 5 點", complish: isCompleted, destination: HomeView(), tabIdentifier: TabIdentifier.home, isQuestion: false, selectedTab: $selectedTab)
                    UIRectangleLine(opacity: 0.1)
                        .padding(.horizontal, 3)
                    UIComplexTask(title: "消耗 30 點", description: "消耗點數 30 點，獲得任務獎勵 10 點", complish: isCompleted, destination: LazyView(ShopView()), tabIdentifier: TabIdentifier.profile, isQuestion: true, selectedTab: $selectedTab)
                    Spacer()
                }
                .frame(height: 285)
                .background(.white)
                .cornerRadius(10)
                .padding(.horizontal, 15)
                Spacer()
            }
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TasksView(selectedTab: .constant(TabIdentifier.profile))
}
