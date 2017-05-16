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
    
    // Global variables
    let ShipName = "player"
    var motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBackgroundLayer(filename: "background", speed: 9, layer: 0)
        makeBackgroundLayer(filename: "wispbg", speed: 4, layer: 1)
        setupShip()
        
        // start collecting updates to motion manager
        motionManager.startAccelerometerUpdates()
        
    }
    
    func setupShip() {
        let player = makeShip()
        player.position = CGPoint(x: self.size.width/2.0, y: self.size.height/2.0)
        player.zPosition = 3
        addChild(player)
    }
    
    func makeShip() -> SKNode {
        let player = SKSpriteNode(imageNamed: "goodGuy006")
        player.name = ShipName
        player.setScale(0.6)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.mass = 1
        return player
    }

    func fireBlaster() {
        if let player = childNode(withName: ShipName){
        let blaster = SKSpriteNode(imageNamed: "blaster")
        blaster.setScale(1)
        blaster.position = player.position
        blaster.zPosition = 2
        self.addChild(blaster)
    
        let moveBlaster = SKAction.moveTo(y: self.size.height + player.position.y, duration: 1)
        let deletBlaster = SKAction.removeFromParent()
        
        let blasterSequence = SKAction.sequence([moveBlaster, deletBlaster])
        blaster.run(blasterSequence)
        }
    }
    
    func makeBackgroundLayer(filename: String, speed: TimeInterval, layer: Int) {
        let bgLayer = SKTexture(imageNamed: filename)
        let shiftBG = SKAction.moveBy(x: 0, y: -bgLayer.size().height, duration: speed)
        let replaceBG = SKAction.moveBy(x:0, y: bgLayer.size().height, duration: 0)
        let movingAndReplacingBG = SKAction.repeatForever(SKAction.sequence([shiftBG,replaceBG]))
        
        for i in 0 ..< 3 {
            let background = SKSpriteNode(texture:bgLayer)
            let iFloat = CGFloat(i)
            background.position = CGPoint(x: self.frame.midX, y: bgLayer.size().height/2 + (bgLayer.size().height * iFloat))
            background.size.width = self.frame.width
            background.zPosition = CGFloat(layer)
            background.run(movingAndReplacingBG)
            
            self.addChild(background)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBlaster()
    }
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        if let player = childNode(withName: ShipName) as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.02 {
                    player.physicsBody!.applyImpulse(CGVector(dx: 100 * CGFloat(data.acceleration.x), dy: 0))
                }
                if fabs(data.acceleration.y) > 0.02 {
                    player.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 100 * CGFloat(data.acceleration.y)))
                }
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        processUserMotion(forUpdate: currentTime)

    }
}
