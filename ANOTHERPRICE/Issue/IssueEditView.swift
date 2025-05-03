//
//  TempView2.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import KeychainSwift
import PhotosUI

struct IssueEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isDraft:Bool
    @State var draftId:String?
    @State var showTip:Bool = false
    @State var title:String
    @State var description:String
    @State private var keychain = KeychainSwift()
    @State private var db = Firestore.firestore()
    @State private var originalTitle: String = ""
    @State private var originalDescription: String = ""
    
    @State private var selectedItems: [PhotosPickerItem] = [] //Picker元件自用變數
    @State private var selectedImages: [UIImage] = [] //圖片陣列
    @State private var isImageZoomed: Bool = false
    @State private var zoomedImageIndex: Int? = nil
    @State private var isFileSelected: Bool = false
    @State private var shouldNavigate = false
    
    @EnvironmentObject var nav: NavigationCoordinator
    
    var body: some View {
        ZStack{
            VStack{
                HStack {
                    HStack{
                        Button {
                            if title == originalTitle && description == originalDescription {
                                dismiss()
                            } else {
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
                    HStack {
                        Spacer()
                        Button {
                            saveToKeychain()
                            nav.push(.issueSetting)
                        } label: {
                            Text("繼續")
                                .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 30)
                                .background(ColorConstants.systemMainColor.opacity(title.isEmpty ? 0.7 : 1.0))
                                .cornerRadius(5)
                        }
                        .disabled(title.isEmpty)
                    }
                    .padding(.trailing, 10)
                    .frame(width: 80)
                }
                .frame(height: 36)
                ScrollView{
                    ZStack{
                        Text(title)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .padding(.vertical, 3)
                        TextEditor(text: $title)
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
                            .frame(minHeight: 40)
                            .onChange(of: title) {
                                if title.starts(with: "\n") ||  title.starts(with: " ") {
                                    title = String(title.dropFirst())
                                }
                                if title.count > 50 {
                                    title = String(title.prefix(50))
                                    
                                }
                            }
                            .overlay(
                                Group {
                                    if title.isEmpty {
                                        VStack{
                                            HStack{
                                                Text("標題")
                                                    .font(.custom("LXGWWenKaiMonoTC-Regular", size: 20))
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
                    }
                    .padding(.horizontal, 10)
                    HStack{
                        Spacer()
                        Text("\(title.count)/50")
                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 12))
                            .foregroundColor(.gray)
                            .padding(.trailing, 16)
                    }
                    .padding(.top, -15)
                    UIRectangleLine(opacity: 0.7)
                        .padding(.horizontal, 10)
                        .padding(.top, -5)
                    TextEditor(text: $description)
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 18))
                        .frame(minHeight: 440)
                        .overlay(
                            Group {
                                if description.isEmpty {
                                    VStack{
                                        HStack{
                                            Text("問題描述")
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
                        .onChange(of: description) {
                            if description.starts(with: "\n") ||  description.starts(with: " ") {
                                description = String(description.dropFirst())
                            }
                        }
                        .padding(.horizontal, 10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(selectedImages.indices, id: \.self) { index in
                                Button {
                                    isImageZoomed = true
                                    zoomedImageIndex = index
                                } label: {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: selectedImages[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipped()
                                        Button(action: {
                                            selectedImages.remove(at: index)
                                            selectedItems.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                        }
                                        .frame(width: 30, height: 30)
                                        .offset(x: -5, y: 5)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    HStack{
                                        Text("檔案名稱.txt")
                                            .font(.custom("LXGWWenKaiMonoTC-Regular", size: 16))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Button(action: {
                                            //刪除夾檔
                                        }) {
                                            Image(systemName: "xmark")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 14))
                                        }
                                        .frame(width: 20, height: 20)
                                    }
                                    .padding(.horizontal, 10)
                                }
                                .frame(width: 180, height: 36)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                HStack{
                    Spacer()
                    PhotosPicker(selection: $selectedItems,
                                 maxSelectionCount: 0,
                                 selectionBehavior: .ordered,
                                 matching: .images,
                                 photoLibrary: .shared())
                    {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .onChange(of: selectedItems) {
                        print("show")
                        print(selectedItems)
                        selectedImages = []
                        Task {
                            for item in selectedItems {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImages.append(image)
                                }
                            }
                        }
                    }
                    Button() {
                        isFileSelected = true
                    } label: {
                        Image(systemName: "paperclip")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .fileImporter(
                        isPresented: $isFileSelected,
                        allowedContentTypes: [.item], // 支援所有檔案類型
                        allowsMultipleSelection: true
                    ) { result in
                        switch result {
                        case .success(_):
                            print("選擇檔案成功")
                            //uploadFileToFirebase(fileURL: url)
                        case .failure(let error):
                            print("選擇檔案失敗：\(error)")
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .alert("草稿", isPresented: $showTip) {
                if isDraft {
                    Button("直接退出", role: .destructive) {
                        dismiss()
                    }
                    Button("儲存變更") {
                        updateDraft()
                        dismiss()
                    }
                } else {
                    Button("直接退出", role: .destructive) {
                        print("直接退出")
                        dismiss()
                    }
                    Button("儲存草稿") {
                        saveDraft()
                        dismiss()
                    }
                }
                Button("取消", role: .cancel) {
                    showTip = false
                }
            } message: {
                Text(isDraft ? "您要如何處理編輯的草稿？" : "您要如何處理新建的問題？")
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                originalTitle = title
                originalDescription = description
            }
            if isImageZoomed {
                Color.white.opacity(0.9)
                    .ignoresSafeArea(edges: .all)
                    .onTapGesture {
                        isImageZoomed = false
                    }
                Image(uiImage: selectedImages[zoomedImageIndex ?? 0])
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        isImageZoomed = true
                    }
            }
        }
    }
    
    func saveToKeychain() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        keychain.set(trimmedTitle, forKey: "title")
        keychain.set(trimmedDescription, forKey: "description")
        keychain.set(draftId ?? "", forKey: "draftId")
    }
    
    func saveDraft() {
        let userUid = keychain.get("authUid") ?? nil
        if(userUid == nil) {
            return
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let draftData: [String: Any] = [
            "title": trimmedTitle,
            "description": trimmedDescription,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]
        
        db.collection("users").document(userUid!).collection("drafts").addDocument(data: draftData) { error in
            if let error = error {
                print("儲存草稿失敗: \(error.localizedDescription)")
            } else {
                print("草稿儲存成功")
            }
        }
    }
    
    func updateDraft() {
        let userUid = keychain.get("authUid") ?? nil
        if(userUid == nil) {
            return
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let updatedData: [String: Any] = [
            "title": trimmedTitle,
            "description": trimmedDescription,
            "updatedAt": Timestamp()
        ]
        
        db.collection("users").document(userUid!).collection("drafts").document(draftId!).updateData(updatedData) { error in
            if let error = error {
                print("更新草稿失敗: \(error.localizedDescription)")
            } else {
                print("草稿\(draftId!)更新成功")
            }
        }
    }
}

#Preview {
    IssueEditView(isDraft: false, draftId: nil, title: "", description: "")
        .environmentObject(NavigationCoordinator())
}
