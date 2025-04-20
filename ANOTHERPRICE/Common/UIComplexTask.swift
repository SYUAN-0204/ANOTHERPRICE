//
//  UIComplexTask.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/15.
//

import SwiftUI

struct UIComplexTask<Destination: View>: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let description: String
    let complish: Bool
    let destination: Destination
    let tabIdentifier: TabIdentifier
    let isQuestion: Bool
    
    @Binding var selectedTab: TabIdentifier
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                    .foregroundColor(ColorConstants.systemDarkColor)
                Text(description)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 13))
                    .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
            }
            Spacer()
            if complish {
                Image(systemName: "checkmark")
                    .font(.system(size: 14))
                    .foregroundColor(ColorConstants.emeraldGreen)
                    .padding(.trailing, 5)
            }
            else if !isQuestion {
                Button {
                    selectedTab = tabIdentifier
                    dismiss()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 5)
            }
            else {
                NavigationLink {
                    destination
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 5)
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    UIComplexTask(title: "title", description: "description", complish: true, destination: Text("預覽畫面"), tabIdentifier: TabIdentifier.profile, isQuestion: true, selectedTab: .constant(TabIdentifier.profile))
}
