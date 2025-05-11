//
//  temp9.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/2.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

struct temp9: View {
    @Environment(\.dismiss) var dismiss
    
    let otherUid: String
    let docID: String
    let name: String
    @State var userAvatar: UIImage = UIImage(named: "Advertise") ?? UIImage()
    @State private var response: String = ""
    @State private var 展開回覆: Bool = false
    @State var showAlert: Bool = false
    @State private var appliedThemeName: String = ""
    @State private var bubbleColorHex: String = "#FFFFFF"
    @State private var textColorHex: String = "#000000"
    
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
        VStack{
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                Spacer()
                Text(name)
                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .alert("提示", isPresented: $showAlert) {
                    Button("關注用戶") {
                    }
                    Button("檢舉用戶", role: .destructive) {
                    }
                    Button("取消", role: .cancel) {
                        showAlert = false
                    }
                } message: {
                    Text("用戶 用戶名稱 的聊天")
                }
            }
            .frame(height: 30)
            .background(Color.white)
            ScrollView {
                UITextMessageDate(date: "0225-04-21")
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageRight(userAvatar: userAvatar, content: "對話內容對話內容對話內容對話內容對話內容對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UITextMessageDate(date: "0225-04-21")
                UIComplexMessageRight(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
                UIComplexMessageLeft(userAvatar: userAvatar, content: "對話內容", bubbleColor: Color(hex: "#FFFFFF"), textColor: Color(hex: "#000000"))
            }
            .padding(.horizontal, 15)
            .background(Color.gray.opacity(0.1))
            HStack{
                HStack{
                    TextField("睡著了也等不到你的訊息" ,text: $response)
                        .autocapitalization(.none)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 17))
                        .foregroundColor(ColorConstants.systemSubColor)
                        .tracking(1)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 3)
                        .frame(height: 28)
                    Button{
                        展開回覆 = true
                    } label: {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                            .font(.system(size: 12))
                            .foregroundColor(ColorConstants.systemDarkColor.opacity(0.6))
                            .padding(.trailing, 5)
                    }
                    .sheet(isPresented: $展開回覆) {
                        InputView(input: $response, hint: "睡著了也等不到你的訊息", button: "傳送", action: {Task {
                            await sendMessage()
                        }})
                        .presentationDetents([.fraction(0.96)])
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(ColorConstants.systemDarkColor, lineWidth: 0.5)
                }
                Button{
                    Task {
                        await sendMessage()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(ColorConstants.systemMainColor.opacity(response.isEmpty ? 0.7 : 1.0))
                        Text("傳送")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 60, height: 28)
            }
            .padding(.horizontal, 15)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await loadUserThemeOnce()
            }
        }
    }
    
    private func loadUserThemeOnce() async {
        let keychain = KeychainSwift()
        guard let userUid = keychain.get("authUid") else {
            print("無法取得使用者 UID")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userUid)
        
        do {
            let snapshot = try await userRef.getDocument()
            if let themeName = snapshot.data()?["appliedThemeName"] as? String {
                appliedThemeName = themeName
                if let bubble = getBubbleItemByName(themeName) {
                    bubbleColorHex = bubble.bubbleColor.toHex()
                    textColorHex = bubble.textColor.toHex()
                }
            }
        } catch {
            print("讀取使用者主題失敗：\(error.localizedDescription)")
        }
    }
    
    private func getBubbleItemByName(_ name: String) -> BubbleItem? {
        return bubbleItems.first { $0.name == name }
    }
    
    private func sendMessage() async {
        guard !response.isEmpty else { return }
        
        let keychain = KeychainSwift()
        guard let myUid = keychain.get("authUid"),
              let myName = keychain.get("userName") else { return }
        
        let db = Firestore.firestore()
        let timestamp = Timestamp(date: Date())
        
        let messageData: [String: Any] = [
            "content": response,
            "timestamp": timestamp,
            "bubbleColor": bubbleColorHex,
            "textColor": textColorHex,
            "senderID": myUid,
            "type": "text"
        ]
        
        do {
            try await db.collection(docID).addDocument(data: messageData)
            
            try await db.collection("users").document(myUid).collection("message").document(docID).updateData([
                "lastMessage": response,
                "lastUpdated": timestamp
            ])
            
            try await db.collection("users").document(otherUid).collection("message").document(docID).updateData([
                "lastMessage": response,
                "lastUpdated": timestamp
            ])
            
            response = ""
            print("訊息與聊天室資訊更新成功")
        } catch {
            print("訊息或聊天室資訊更新失敗：\(error.localizedDescription)")
        }
    }
}

#Preview {
    temp9(otherUid: "", docID: "測試聊天室ID", name: "對方名稱")
}
