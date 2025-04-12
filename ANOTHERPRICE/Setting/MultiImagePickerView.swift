//
//  MultiImagePickerView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/13.
//


import SwiftUI
import PhotosUI


struct PhotosSelector: View {
    @State var selectedItems: [PhotosPickerItem] = []


    var body: some View {
        PhotosPicker(selection: $selectedItems,
                     matching: .images) {
            Text("Select Multiple Photos")
        }
    }
}

#Preview {
    PhotosSelector()
}
