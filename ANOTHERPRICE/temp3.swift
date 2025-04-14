//
//  temp3.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI

struct temp3: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var 多選: Bool = false
    @State private var 選中: Bool = false
    @State private var 垃圾桶選中: Bool = false
    @State private var 有東西選中: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    if 多選 {
                        Button() {
                            多選 = false
                        } label: {
                            Text("取消")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    else {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(width: 80)
                Spacer()
                Text("我的提問")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    if 多選 {
                        Button() {
                            
                        } label: {
                            Text("全選")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    else {
                        Button {
                            多選 = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .padding(.trailing, 5)
                        }
                        .disabled(垃圾桶選中)
                    }
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            ScrollView{
                ForEach(0..<10){ i in
                    NavigationLink {
                        tempView()
                    } label: {
                        UIComplexUploadArticle(selecte: $多選, trashcanState: $垃圾桶選中, title: "標題", date: "Last Upload : 2025-04-03 ; Last Comment : 2025-04-03", content: "總之是內容\n總之是內容\n總之是內容\n", heart: 34, message: 45, author: "誠實精靈", code: "TS4F64WX23DW", http: "http://anotherprice.com/TS4F64WX23DW")
                    }
                    .buttonStyle(PlainButtonStyle())
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                }
            }
            Spacer()
            if 多選 {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    Button() {
                        
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(ColorConstants.tomatoRed.opacity(有東西選中 ? 1.0 : 0.7))
                            Text("刪除")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.tomatoRed.opacity(有東西選中 ? 1.0 : 0.7))
                        }
                    }
                    .frame(height: 28)
                    .disabled(!有東西選中)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp3()
}
