//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI

struct temp2: View {
    @State private var categoryList = ["生活", "學術", "科技", "健康", "理財", "情感", "娛樂", "其他"]
    @State private var selectedCategory: String = "生活"
    @State private var title: String = "123"
    @State private var 按讚: Bool = false
    @State private var heart: Int = 54
    @State private var message: Int = 43
    @State private var author: String = "誠實精靈"
    @State private var code: String = "/*edwefwec8*/"
    @State private var http: String = "https://www.anotherprice.com"
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(categoryList, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(selectedCategory == category ?
                                          ColorConstants.systemMainColor.opacity(0.3) :
                                            Color.clear)
                                    .frame(width: 60, height: 28)
                                Text(category)
                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                    .foregroundColor(ColorConstants.systemSubColor)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            ScrollView{
                ForEach(0..<5) { _ in
                    UIComplexIssueCard(destination: temp3(), title: "標題", date: "2025-09-04", common: "2025-04-23", coin: 344, content: "好東西", like: true, heart: heart, message: message, author: author, code: code, http: http)
                }
            }
        }
    }
}

#Preview {
    temp2()
}
