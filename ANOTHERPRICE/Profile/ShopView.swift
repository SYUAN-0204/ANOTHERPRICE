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
    @State private var userPoints: Int = 0
    @State private var successThemeName = ""
    @State private var showPurchaseSuccess = false
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
        BubbleItem(name: "經典黑白", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"), isPurchased: true, isApplied: false, opacity: 0.1),
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
            Text("點數餘額：\(userPoints)")
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
                                if !bubbleItems[index].isPurchased {
                                       // 購買流程
                                       Task {
                                           let success = await purchaseTheme(bubbleItems[index])
                                           if success {
                                               bubbleItems[index].isPurchased = true
                                               showPurchaseSuccess = true
                                               successThemeName = bubbleItems[index].name
                                           } else {
                                               showPointAlert = true
                                           }
                                       }
                                   } else {
                                       // 套用流程
                                       for i in bubbleItems.indices {
                                           bubbleItems[i].isApplied = false
                                       }
                                       bubbleItems[index].isApplied = true

                                       Task {
                                           await applyTheme(name: bubbleItems[index].name)
                                       }
                                   }
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .task {
            await loadUserThemeData()
        }
        .navigationBarBackButtonHidden(true)
        .alert("點數不足", isPresented: $showPointAlert) {
            Button("確認") { }
        } message: {
            Text("購買需要 300 點，請前往任務中心獲得更多點數")
        }
        .alert("購買成功", isPresented: $showPurchaseSuccess) {
            Button("確認") { }
        } message: {
            Text("成功購買氣泡主題 \(successThemeName)")
        }
    }
    
    private func loadUserThemeData() async {
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            print("無法取得使用者 UID")
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userUid)

        do {
            let snapshot = try await userRef.getDocument()
            if let data = snapshot.data() {
                userPoints = data["point"] as? Int ?? 0

                if let appliedName = data["appliedThemeName"] as? String {
                    for i in bubbleItems.indices {
                        if bubbleItems[i].name == appliedName {
                            bubbleItems[i].isApplied = true
                        }
                    }
                }
                if let purchasedThemes = data["purchasedThemes"] as? [String] {
                    for i in bubbleItems.indices {
                        if purchasedThemes.contains(bubbleItems[i].name) {
                            bubbleItems[i].isPurchased = true
                        }
                    }
                }
            }
        } catch {
            print("讀取使用者主題資料失敗: \(error.localizedDescription)")
        }
    }

    
    private func purchaseTheme(_ item: BubbleItem) async -> Bool {
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            return false
        }

        let userRef = Firestore.firestore().collection("users").document(userUid)

        do {
            let snapshot = try await userRef.getDocument()
            if let data = snapshot.data(),
               let currentPoints = data["point"] as? Int {

                if currentPoints < 300 {
                    return false
                }

                try await userRef.updateData([
                    "point": currentPoints - 300,
                    "purchasedThemes": FieldValue.arrayUnion([item.name])
                ])
                successThemeName = item.name
                showPurchaseSuccess = true
                userPoints -= 300
                print("主題購買成功：\(item.name)")
                return true
            }
        } catch {
            print("購買失敗：\(error.localizedDescription)")
        }

        return false
    }

    private func applyTheme(name: String) async {
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            print("無法取得使用者 UID")
            return
        }

        let userRef = Firestore.firestore().collection("users").document(userUid)

        do {
            try await userRef.updateData([
                "appliedThemeName": name
            ])
            print("主題套用成功：\(name)")
        } catch {
            print("套用主題失敗：\(error.localizedDescription)")
        }
    }
}

#Preview {
    ShopView()
}
