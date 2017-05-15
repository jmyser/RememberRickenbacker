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

    let player = SKSpriteNode(imageNamed: "goodGuy006")
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    var destY:CGFloat  = 0.0
    
    var gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode (imageNamed: "backgroundIMG")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(0.6)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        player.zPosition = 2
        self.addChild(player)
        
        if motionManager.isAccelerometerAvailable == true {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                
                let currentX = self.player.position.x
                let currentY = self.player.position.y
                self.destX = currentX + CGFloat((data?.acceleration.x)! * 1500)
                self.destY = currentY + CGFloat((data?.acceleration.y)! * 1500)
                
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
        
        if player.position.x > gameArea.maxX {
            player.position.x = gameArea.maxX
        }
        if player.position.x < gameArea.minX {
            player.position.x = gameArea.minX
        }
        if player.position.y > gameArea.maxY {
            player.position.y = gameArea.maxY
        }
        if player.position.y < gameArea.minY {
            player.position.y = gameArea.minY
        }
    }
    
}
