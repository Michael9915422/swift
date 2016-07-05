//
//  playScene1.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/4.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

class playBegin: SKScene,SKPhysicsContactDelegate {
    
    let main = SKSpriteNode(imageNamed: "tab_settings")
    let start = SKSpriteNode(imageNamed: "LEVEL")
    let runningRock = SKSpriteNode(imageNamed: "b02")
    var player = SKSpriteNode(imageNamed: "nick3.png")
    let warning = SKSpriteNode(imageNamed: "warning")
    let stop_action = SKAction.removeFromParent()
    let square = SKSpriteNode(imageNamed: "square01")
    let graySquare = SKSpriteNode(imageNamed: "graySquare")
    var arrPoint  = [ESquare]()
    var currIndex = 28
    var obstacleIndex = 0
    var quantity = 4
    var isFind = false
    var stepNum = 0
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    var DurationSpeedUP = 4.0
    
    
    enum CollideType:UInt32{
        case player = 1
        case missile = 2
        case rock = 3
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.contactDelegate = self
        let backgroundMusic = SKAudioNode(fileNamed: "Shakira - Try Everything (Official Video).mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        mapDesign()
        start_game()
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        
        
        main.xScale = 0.2
        main.yScale = 0.2
        main.position = CGPointMake(CGRectGetMidX(self.frame)*1.75, CGRectGetMidY(self.frame)*0.25)
        
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({self.randomObstacleQuantity()}),SKAction.waitForDuration(DurationSpeedUP)])))
        
        player.xScale = 0.5
        player.yScale = 0.5
        
        player.position = arrPoint[28].position
        player.physicsBody = SKPhysicsBody(rectangleOfSize: self.player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = CollideType.player.rawValue
        player.physicsBody?.contactTestBitMask =  CollideType.rock.rawValue
        player.physicsBody?.collisionBitMask = 0
        
        //player.physicsBody?.usesPreciseCollisionDetection = true
        
        
        player.zPosition = 20
        //runningRock.zPosition = 20
        main.zPosition = 30
        
        self.addChild(player)
        //self.addChild(runningRock)
        self.addChild(main)
        //self.addChild(start)
        
    }
    
    func start_game(){
        if score == 0 {
            start.xScale = 1.2
            start.yScale = 1.2
            start.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            start.zPosition = 40
        
            let fade_in = SKAction.fadeInWithDuration(3)
            let fade_out = SKAction.fadeOutWithDuration(1)
            
            start.runAction(SKAction.sequence([fade_in,fade_out,SKAction.waitForDuration(1)]))
            self.addChild(start)
            
        }
    
    }
    
    func mapDesign() {
        for i in 0...63{
            let point = ESquare(texture: square.texture)
            point.size.height = self.frame.size.height / 4
            point.size.width = self.frame.size.height / 4
            let row = Int(i/8)
            let col = i%8
            let width = Int(square.size.width / 2.65)
            //let width = Int(square.size.width/3)
            let x = col * (width+4) - (2*width)
            let y = row * (width+4) - (2*width) - 20
            point.position = CGPointMake(CGRectGetMidX(self.frame)*0.75+CGFloat(x), CGRectGetMidY(self.frame)/1.5+CGFloat(y))
            if row == 0 || row == 7 || col == 0 || col == 7{
                point.isEdge = true
                point.texture = graySquare.texture
                point.xScale = 0.9
                point.yScale = 0.9
            }
            //四個角落先不算Edge
                        if i == 0 || i == 7 || i == 56 || i == 63{
                            point.isEdge = false
                        }
            point.index = i
            point.zPosition = 10 //放在最底層
            self.addChild(point)
            arrPoint.append(point)
        }
        
        
    }
    
    
    func roleDidCollideWithObstacle(runningstone:SKSpriteNode,player:SKSpriteNode){
        print("Hit")
        runningRock.removeFromParent()
        if score >= 5 {
            let Level2 = playScene1(size:self.size)
            let skview = self.view! as SKView
            skview.ignoresSiblingOrder = true
            skview.presentScene(Level2)
        }else {
            
            died()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //player.texture = SKTexture(imageNamed: "nick2.png")
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 3 {
            roleDidCollideWithObstacle(secondBody.node as! SKSpriteNode, player: firstBody.node as! SKSpriteNode)
        }

    }
    
    func died(){
        let gameover = GameOverScene(size:self.size,score: score)
        let skview = self.view! as SKView
        skview.ignoresSiblingOrder = true
        skview.presentScene(gameover)
    }
    
    func randomObstacleQuantity(){
        quantity = (Int(arc4random()) % 5) + 1
        for i in 1...quantity {
            randomObstacleIndex()
        }
        score++
    }
    
    func randomObstacleIndex(){
        obstacleIndex = (Int(arc4random()) % 64)
        if arrPoint[obstacleIndex].isEdge == false{
            randomObstacleIndex()
        }else{
            if (0 < obstacleIndex) && obstacleIndex < 7 {
                add_bottom_rock()
            }
            else if (obstacleIndex % 8) == 0 {
                add_left_rock()
            }
            else if (obstacleIndex % 8 ) == 7 {
                add_right_rock()
            }
            else if (56 < obstacleIndex) && (obstacleIndex < 63) {
                add_top_rock()
            }
            else {randomObstacleIndex()}
        }

    }
    
    
    //從右邊新增隨機的石頭
    func add_right_rock() {
        let runningRock = SKSpriteNode(imageNamed: "b02")
        let light = SKSpriteNode(imageNamed: "warning")
        runningRock.xScale = 0.52
        runningRock.yScale = 0.5
        light.xScale = 0.6
        light.yScale = 0.6
        
        runningRock.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(runningRock)
        self.addChild(light)
        runningRock.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.runningRock.size.width / 8))
        runningRock.physicsBody?.dynamic = true
        runningRock.physicsBody?.affectedByGravity = false
        runningRock.physicsBody!.categoryBitMask = CollideType.rock.rawValue
        runningRock.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        runningRock.physicsBody?.collisionBitMask = 0
        
        
        runningRock.speed = 1.5
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        let minDuration = 2.0
        let maxDuration = 3.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.5)
        let action = SKAction.moveTo(arrPoint[obstacleIndex-7].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( runningRock.removeFromParent )
        runningRock.runAction(SKAction.repeatActionForever(rotate))
        //runningRock.runAction(SKAction.sequence([action,actoin_done]))
        runningRock.zPosition = 20
        light.zPosition = 30
        runAction(SKAction.sequence([SKAction.runBlock({light.runAction(blink3times)}),SKAction.waitForDuration(2),SKAction.runBlock({runningRock.runAction(SKAction.sequence([action,actoin_done]))})]))
        
    }
    func add_top_rock() {
        let runningRock = SKSpriteNode(imageNamed: "b02")
        let light = SKSpriteNode(imageNamed: "warning2")
        runningRock.xScale = 0.52
        runningRock.yScale = 0.5
        light.xScale = 0.6
        light.yScale = 0.6
        
        runningRock.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(runningRock)
        self.addChild(light)
        runningRock.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.runningRock.size.width / 8))
        runningRock.physicsBody?.dynamic = true
        runningRock.physicsBody?.affectedByGravity = false
        runningRock.physicsBody!.categoryBitMask = CollideType.rock.rawValue
        runningRock.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        runningRock.physicsBody?.collisionBitMask = 0
        
        
        runningRock.speed = 1.5
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        let minDuration = 2.0
        let maxDuration = 3.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.5)
        let action = SKAction.moveTo(arrPoint[obstacleIndex-56].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( runningRock.removeFromParent )
        runningRock.runAction(SKAction.repeatActionForever(rotate))
        //runningRock.runAction(SKAction.sequence([action,actoin_done]))
        runningRock.zPosition = 20
        light.zPosition = 30
        runAction(SKAction.sequence([SKAction.runBlock({light.runAction(blink3times)}),SKAction.waitForDuration(2),SKAction.runBlock({runningRock.runAction(SKAction.sequence([action,actoin_done]))})]))
        
    }
    func add_left_rock() {
        let runningRock = SKSpriteNode(imageNamed: "b02")
        let light = SKSpriteNode(imageNamed: "warning3")
        runningRock.xScale = 0.52
        runningRock.yScale = 0.5
        light.xScale = 0.6
        light.yScale = 0.6
        
        runningRock.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(runningRock)
        self.addChild(light)
        runningRock.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.runningRock.size.width / 8))
        runningRock.physicsBody?.dynamic = true
        runningRock.physicsBody?.affectedByGravity = false
        runningRock.physicsBody!.categoryBitMask = CollideType.rock.rawValue
        runningRock.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        runningRock.physicsBody?.collisionBitMask = 0
        
        
        runningRock.speed = 1.5
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        let minDuration = 2.0
        let maxDuration = 3.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.5)
        let action = SKAction.moveTo(arrPoint[obstacleIndex+7].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( runningRock.removeFromParent )
        runningRock.runAction(SKAction.repeatActionForever(rotate))
        //runningRock.runAction(SKAction.sequence([action,actoin_done]))
        runningRock.zPosition = 20
        light.zPosition = 30
        runAction(SKAction.sequence([SKAction.runBlock({light.runAction(blink3times)}),SKAction.waitForDuration(2),SKAction.runBlock({runningRock.runAction(SKAction.sequence([action,actoin_done]))})]))
        
    }
    func add_bottom_rock() {
        let runningRock = SKSpriteNode(imageNamed: "b02")
        let light = SKSpriteNode(imageNamed: "warning4")
        runningRock.xScale = 0.52
        runningRock.yScale = 0.5
        light.xScale = 0.6
        light.yScale = 0.6
        
        runningRock.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(runningRock)
        self.addChild(light)
        runningRock.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.runningRock.size.width / 8))
        runningRock.physicsBody?.dynamic = true
        runningRock.physicsBody?.affectedByGravity = false
        runningRock.physicsBody!.categoryBitMask = CollideType.rock.rawValue
        runningRock.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        runningRock.physicsBody?.collisionBitMask = 0
        
        
        runningRock.speed = 1.5
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        let minDuration = 2.0
        let maxDuration = 3.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.5)
        let action = SKAction.moveTo(arrPoint[obstacleIndex+56].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( runningRock.removeFromParent )
        runningRock.runAction(SKAction.repeatActionForever(rotate))
        //runningRock.runAction(SKAction.sequence([action,actoin_done]))
        runningRock.zPosition = 20
        light.zPosition = 30
        runAction(SKAction.sequence([SKAction.runBlock({light.runAction(blink3times)}),SKAction.waitForDuration(2),SKAction.runBlock({runningRock.runAction(SKAction.sequence([action,actoin_done]))})]))
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("swiped right")
        currIndex = currIndex + 1
        if !isEdge(currIndex){
            player.position = arrPoint[currIndex].position
        }else{
            currIndex = currIndex - 1
        }
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swiped left")
        currIndex = currIndex - 1
        if !isEdge(currIndex){
            player.position = arrPoint[currIndex].position
        }else{
            currIndex = currIndex + 1
        }
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        print("swiped up")
        currIndex = currIndex + 8
        if !isEdge(currIndex){
            player.position = arrPoint[currIndex].position
        }else{
            currIndex = currIndex - 8
        }
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        print("swiped down")
        currIndex = currIndex - 8
        if !isEdge(currIndex){
            player.position = arrPoint[currIndex].position
        }else{
            currIndex = currIndex + 8
        }
        
    }
    
    func isEdge(currIndex:Int) -> Bool{
        if arrPoint[currIndex].isEdge == true{
            return true
        }else{
            return false
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.main
            {
                print("Back to the main")
                let mainScene = GameScene(size:self.size)
                let skview = self.view! as SKView
                skview.ignoresSiblingOrder = true
                skview.presentScene(mainScene)
            }
            
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        //score = Int(score / 10)
        if( (score%2) == 0){
            DurationSpeedUP = DurationSpeedUP - 0.3
            runningRock.speed = runningRock.speed + 0.5
            if DurationSpeedUP < 0.5 {
                DurationSpeedUP = 0.5
            }
           
        }
    }
    
}
