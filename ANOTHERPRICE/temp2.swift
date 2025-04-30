//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/30.
//

import SwiftUI

struct temp2: View {
    @Environment(\.dismiss) var dismiss
    @State var 關注狀態: Bool = false
    @State var userAvatar: UIImage = UIImage(named: "Logo_122D3E") ?? UIImage()
    
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
                Text("更多帳號")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .opacity(0)
                }
                .padding(.trailing, 10)
            }
            ScrollView(showsIndicators: false){
                ForEach(0..<10) { i in
                    UIComplexUser(follow: $關注狀態, userAvatar: userAvatar, fans: 43)
                    .padding(.horizontal, 5)
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 1)
                }
            }
            .padding(.horizontal, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp2()
}
