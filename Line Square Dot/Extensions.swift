//
//  Extensions.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2019-12-09.
//  Copyright © 2019 danielhooper. All rights reserved.
//

import SpriteKit.SKShapeNode

extension SKShapeNode {
    
    var isIdle: Bool {
        return physicsBody?.isResting ?? false
    }
}

import UIKit

extension UIColor {

    static var random: UIColor {
        let hue = CGFloat(Int.random(in: 0..<100)) * 0.01
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
    }
}

extension CGPoint {
    
    func distance(from point: CGPoint) -> CGFloat {
        return CGFloat(
            hypotf(Float(x - point.x), Float(y - point.y))
        )
    }
}

extension CGPath {
    
    func mutableLinePath(fromPosition position: CGPoint) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: position)
        path.addLine(to: position)
        return path
    }
}
