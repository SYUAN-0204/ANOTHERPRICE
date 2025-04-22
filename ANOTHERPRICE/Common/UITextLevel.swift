//
//  UITextLevel.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/20.
//

import SwiftUI

struct UITextLevel: View {
    let totalExp: Int
    let barWidth: CGFloat = 100
    let width: CGFloat
    let height: CGFloat
    let size: CGFloat
    
    var body: some View {
        let levelData = getLevelData(from: totalExp)
        ZStack{
            RoundedRectangle(cornerRadius: height / 2)
                .fill(ColorConstants.systemMainColor)
                .frame(width: width, height: height)
            Text("Lv \(levelData.level)")
                .font(.custom("BubblegumSans-Regular", size: size))
                .foregroundColor(.white)
                .frame(height: height)
        }
    }
    
    func getLevelData(from totalExp: Int) -> (level: Int, currentExp: Int, nextLevelExp: Int, progressRatio: CGFloat) {
        var level = 1
        var requiredExp = 512
        var accumulatedExp = 0

        while totalExp >= accumulatedExp + requiredExp, level < 7 {
            accumulatedExp += requiredExp
            requiredExp *= 2
            level += 1
        }

        let currentExp = totalExp - accumulatedExp
        let nextExp = requiredExp > 16384 ? 16384 : requiredExp
        let progressRatio: CGFloat = CGFloat(currentExp) / CGFloat(nextExp) > 1 ? 1 : CGFloat(currentExp) / CGFloat(nextExp)

        return (level, currentExp, nextExp, progressRatio)
    }
}

#Preview {
    UITextLevel(totalExp: 345, width: 32, height: 14, size: 12)
}
