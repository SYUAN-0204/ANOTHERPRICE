//
//  temp5.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI

struct temp5: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var 簽名: String = ""
    
    var body: some View {
        VStack{
            HStack {
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .frame(width: 80)
                Spacer()
                Text("個性簽名")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                    .fontWeight(.semibold)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("儲存")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.gray)
                            .frame(height: 36)
                    }
                    .padding(.trailing, 10)
                }
                .frame(width: 80)
            }
            .frame(height: 36)
            .background(Color.white)
                    TextEditor(text: $簽名)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .frame(height: 94)
                        .scrollContentBackground(.hidden)
                        .onChange(of: 簽名) {
                                簽名 = 簽名.replacingOccurrences(of: "\n", with: "")
                                if 簽名.count > 70 {
                                    簽名 = String(簽名.prefix(70))
                                }
                        }
                        .overlay(
                            Group {
                                if 簽名.isEmpty {
                                    VStack{
                                        HStack{
                                            Text("路過的旅人並未在此留下痕跡")
                                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                        .padding(.leading, 5)
                                        .padding(.top, 8)
                                        Spacer()
                                    }
                                }
                            }
                        )
                .padding(.horizontal, 10)
            Rectangle()
                .fill(ColorConstants.systemMainColor)
                .frame(height: 1.5)
                .padding(.top, -7)
                .padding(.horizontal, 15)
            HStack{
                Spacer()
                Text("\(簽名.count)/70")
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    temp5()
}
