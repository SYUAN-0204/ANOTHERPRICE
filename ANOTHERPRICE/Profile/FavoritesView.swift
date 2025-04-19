//
//  temp2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/14.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isMultiSelect: Bool = false
    @State private var isSelected: Bool = false
    @State private var isTrashSelected: Bool = false
    @State private var hasSelection: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    if isMultiSelect {
                        Button() {
                            isMultiSelect = false
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
                Text("我的收藏")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    if isMultiSelect {
                        Button() {
                            
                        } label: {
                            Text("全選")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.systemMainColor)
                        }
                    }
                    else {
                        Button {
                            isMultiSelect = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18))
                                .foregroundColor(ColorConstants.systemDarkColor)
                                .padding(.trailing, 5)
                        }
                        .disabled(isTrashSelected)
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
                        UIComplexUploadArticle(isSelected:.constant(false),selecte: $isMultiSelect, trashcanState: $isTrashSelected, title: "標題", date: "Last Upload : 2025-04-03 ; Last Comment : 2025-04-03", content: "總之是內容\n總之是內容\n總之是內容\n", heart: 34, message: 45, author: "誠實精靈", code: "TS4F64WX23DW", http: "http://anotherprice.com/TS4F64WX23DW")
                    }
                    .buttonStyle(PlainButtonStyle())
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                }
            }
            Spacer()
            if isMultiSelect {
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    Button() {
                        
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(ColorConstants.tomatoRed.opacity(hasSelection ? 1.0 : 0.7))
                            Text("刪除")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                .foregroundColor(ColorConstants.tomatoRed.opacity(hasSelection ? 1.0 : 0.7))
                        }
                    }
                    .frame(height: 28)
                    .disabled(!hasSelection)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FavoritesView()
}
