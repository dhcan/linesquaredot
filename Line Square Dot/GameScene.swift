//
//  GameScene.swift
//  Line Square Dot
//
//  Created by Daniel Hooper on 2018-09-20.
//  Copyright © 2018 danielhooper. All rights reserved.
//

import SpriteKit

final class GameScene: SKScene {
    
    private var line: Line?
    private let square = Square(length: 36)
    private var dot = Dot()
    
    private let scoreLabel = ScoreLabel()
    
    private var touchUp: CGPoint = .zero
    private var touchDown: CGPoint = .zero
    private var ignoreTouchesMoved: Bool = false
    
    let playSound: (String) -> SKAction = {
        SKAction.playSoundFileNamed($0, waitForCompletion: false)
    }
    
    override init(size: CGSize) {
        super.init(size: size)

        run(playSound(""))
        scaleMode = .aspectFit
        backgroundColor = .black
        
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0.75
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = Category.boundary.bitMask
        physicsBody?.contactTestBitMask = Category.dot.bitMask
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        view.isMultipleTouchEnabled = false
        view.backgroundColor = backgroundColor
        
        newGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameScene {

    override func update(_ currentTime: TimeInterval) {
        if dot.isIdle {
            newGame()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    
        guard let position = locationOf(touches, in: self) else { return }
        
        touchDown = position
        ignoreTouchesMoved = false

        line = Line(initialPosition: position)
        
        guard let line = line else { return }
        
        addChild(line)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard !ignoreTouchesMoved, let position = locationOf(touches, in: self) else { return }
        
        touchUp = position
        
        let path = CGMutablePath()
        path.move(to: touchDown)
        path.addLine(to: position)
        
        line?.path = path
        
        let maxDistance: CGFloat = 256.0
        if touchDown.distance(from: position) > maxDistance {
            ignoreTouchesMoved = true
            addLine()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let position = locationOf(touches, in: self), !ignoreTouchesMoved else { return }
        
        guard position.distance(from: touchDown) > 48 else {
            line?.removeFromParent()
            return
        }
        
        addLine()
    }
}

private extension GameScene {
    
    func newGame() {
        removeAllChildren()
        addScoreLabel()
        addChild(square)
        moveSquare()
        spawnDot()
    }
    
    func spawnDot() {
        dot = Dot()
        let offset: CGFloat = CGFloat(Int.random(in: 50..<150)) * 0.01
        dot.position = CGPoint(x: frame.midX * offset, y: frame.height - 5)
        addChild(dot)
        dot.run(SKAction.fadeIn(withDuration: 1))
    }
    
    func addScoreLabel() {
        addChild(scoreLabel)
        scoreLabel.score = 0
        scoreLabel.position = CGPoint(x: 16, y: frame.height - 48)
    }
    
    func addLine() {
        line?.addPhysicsBody(SKPhysicsBody(edgeFrom: touchDown, to: touchUp))
        line?.run(SKAction.fadeIn(withDuration: 0.2))
        line?.physicsBody?.affectedByGravity = true
    }

    func moveSquare() {
        let padding = 16
        let topPadding = Int(frame.height * 0.5)
        let x = Int.random(in: padding..<(Int(frame.width) - padding))
        let y = Int.random(in: padding..<topPadding)
        let randomPosition = CGPoint(x: x, y: y)
        
        square.move(to: randomPosition)
    }

    func locationOf(_ touches: Set<UITouch>, in node: SKNode) -> CGPoint? {
        return touches.first?.location(in: node)
    }
}

import AudioToolbox

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let dotBody = contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask ? contact.bodyA : contact.bodyB
        
        switch dotBody.categoryOfContact() {
        case .line:
            run(playSound("line.wav"))
        case .boundary:
            run(playSound("boundary.wav"))
            newGame()
        case .square:
            run(playSound("square.wav"))
            square.animateFill()
            scoreLabel.score = scoreLabel.score + 1
            dot.disable()
            moveSquare()
            spawnDot()
        default:
            break
        }
    }
}


