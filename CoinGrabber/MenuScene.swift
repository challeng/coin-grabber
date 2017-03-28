//
//  MenuScene.swift
//  CoinGrabber
//
//  Created by Jim Challenger on 3/27/17.
//  Copyright © 2017 Jim Challenger. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    var mainLabel: SKLabelNode!
    var mainLabel2: SKLabelNode!
    
    override func didMove(to view: SKView) {
        setLabels()
        
        self.playButton = SKSpriteNode(imageNamed: "coin-us-dollar")
        self.playButton.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.85)
        self.playButton.setScale(0.50)
        
        //playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        self.addChild(self.playButton)
    }
    
    func setLabels() {
        setMainLabel()
        setMainLabel2()
    }
    
    func setMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Chalkduster")
        mainLabel.fontSize = 50
        mainLabel.text = "Coin Catcher!"
        mainLabel.horizontalAlignmentMode = .center
        mainLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.85)
        addChild(mainLabel)
    }
    
    func setMainLabel2() {
        mainLabel = SKLabelNode(fontNamed: "Chalkduster")
        mainLabel.fontSize = 50
        mainLabel.text = "Catch all of them!"
        mainLabel.horizontalAlignmentMode = .center
        mainLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * 0.70)
        addChild(mainLabel)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
         if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
         
            if node == playButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 0.2)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
         }
    }
}
