//
//  temp4.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/21.
//

import SwiftUI

struct InputView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var input: String
    let hint: String
    let button: String
    let action: () -> Void
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                        .padding(.trailing, 5)
                }
            }
            .padding(.top, 10)
            TextEditor(text: $input)
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                .frame(minHeight: 200)
                .overlay(
                    Group {
                        if input.isEmpty {
                            VStack{
                                HStack{
                                    Text(hint)
                                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
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
            HStack{
                Spacer()
                Button{
                    dismiss()
                    action()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(ColorConstants.systemMainColor.opacity(input.isEmpty ? 0.7 : 1.0))
                        Text(button)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .disabled(input.isEmpty)
                .frame(width: 60, height: 28)
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    InputView(input: .constant(""), hint: "wer", button: "nm", action: {})
}
