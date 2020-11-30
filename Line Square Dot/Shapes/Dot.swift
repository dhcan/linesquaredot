//
//  Dot.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2018-09-20.
//  Copyright © 2018 danielhooper. All rights reserved.
//

import SpriteKit.SKShapeNode


final class Dot: SKShapeNode {
    
    override init() {
        super.init()
        
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: 3, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        self.path = path
        
        alpha = 0
        zPosition = 1
        fillColor = .white
        
        physicsBody = SKPhysicsBody(circleOfRadius: frame.width * 0.4)
        physicsBody?.mass = 0.1
        physicsBody?.restitution = 0.99
        physicsBody?.categoryBitMask = Category.dot.bitMask
        physicsBody?.contactTestBitMask = Category.line.bitMask | Category.boundary.bitMask | Category.square.bitMask
        physicsBody?.collisionBitMask = Category.line.bitMask | Category.boundary.bitMask | Category.square.bitMask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func disable() {
        zPosition = -1
        fillColor = .clear
        disableCollision()
    }
    
    private func disableCollision() {
        physicsBody?.categoryBitMask = 0
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = Category.boundary.bitMask
    }
}
