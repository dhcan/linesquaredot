//
//  Line.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2018-09-20.
//  Copyright © 2018 danielhooper. All rights reserved.
//

import SpriteKit.SKShapeNode

final class Line: SKShapeNode {
    
    init(path: CGPath) {
        super.init()
        
        // this value is brought back to 1 when solidified into game scene
        alpha = 0.2
        lineCap = .round
        strokeColor = UIColor.random
    }
    
    convenience init(initialPosition position: CGPoint) {
        let path = CGMutablePath()
        path.move(to: position)
        path.addLine(to: position)
        
        self.init(path: path)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPhysicsBody(_ body: SKPhysicsBody) {
        body.affectedByGravity = false
        body.categoryBitMask = Category.line.bitMask
        body.collisionBitMask = Category.dot.bitMask
        body.contactTestBitMask = Category.dot.bitMask
        physicsBody = body
    }
}
