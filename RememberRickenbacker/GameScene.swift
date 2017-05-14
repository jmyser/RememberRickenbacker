//
//  GameScene.swift
//  RememberRickenbacker
//
//  Created by Jay Myser on 5/12/17.
//  Copyright © 2017 jmyser. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let player = SKSpriteNode(imageNamed: "goodGuy005")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode (imageNamed: "backgroundIMG")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        player.setScale(0.75)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
    }
    
    func fireBlaster() {
        let blaster = SKSpriteNode(imageNamed: "blaster")
        blaster.setScale(1)
        blaster.position = player.position
        blaster.zPosition = 1
        self.addChild(blaster)
    
        let moveBlaster = SKAction.moveTo(y: self.size.height + blaster.size.height, duration: 1)
        let deletBlaster = SKAction.removeFromParent()
        
        let blasterSequence = SKAction.sequence([moveBlaster, deletBlaster])
        blaster.run(blasterSequence)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBlaster()
    }
}
