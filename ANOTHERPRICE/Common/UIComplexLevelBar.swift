//
//  UIComplexLevelBar.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/4/15.
//

import SwiftUI

struct UIComplexLevelBar: View {
    let totalExp: Int
    let barWidth: CGFloat = 100
    
    var body: some View {
        let levelData = getLevelData(from: totalExp)
        HStack{
            Text("Lv \(levelData.level)")
                .font(.custom("BubblegumSans-Regular", size: 16))
                .foregroundColor(ColorConstants.systemMainColor)
            VStack(alignment: .trailing){
                if levelData.currentExp > 16384 {
                    Text("\(levelData.currentExp)/MAX")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                        .foregroundColor(.gray)
                        .padding(.top, -4)
                }
                else{
                    Text("\(levelData.currentExp)/\(levelData.nextLevelExp)")
                        .font(.custom("LXGWWenKaiMonoTC-Regular", size: 10))
                        .foregroundColor(.gray)
                        .padding(.top, -4)
                }
                ZStack(alignment: .leading){
                    Rectangle()
                        .frame(width: barWidth, height: 2)
                        .foregroundColor(.gray.opacity(0.5))
                    Rectangle()
                        .frame(width: barWidth * levelData.progressRatio, height: 2)
                        .foregroundColor(ColorConstants.systemMainColor)
                }
                .padding(.top, -6)
            }
            .padding(.leading, -5)
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
    UIComplexLevelBar(totalExp: 513)
}
