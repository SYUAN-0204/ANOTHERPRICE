//
//  UIRectangleLine.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/5/3.
//

import SwiftUI

struct UIRectangleLine: View {
    let opacity: Double
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(opacity))
            .frame(height: 1)
    }
}

#Preview {
    UIRectangleLine(opacity: 0.3)
}
