//
//  Category.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2018-09-20.
//  Copyright © 2018 danielhooper. All rights reserved.
//

enum Category: CaseIterable {

    case line, square, dot, boundary

    var bitMask: UInt32 {
        switch self {
        case .line: return 0x1 << 1
        case .square: return 0x1 << 3
        case .dot: return 0x1 << 0
        case .boundary: return 0x1 << 2
        }
    }
}

import SpriteKit.SKPhysicsBody

extension SKPhysicsBody {
    
    func categoryOfContact() -> Category? {
        return Category.allCases.first(where: { self.categoryBitMask & $0.bitMask != 0})
    }
}
