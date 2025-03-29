//
//  TempView2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/26.
//

import SwiftUI

struct IssueEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isDraft:Bool
    @State var showTip:Bool = false
    @State var title:String = ""
    @State var content:String = ""
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    Button {
                        if title.isEmpty && content.isEmpty {
                            dismiss()
                        }
                        else{
                            showTip = true
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
                    .background(ColorConstants.systemMainColor.opacity(title.isEmpty ? 0.7 : 1.0))
                    .cornerRadius(5)
                    .disabled(title.isEmpty)
                }
                .padding(.trailing, 10)
                .frame(width: 80)
            }
            .frame(height: 36)
            ScrollView{
                TextEditor(text: $title)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .onChange(of: title) {
                        if title.count > 50 {
                            title = String(title.prefix(50))
                        }
                    }
                    .overlay(
                        Group {
                            if title.isEmpty {
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
                    Text("\(title.count)/50")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
                Rectangle()
                    .fill(.gray)
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                TextEditor(text: $content)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .overlay(
                        Group {
                            if content.isEmpty {
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
        .alert("草稿", isPresented: $showTip) {
            if isDraft {
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
            Text(isDraft ? "你要如何處理這篇草稿？" : "你要如何處理新建的問題？")
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    IssueEditView(isDraft: false)
}
