//
//  Square.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2018-09-20.
//  Copyright © 2018 danielhooper. All rights reserved.
//

import SpriteKit.SKShapeNode

final class Square: SKShapeNode {
    
    convenience init(length: CGFloat = 36) {
        let size = CGSize(width: length, height: length)
        self.init(rectOf: size)

        lineWidth = 2
        fillColor = .black
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.mass = 100
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        
        physicsBody?.categoryBitMask = Category.square.bitMask
        physicsBody?.collisionBitMask = Category.dot.bitMask
        physicsBody?.contactTestBitMask = Category.dot.bitMask
        
        zPosition = 1
    }
    
    /// Disables collision and performs a smooth animation to the next position. Collision is renabled after the animation completes.
    func move(to position: CGPoint) {
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = 0
        let action = SKAction.move(to: position, duration: 1)
        action.timingMode = .easeInEaseOut
        run(action) {
            self.physicsBody?.collisionBitMask = Category.dot.bitMask
            self.physicsBody?.contactTestBitMask = Category.dot.bitMask
        }
    }
    
    func animateFill() {
        run(SKAction.repeat(SKAction.sequence([customActionForColor(.white), customActionForColor(.clear)]), count: 3))
    }
    
    private func customActionForColor(_ color: UIColor) -> SKAction {
        SKAction.customAction(withDuration: 0.1) { _, _ in
            self.fillColor = color
        }
    }
}
