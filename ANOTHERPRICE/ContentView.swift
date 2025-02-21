//
//  ContentView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/2/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView { // 必須加上 NavigationView
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                    .padding()
                
                // 跳轉到登入頁面的按鈕
                NavigationLink(destination: LoginView()) {
                    Text("Go to Login")
                        .font(.title)
                        .frame(width: 250, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
