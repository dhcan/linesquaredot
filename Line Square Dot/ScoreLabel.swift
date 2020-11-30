//
//  ScoreLabel.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2019-12-20.
//  Copyright © 2019 danielhooper. All rights reserved.
//

import SpriteKit.SKLabelNode

final class ScoreLabel: SKLabelNode {
    
    override init() {
        super.init()
        fontColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var score: Int = 0 {
        didSet {
            text = "\(score)"
        }
    }
}
