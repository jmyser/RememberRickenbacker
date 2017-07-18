//
//  MainMenuScene.swift
//  RememberRickenbacker
//
//  Created by Jay Myser on 7/17/17.
//  Copyright © 2017 jmyser. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{

    let newGameLabel = SKLabelNode(fontNamed: "Quantico Bold")
    
    override func didMove(to view: SKView) {
        
        let defaults = UserDefaults()
        let highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        let background = SKSpriteNode(imageNamed: "bgBlur")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        addChild(background)
        
        let logo = SKSpriteNode(imageNamed: "logo.png")
        logo.position = CGPoint(x: self.size.width/2.0, y: self.size.height * 0.7)
        logo.zPosition = 1
        logo.setScale(0.8)
        self.addChild(logo)
        
        let highScoreLabel = SKLabelNode(fontNamed: "Quantico Bold")
        highScoreLabel.text = "Record Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 75
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        highScoreLabel.zPosition = 2
        self.addChild(highScoreLabel)
        
        
        newGameLabel.text = "New Game"
        newGameLabel.fontSize = 100
        newGameLabel.fontColor = SKColor.white
        newGameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        newGameLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.3)
        newGameLabel.zPosition = 2
        self.addChild(newGameLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if newGameLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let backTransition = SKTransition.fade(withDuration: 0.3)
                self.view!.presentScene(sceneToMoveTo, transition: backTransition)
                
            }
        }
    }

}

