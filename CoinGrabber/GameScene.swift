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
    var coin = SKSpriteNode()
    let birdCategory: UInt32 = 0x1 << 0
    let coinCategory: UInt32 = 0x1 << 1
    var goRight = Bool(true)
    var speedMult = 1.0
    var scoreLabel: SKLabelNode!
    var scoreColor: CGFloat = 1
    var score = 0
    var backArrow = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        floor = SKSpriteNode(imageNamed: "floor")
        floor.anchorPoint = CGPoint(x: 0.5, y: 3);
        floor.position = CGPoint(x: 0, y: 0);
        floor.setScale(1.5)
        
        coin = SKSpriteNode(imageNamed: "coin")
        coin.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.85)
        coin.setScale(0.25)
        
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
        
        //floor.physicsBody?.categoryBitMask = floorCategory
        //floor.physicsBody?.contactTestBitMask = birdCategory
        
        //floor.physicsBody = SKPhysicsBody(edgeLoopFrom: floor.frame)
        
        createBirdPhysics()
        createCoinPhysics()
        //addBackArrow()
        
        setScoreLabel()
        
        spawnCoin()
        
        addChild(self.bird)
        //addChild(self.coin)
        //addChild(self.floor)
        
        
        
    }
    
    func addBackArrow() {
        backArrow = SKSpriteNode(imageNamed: "back_arrow")
        backArrow.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.93)
        backArrow.setScale(0.13)
        addChild(backArrow)
        
    }
    
    func setScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 200
        setScoreText()
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.60)
        
        addChild(scoreLabel)
    }
    
    func setScoreText() {
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = SKColor(red: scoreColor, green: scoreColor, blue: scoreColor, alpha: 1.0)
    }
    
    func spawnCoin() {
        let randomX = Double(arc4random_uniform(UInt32(self.frame.maxX)))
        let randomY = Double(arc4random_uniform(UInt32(self.frame.maxY)))
        
        let newCoin = SKSpriteNode(imageNamed: "coin")
        newCoin.position = CGPoint(x: randomX, y: randomY)
        newCoin.setScale(0.25)
        
        
        
        newCoin.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(newCoin.size.width / 2))
        
        newCoin.physicsBody?.linearDamping = 0
        newCoin.physicsBody?.restitution = 1
        newCoin.physicsBody?.isDynamic = true
        
        newCoin.physicsBody?.categoryBitMask = coinCategory
        newCoin.physicsBody?.contactTestBitMask = birdCategory
        
        self.coin = newCoin
        
        addChild(self.coin)
        
        
        
    }
    
    func createBirdPhysics() {
        bird.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.bird.size.width / 2))
        bird.physicsBody?.affectedByGravity = false;
        
        bird.physicsBody?.linearDamping = 0
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.isDynamic = true
        
        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.contactTestBitMask = coinCategory
    }
    
    func createCoinPhysics() {
        coin.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.coin.size.width / 2))
        
        coin.physicsBody?.linearDamping = 0
        coin.physicsBody?.restitution = 1
        coin.physicsBody?.isDynamic = true
        
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = birdCategory
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node == coin && contact.bodyB.node == bird) || (contact.bodyA.node == bird && contact.bodyB.node == coin){
            score += 1
            setScoreText()
            addColorChange()
            coin.removeFromParent()
            let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.spawnCoin), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let pos = touch?.location(in: self)
        let node = self.atPoint(pos!)
            
        if node == backArrow {
            if view != nil {
                let transition:SKTransition = SKTransition.fade(withDuration: 0.2)
                let scene:SKScene = MenuScene(size: self.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
        
    
    
        
        
        


        let xDir = (pos?.x)! - bird.position.x
        let yDir = (pos?.y)! - bird.position.y
        
        self.bird.physicsBody!.applyImpulse(CGVector(dx: xDir, dy: yDir))
        
        

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func addColorChange() {
        scoreColor = (10000 - CGFloat(score)) / 10000
        setScoreText()
        
        
        if score > 0 && score <= 10000 {
            scoreColor = (10000 - CGFloat(score)) / 10000
            print(scoreColor)
            setScoreText()
        }
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
