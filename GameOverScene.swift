//
//  GameOverScene.swift
//  RememberRickenbacker
//
//  Created by Jay Myser on 7/17/17.
//  Copyright © 2017 jmyser. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "Quantico Bold")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "bgBlur")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let totalScoreLabel = SKLabelNode(fontNamed: "Quantico Bold")
        let highScoreLabel = SKLabelNode(fontNamed: "Quantico Bold")
        
        
        totalScoreLabel.text = "Score: \(gameScore)"
        totalScoreLabel.fontSize = 125
        totalScoreLabel.fontColor = SKColor.white
        totalScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        totalScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        totalScoreLabel.zPosition = 19
        self.addChild(totalScoreLabel)
        
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        highScoreLabel.zPosition = 19
        self.addChild(highScoreLabel)
        
        restartLabel.text = "RESTART"
        restartLabel.fontSize = 100
        restartLabel.fontColor = SKColor.white
        restartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        restartLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        restartLabel.zPosition = 19
        self.addChild(restartLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let backTransition = SKTransition.fade(withDuration: 0.3)
                self.view!.presentScene(sceneToMoveTo, transition: backTransition)
                
            }
        }
    }
    
    
}
