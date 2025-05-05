//
//  temp8.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI

struct temp8: View {
    @Environment(\.dismiss) var dismiss
    
    let name: String
    @State private var 獎勵是否領取: Bool = false
    @State private var 提問是否存在: Bool = true
    
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
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .opacity(0)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 30)
            .background(Color.white)
            ScrollView{
                UITextMessageDate(date: "0225-04-21")
                ForEach(0..<5, id: \.self){_ in
                    UIComplexReward(point: 50, title: "ef", content: "rgtr", issueExist: 提問是否存在, rewardExist: $獎勵是否領取)
                }
            }
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp8(name: "qwe")
}
