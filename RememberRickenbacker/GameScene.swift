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

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var livesNumber = 4
    var levelNumber = 0
    var levelThreshHold = 50
    
    let scoreLabel = SKLabelNode(fontNamed: "Quantico Bold")
    let livesLabel = SKLabelNode(fontNamed: "Quantico Bold")
    let levelUpLabel = SKLabelNode(fontNamed: "Quantico Bold")
    let gameOverLabel = SKLabelNode(fontNamed: "Quantico Bold")
    
    enum gameState{
        case beforeGame
        case duringGame
        case afterGame
    }
    
    enum weaponsUpgrade{
        case normalBlaster
        case upgradeBlaster
    }
    
    var currentGameState = gameState.duringGame
    var currentWeapon = weaponsUpgrade.normalBlaster
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // 1
        static let Blaster : UInt32 = 0b10 // 2
        static let TriBlaster : UInt32 = 0b100 // 4
        static let Enemy : UInt32 = 0b10000 // 16
        static let UpgradeCube : UInt32 = 0b1000000 // 32
    }
    
    let ShipName = "player"
    var motionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBackgroundLayer(filename: "background", speed: 9, layer: 0)
        makeBackgroundLayer(filename: "wispbg", speed: 4, layer: 1)
        setupShip()
        
        // start collecting updates to motion manager
        motionManager.startAccelerometerUpdates()
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.95)
        scoreLabel.zPosition = 20
        self.addChild(scoreLabel)
        
        levelUpLabel.text = "Level 0"
        levelUpLabel.fontSize = 60
        levelUpLabel.fontColor = SKColor.white
        levelUpLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        levelUpLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.95)
        levelUpLabel.zPosition = 19
        self.addChild(levelUpLabel)
        
        livesLabel.text = "Lives: 4"
        livesLabel.fontSize = 60
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.95)
        livesLabel.zPosition = 18
        self.addChild(livesLabel)
        
        
        startNewLevel()
    }
    
    func loseLife(){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        currentWeapon = weaponsUpgrade.normalBlaster
        
        if livesNumber == 0 {
            currentGameState = gameState.afterGame
            gameOverLabel.text = "GAME OVER"
            gameOverLabel.fontSize = 100
            gameOverLabel.fontColor = SKColor.white
            gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
            gameOverLabel.zPosition = 30
            self.addChild(gameOverLabel)
            
            let changeSceneAction = SKAction.run(changeScene)
            let waitToChangeScene = SKAction.wait(forDuration: 3)
            let changeSceneSeq = SKAction.sequence([waitToChangeScene,changeSceneAction])
            self.run(changeSceneSeq)
            
        }
        else {
            let respawn = SKAction.run(setupShip)
            let waitToRespawn = SKAction.wait(forDuration: 1)
            let respawnSeq = SKAction.sequence([waitToRespawn, respawn])
            self.run(respawnSeq)
        }
        
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 2)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
    }
    
    func addScore(){
        gameScore += 10
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore > levelThreshHold{
            levelThreshHold += 50
            startNewLevel()
        }
        
    }
    
    func subtractScore(){
        if currentGameState == gameState.duringGame{
            gameScore -= 1
            scoreLabel.text = "Score: \(gameScore)"
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //player hits enemy
            loseLife()
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.UpgradeCube{
            //player hits upgradeCube
            if body2.node != nil {
                currentWeapon = weaponsUpgrade.upgradeBlaster
            }
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Blaster && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height{
            //blaster hits enemy
            addScore()
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == PhysicsCategories.TriBlaster && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height{
            //tri blaster hits enemy
            addScore()
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosition")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    func startNewLevel(){
        levelNumber += 1
        
        if levelNumber > 1 && currentWeapon == weaponsUpgrade.normalBlaster{
            spawnUpgradeCube()
        }
        
        if self.action(forKey: "enemyKey") != nil{
            self.removeAction(forKey: "enemyKey")
        }
        
        levelUpLabel.text = "Level: \(levelNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        levelUpLabel.run(scaleSequence)
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 2.0
        case 2: levelDuration = 1.5
        case 3: levelDuration = 1.0
        case 4: levelDuration = 0.5
        default: levelDuration = 0.2
        }
        
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "enemyKey")
    }
    
    func setupShip() {
        let player = makeShip()
        player.position = CGPoint(x: self.size.width/2.0, y: self.size.height * 0.2)
        player.zPosition = 3
        addChild(player)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
        let scaleDown = SKAction.scale(to: 0.6, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        player.run(scaleSequence)
    }
    
    func makeShip() -> SKNode {
        let player = SKSpriteNode(imageNamed: "goodGuy006")
        player.name = ShipName
        player.setScale(0.6)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.mass = 2
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        return player
    }
    
    func fireBlaster() {
        if let player = childNode(withName: ShipName){
            let blaster = SKSpriteNode(imageNamed: "blaster")
            blaster.name = "Blaster"
            blaster.setScale(1)
            blaster.position = player.position
            blaster.zPosition = 2
            blaster.physicsBody = SKPhysicsBody(rectangleOf: blaster.frame.size)
            blaster.physicsBody!.affectedByGravity = false
            blaster.physicsBody!.categoryBitMask = PhysicsCategories.Blaster
            blaster.physicsBody!.collisionBitMask = PhysicsCategories.None
            blaster.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(blaster)
            
            let moveBlaster = SKAction.moveTo(y: self.size.height + player.position.y, duration: 1)
            let deletBlaster = SKAction.removeFromParent()
            
            let blasterSequence = SKAction.sequence([moveBlaster, deletBlaster])
            blaster.run(blasterSequence)
        }
    }
    
    func triBlaster() {
        if let player = childNode(withName: ShipName){
            
            let triBlaster = SKSpriteNode(imageNamed: "blaster")
            triBlaster.name = "TriBlaster"
            triBlaster.setScale(0.75)
            triBlaster.position = player.position
            triBlaster.zPosition = 2
            triBlaster.physicsBody = SKPhysicsBody(rectangleOf: triBlaster.frame.size)
            triBlaster.physicsBody!.affectedByGravity = false
            triBlaster.physicsBody!.categoryBitMask = PhysicsCategories.TriBlaster
            triBlaster.physicsBody!.collisionBitMask = PhysicsCategories.None
            triBlaster.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(triBlaster)
            
            let triBlaster_left = SKSpriteNode(imageNamed: "blaster")
            triBlaster_left.name = "TriBlaster_Left"
            triBlaster_left.setScale(0.75)
            triBlaster_left.position = player.position
            triBlaster_left.zPosition = 2
            triBlaster_left.physicsBody = SKPhysicsBody(rectangleOf: triBlaster_left.frame.size)
            triBlaster_left.physicsBody!.affectedByGravity = false
            triBlaster_left.physicsBody!.categoryBitMask = PhysicsCategories.TriBlaster
            triBlaster_left.physicsBody!.collisionBitMask = PhysicsCategories.None
            triBlaster_left.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(triBlaster_left)
            
            let triBlaster_right = SKSpriteNode(imageNamed: "blaster")
            triBlaster_right.name = "TriBlaster_Right"
            triBlaster_right.setScale(0.75)
            triBlaster_right.position = player.position
            triBlaster_right.zPosition = 2
            triBlaster_right.physicsBody = SKPhysicsBody(rectangleOf: triBlaster_right.frame.size)
            triBlaster_right.physicsBody!.affectedByGravity = false
            triBlaster_right.physicsBody!.categoryBitMask = PhysicsCategories.TriBlaster
            triBlaster_right.physicsBody!.collisionBitMask = PhysicsCategories.None
            triBlaster_right.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            self.addChild(triBlaster_right)
            
            let pointLeft = CGPoint(x: player.position.x - self.size.width / 2, y: self.size.height + player.position.y)
            let pointRight = CGPoint(x: player.position.x + self.size.width / 2, y: self.size.height + player.position.y)

            let moveTriBlaster_left = SKAction.move(to: pointLeft, duration: 1)
            let moveTriBlaster = SKAction.moveTo(y: self.size.height + player.position.y, duration: 1)
            let moveTriBlaster_right = SKAction.move(to: pointRight, duration: 1)
            let deleteTriBlaster = SKAction.removeFromParent()
            let deleteTriBlaster_left = SKAction.removeFromParent()
            let deleteTriBlaster_right = SKAction.removeFromParent()
            
            let triBlasterSequence = SKAction.sequence([moveTriBlaster, deleteTriBlaster])
            let triBlasterLeftSequence = SKAction.sequence([moveTriBlaster_left, deleteTriBlaster_left])
            let triBlasterRightSequence = SKAction.sequence([moveTriBlaster_right, deleteTriBlaster_right])
            triBlaster.run(triBlasterSequence)
            triBlaster_right.run(triBlasterRightSequence)
            triBlaster_left.run(triBlasterLeftSequence)
            
        }
    }
    
    func spawnEnemy(){
        let randomXStart = random(min: frame.minX, max: frame.maxX)
        let randomXEnd = random(min: frame.minX, max: frame.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y:self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "badguy_FINAL")
        enemy.name = "Enemy"
        enemy.setScale(0.4)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Blaster
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.5)
        let deleteEnemy = SKAction.removeFromParent()
        let decrementScore = SKAction.run(subtractScore)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, decrementScore])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        let amtRotate = atan2(dy, dx)
        
        enemy.zRotation = amtRotate
    }
    
    func spawnUpgradeCube(){
        //let randomXStart = random(min: frame.minX, max: frame.maxX)
        //let randomXEnd = random(min: frame.minX, max: frame.maxX)
        
        let startPoint = CGPoint(x: self.size.width / 2, y:self.size.height * 1.2)
        let endPoint = CGPoint(x: self.size.width / 2, y: -self.size.height * 0.2)
        
        let upgradeCube = SKSpriteNode(imageNamed: "upgradeCube")
        upgradeCube.name = "UpgradeCube"
        upgradeCube.setScale(0.75)
        upgradeCube.position = startPoint
        upgradeCube.zPosition = 3
        upgradeCube.physicsBody = SKPhysicsBody(rectangleOf: upgradeCube.frame.size)
        upgradeCube.physicsBody!.affectedByGravity = false
        upgradeCube.physicsBody!.categoryBitMask = PhysicsCategories.UpgradeCube
        upgradeCube.physicsBody!.collisionBitMask = PhysicsCategories.None
        upgradeCube.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(upgradeCube)
        
        let moveUpgradeCube = SKAction.move(to: endPoint, duration: 6)
        let deleteUpgradeCube = SKAction.removeFromParent()
        let upgradeSeq = SKAction.sequence([moveUpgradeCube, deleteUpgradeCube])
        upgradeCube.run(upgradeSeq)
        
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
        
        if currentWeapon == weaponsUpgrade.upgradeBlaster{
            triBlaster()
        }
        else {
            fireBlaster()
        }
        
    }
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        if let player = childNode(withName: ShipName) as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.05 {
                    player.physicsBody!.applyImpulse(CGVector(dx: 250 * CGFloat(data.acceleration.x), dy: 0))
                }
                if fabs(data.acceleration.y) > 0.05 {
                    player.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250 * CGFloat(data.acceleration.y)))
                }
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        processUserMotion(forUpdate: currentTime)
        
    }
}
