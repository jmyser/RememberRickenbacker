//
//  GameScene.swift
//  RememberRickenbacker
//
//  Created by Jay Myser on 5/12/17.
//  Copyright © 2017 jmyser. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {

    let player = SKSpriteNode(imageNamed: "goodGuy005")
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    var destY:CGFloat  = 0.0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode (imageNamed: "backgroundIMG")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(0.75)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        player.zPosition = 2
        self.addChild(player)
        
        if motionManager.isAccelerometerAvailable == true {
            // 2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                
                let currentX = self.player.position.x
                let currentY = self.player.position.y
                self.destX = currentX + CGFloat((data?.acceleration.x)! * 750)
                self.destY = currentY + CGFloat((data?.acceleration.y)! * 750)
                
            })
            
        }
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
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var action = SKAction.moveTo(x: destX, duration: 0.5)
        self.player.run(action)
        action = SKAction.moveTo(y: destY, duration: 0.5)
        self.player.run(action)
    }
    
}
