//
//  LaunchScreenView.swift
//  ANOTHERPRICE
//
//  Created by 遠上寒山 on 2025/3/1.
//

import SwiftUI
import SpriteKit

// 創建一個 SKScene 來控制金幣掉落與圓形白屏效果
class CoinScene: SKScene {
    var isExplosionTriggered = false
    var isExplosionFinished = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hex: 0x122D3E)
        
        // 設定重力
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        // 底部地板，防止金幣掉出畫面
        let ground = SKNode()
        ground.position = CGPoint(x: size.width / 2, y: 0)
        let groundBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 10))
        groundBody.isDynamic = false
        ground.physicsBody = groundBody
        addChild(ground)
        
        // 添加左右牆面
        let leftWall = SKNode()
        leftWall.position = CGPoint(x: 0, y: size.height / 2) // 左邊界
        let leftWallBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: size.height))
        leftWallBody.isDynamic = false
        leftWall.physicsBody = leftWallBody
        addChild(leftWall)
        
        let rightWall = SKNode()
        rightWall.position = CGPoint(x: size.width, y: size.height / 2) // 右邊界
        let rightWallBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: size.height))
        rightWallBody.isDynamic = false
        rightWall.physicsBody = rightWallBody
        addChild(rightWall)
        
        // 連續產生金幣
        let spawnAction = SKAction.run {
            self.spawnCoin()
        }
        let waitAction = SKAction.wait(forDuration: 0.1)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        
        run(repeatAction)
        
        // 設置計時器，觸發圓形放大效果
        let delayAction = SKAction.wait(forDuration: 3.5)
        let triggerExplosion = SKAction.run {
            self.createExplosionEffect()
        }
        run(SKAction.sequence([delayAction, triggerExplosion]))
    }
    
    func spawnCoin() {
        let coin = SKSpriteNode(imageNamed: "Logo")
        let randomX = CGFloat.random(in: 50...size.width - 50)
        coin.position = CGPoint(x: randomX, y: size.height)
        coin.size = CGSize(width: 100, height: 100)
        
        let coinBody = SKPhysicsBody(circleOfRadius: 50) // 物理碰撞範圍
        coinBody.restitution = 0.3 // 彈力
        coinBody.mass = 0.1
        coin.physicsBody = coinBody
        
        addChild(coin)
    }
    
    func createExplosionEffect() {
        // 如果已經觸發過，避免重複觸發
        if isExplosionTriggered { return }
        isExplosionTriggered = true
        
        // 創建圓形，實心圓
        let circle = SKShapeNode(circleOfRadius: 1)
        circle.fillColor = .white
        circle.strokeColor = .clear // 讓圓形沒有邊框，保持實心
        
        // 設置圓形的位置在頂部中心
        circle.position = CGPoint(x: size.width / 2, y: size.height)
        addChild(circle)
        
        // 放大圓形的動畫
        let scaleAction = SKAction.scale(to: size.height, duration: 0.5) // 加快速度，減少放大時間
        let sequence = SKAction.sequence([scaleAction])
        
        // 讓圓形快速放大，並覆蓋整個畫面
        circle.run(sequence)
        
        // 等待動畫結束後，停止並清除
        let waitAction = SKAction.wait(forDuration: 1)
        let removeAction = SKAction.removeFromParent()
        let removeSequence = SKAction.sequence([waitAction, removeAction])
        circle.run(removeSequence)
        
        // 在圓形動畫結束後隱藏畫面或進行其他操作
        let hideAction = SKAction.run {
            self.isExplosionFinished = true
            self.view?.isHidden = true  // 隱藏整個畫面
        }
        
        run(SKAction.sequence([waitAction, hideAction]))
    }
}

struct LaunchScreenView: View {
    
    @State private var isActive = false
    
    var scene: SKScene {
        let scene = CoinScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        if isActive {
            ToolView()
        } else {
            ZStack{
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
            .background(ColorConstants.systemSubColor)
        }
    }
}

#Preview {
    LaunchScreenView()
}
