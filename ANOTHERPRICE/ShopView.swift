//
//  temp12.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

struct ShopView: View {
    @State private var showPointAlert = false
    
    struct BubbleItem: Identifiable {
        let id = UUID()
        let name: String
        let bubbleColor: Color
        let textColor: Color
        var isPurchased: Bool
        var isApplied: Bool
        let opacity: Double
    }
    
    @State private var bubbleItems: [BubbleItem] = [
        BubbleItem(name: "經典黑白", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"), isPurchased: true, isApplied: true, opacity: 0.1),
        BubbleItem(name: "霜枝染雪", bubbleColor: Color(hex: "#86908A"), textColor: Color(hex: "#F5F2E9"), isPurchased: false, isApplied: false, opacity: 0.4),
        BubbleItem(name: "朝露初凝", bubbleColor: Color(hex: "#F5F2E9"), textColor: Color(hex: "#86908A"), isPurchased: false, isApplied: false, opacity: 0.1),
        BubbleItem(name: "塵翠如煙", bubbleColor: Color(hex: "#6B8770"), textColor: Color(hex: "#EDEDED"), isPurchased: false, isApplied: false, opacity: 0.4),
        BubbleItem(name: "落墨浮青", bubbleColor: Color(hex: "#EDEDED"), textColor: Color(hex: "#6B8770"), isPurchased: false, isApplied: false, opacity: 0.1),
        BubbleItem(name: "月華紫夢", bubbleColor: Color(hex: "#7C739F"), textColor: Color(hex: "#E5DFD5"), isPurchased: false, isApplied: false, opacity: 0.4),
        BubbleItem(name: "落日紫歌", bubbleColor: Color(hex: "#E5DFD5"), textColor: Color(hex: "#7C739F"), isPurchased: false, isApplied: false, opacity: 0.1),
        BubbleItem(name: "空庭春盡", bubbleColor: Color(hex: "#425066"), textColor: Color(hex: "#E4C6D0"), isPurchased: false, isApplied: false, opacity: 0.4),
        BubbleItem(name: "春曉微寒", bubbleColor: Color(hex: "#E4C6D0"), textColor: Color(hex: "#425066"), isPurchased: false, isApplied: false, opacity: 0.1),
        BubbleItem(name: "澄海無聲", bubbleColor: Color(hex: "#28517F"), textColor: Color(hex: "#C7E1FA"), isPurchased: false, isApplied: false, opacity: 0.4),
        BubbleItem(name: "天水長流", bubbleColor: Color(hex: "#C7E1FA"), textColor: Color(hex: "#28517F"), isPurchased: false, isApplied: false, opacity: 0.1)
    ]
    
    var body: some View {
        VStack(alignment: .trailing){
            UINavigationBar(title: "點數商城")
            Text("點數餘額：100")
                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                .foregroundColor(ColorConstants.systemDarkColor.opacity(0.8))
                .padding(.horizontal, 20)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 15) {
                    ForEach($bubbleItems.indices, id: \.self) { index in
                        UIBubbleTextShop(
                            name: bubbleItems[index].name,
                            bubbleColor: bubbleItems[index].bubbleColor,
                            textColor: bubbleItems[index].textColor,
                            opacity: bubbleItems[index].opacity,
                            isPurchased: $bubbleItems[index].isPurchased,
                            isApplied: $bubbleItems[index].isApplied,
                            onApply: {
                                for i in bubbleItems.indices {
                                    bubbleItems[i].isApplied = false
                                }
                                bubbleItems[index].isApplied = true
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("點數不足", isPresented: $showPointAlert) {
            Button("確認") { }
        } message: {
            Text("購買需要 300 點，請前往任務中心獲得更多點數。")
        }
    }
    
    private func updateAccount() async{
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userUid)
        
        do {
            let snapshot = try await userRef.getDocument()
            if let data = snapshot.data(),
               let currentPoints = data["point"] as? Int,
               currentPoints >= 100 {
                
                try await userRef.updateData([
                    "point": currentPoints - 300
                ])
            } else {
                showPointAlert = true
                print("(userNameEditView)點數不足")            }
        } catch {
            print("(userNameEditView)更新暱稱失敗：\(error.localizedDescription)")
        }
    }
}

#Preview {
    ShopView()
}
