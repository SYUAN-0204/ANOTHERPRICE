//
//  temp10.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct MessageSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var 我的提問:String = "on"
    @State private var 我的獲讚:String = "on"
    @State private var 我的關注:String = "on"
    @State private var 接收陌生訊息:String = "開放"
    
    @State private var 訊息設定 = ["開放", "僅限粉絲", "關閉"]
    @State private var 通知設定 = ["on", "off"]
    
    var body: some View {
        VStack{
            UINavigationBar(title: "訊息設定")
            VStack(spacing: 0){
                UIMenuSetting(list: 通知設定, title: "我的提問", selected: $我的提問)
                UIRectangleLine(opacity: 0.1)
                UIMenuSetting(list: 通知設定, title: "我的獲讚", selected: $我的獲讚)
                UIRectangleLine(opacity: 0.1)
                UIMenuSetting(list: 通知設定, title: "我的關注", selected: $我的關注)
                UIRectangleLine(opacity: 0.1)
                UIMenuSetting(list: 訊息設定, title: "陌生訊息", selected: $接收陌生訊息)
            }
            .background(Color.white)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MessageSettingView()
}
