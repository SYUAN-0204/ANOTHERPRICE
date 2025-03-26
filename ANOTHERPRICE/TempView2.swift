//
//  TempView2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/26.
//

import SwiftUI

struct TempView2: View {
    @Environment(\.dismiss) var dismiss
    
    @State var 是不是草稿:Bool
    @State var 顯示提示:Bool = false
    @State var 標題:String = ""
    @State var 內容:String = ""
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    Button {
                        if 標題.isEmpty && 內容.isEmpty {
                            dismiss()
                        }
                        else{
                            顯示提示 = true
                        }
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
                Text("提問")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("發布")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 30)
                    }
                    .background(ColorConstants.systemMainColor.opacity(標題.isEmpty ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(標題.isEmpty)
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            ScrollView{
                TextEditor(text: $標題)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .onChange(of: 標題) {
                        if 標題.count > 50 {
                            標題 = String(標題.prefix(50))
                        }
                    }
                    .overlay(
                        Group {
                            if 標題.isEmpty {
                                HStack{
                                    Text("標題")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                            }
                        }
                    )
                    .padding(10)
                HStack{
                    Spacer()
                    Text("\(標題.count)/50")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                TextEditor(text: $內容)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .overlay(
                        Group {
                            if 內容.isEmpty {
                                HStack{
                                    Text("問題描述")
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.leading, 5)
                            }
                        }
                    )
                    .padding(10)
                Spacer()
            }
            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 36)
                Text("工具列，還沒做")
            }
        }
        .alert("草稿", isPresented: $顯示提示) {
            if 是不是草稿 {
                Button("刪除草稿", role: .destructive) {
                    print("刪除草稿")
                    dismiss()
                }
                Button("儲存變更") {
                    print("儲存變更")
                    //處理草稿儲存
                }
            } else {
                Button("刪除草稿", role: .destructive) {
                    print("刪除草稿")
                    dismiss()
                }
                Button("儲存草稿") {
                    print("儲存草稿")
                    //處理草稿儲存
                }
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text(是不是草稿 ? "你要如何處理這篇草稿？" : "你要如何處理新建的問題？")
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TempView2(是不是草稿: false)
}
