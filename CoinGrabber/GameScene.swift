//
//  GameScene.swift
//  CoinGrabber
//
//  Created by Jim Challenger on 2/20/17.
//  Copyright © 2017 Jim Challenger. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var gameBackground = SKSpriteNode()
    var floor = SKSpriteNode()
    var birdAtlas = SKTextureAtlas(named: "player.atlas")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    let birdCategory: UInt32 = 0x1 << 0
    let floorCategory:UInt32 = 0x1 << 1
    var goRight = Bool(true)
    var speedMult = 1.0
    
    override func didMove(to view: SKView) {
        floor = SKSpriteNode(imageNamed: "floor")
        floor.anchorPoint = CGPoint(x: 0.5, y: 3);
        floor.position = CGPoint(x: 0, y: 0);
        floor.setScale(1.5)
        
        birdSprites.append(birdAtlas.textureNamed("player1"))
        birdSprites.append(birdAtlas.textureNamed("player2"))
        birdSprites.append(birdAtlas.textureNamed("player3"))
        birdSprites.append(birdAtlas.textureNamed("player4"))
        
        bird = SKSpriteNode(texture: birdSprites[0])
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY);
        bird.size.width = bird.size.width / 6
        bird.size.height = bird.size.height / 6
        
        let animateBird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatForever(animateBird)
        self.bird.run(repeatAction)
        
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        
        floor.physicsBody?.categoryBitMask = floorCategory
        floor.physicsBody?.contactTestBitMask = birdCategory
        
        floor.physicsBody = SKPhysicsBody(edgeLoopFrom: floor.frame)
        
        createBirdPhysics()
        
        addChild(self.bird)
        addChild(self.floor)
    }
    
    func createBirdPhysics() {
        bird.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.bird.size.width / 2))
        bird.physicsBody?.affectedByGravity = false;
        
        bird.physicsBody?.linearDamping = 0
        bird.physicsBody?.restitution = 0
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = floorCategory
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.goRight) {
            self.bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 0))
            self.bird.physicsBody!.applyImpulse(CGVector(dx: 140 * self.speedMult, dy: 0))
            self.speedMult = 2
            self.goRight = false
        } else {
            self.bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 0))
            self.bird.physicsBody!.applyImpulse(CGVector(dx: -140 * self.speedMult, dy: 0))
            self.goRight = true
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
