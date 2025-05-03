//
//  temp5.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/30.
//

import SwiftUI

struct temp5: View {
    @Environment(\.dismiss) var dismiss
    @State var 關注狀態: Bool = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    
    var body: some View {
        VStack{
            UINavigationBar(title: "粉絲列表")
            ScrollView(showsIndicators: false){
                ForEach(0..<10) { i in
                    UIComplexUser(follow: $關注狀態, userAvatar: userAvatar, fans: 43)
                    .padding(.horizontal, 5)
                    UIRectangleLine(opacity: 0.1)
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp5()
}
