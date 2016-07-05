//
//  playScene1.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/4.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

class playScene_2: SKScene,SKPhysicsContactDelegate {
    
    let main = SKSpriteNode(imageNamed: "tab_settings")
    let runningRock = SKSpriteNode(imageNamed: "stone")
    var player = SKSpriteNode(imageNamed: "nick3.png")
    let warning = SKSpriteNode(imageNamed: "warning")
    let stop_action = SKAction.removeFromParent()
    let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
    let square = SKSpriteNode(imageNamed: "square01")
    let graySquare = SKSpriteNode(imageNamed: "graySquare")
    var arrPoint  = [ESquare]()
    let startIndex = 30
    var currIndex = 30
    var obstacleIndex = 0
    var quantity = 4
    var isFind = false
    var stepNum = 0
    var x:Int = 0
    var y:Int = 0
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    var DurationSpeedUP = 2.0
    
    
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
        
        for _ in 1...quantity{
            
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([SKAction.runBlock({self.randomObstacleIndex()}),SKAction.runBlock({self.Light()}),SKAction.waitForDuration(2),SKAction.runBlock({self.add_right_rock() }),SKAction.waitForDuration(DurationSpeedUP) ])))
            
        }
//        for _ in 1...quantity{
//            
//            runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock{self.randomObstacleIndex()},SKAction.runBlock{self.add_left_rock()},SKAction.waitForDuration(DurationSpeedUP)])))
//        }
        
        randomObstacleQuantity()
        player.xScale = 0.5
        player.yScale = 0.5
        
        player.position = arrPoint[30].position
        player.physicsBody = SKPhysicsBody(rectangleOfSize: self.player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.categoryBitMask = CollideType.player.rawValue
        player.physicsBody?.contactTestBitMask =  CollideType.rock.rawValue
        //player.physicsBody?.usesPreciseCollisionDetection = true
        
//        runningstone.xScale = 0.25
//        runningstone.yScale = 0.26
//        
//        runningstone.position = CGPointMake(CGRectGetMidX(self.frame)*1.5, CGRectGetMidY(self.frame)*1.5)
//        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
//        let action2 = SKAction.moveToX(CGRectGetMidY(self.frame)*0.25, duration: 1)
//        runningstone.speed = 0.5
//        runningstone.runAction(SKAction.sequence([action,action2,stop_action]))
//        //missile.runAction(SKAction.sequence([action2,stop_action]))
        
        
        player.zPosition = 20
        runningRock.zPosition = 20
        main.zPosition = 30

        self.addChild(player)
        self.addChild(runningRock)
        self.addChild(main)
        
    }
    
    func mapDesign() {
        for i in 0...63{
            let point = ESquare(texture: square.texture)
            point.xScale = 0.8
            point.yScale = 0.8
            let row = Int(i/8)
            let col = i%8
            let width = Int(square.size.width / 2.65)
            //let width = 0
            let x = col * (width+4) - (2*width)
            let y = row * (width+4) - (2*width) - 5
            point.position = CGPointMake(CGRectGetMidX(self.frame)*0.75+CGFloat(x), CGRectGetMidY(self.frame)/1.5+CGFloat(y))
            if row == 0 || row == 7 || col == 0 || col == 7{
                point.isEdge = true
                point.texture = graySquare.texture
                point.xScale = 0.8
                point.yScale = 0.8
            }
            //四個角落先不算Edge
            //            if i == 0 || i == 7 || i == 56 || i == 63{
            //                point.isEdge = false
            //            }
            point.index = i
            point.zPosition = 10 //放在最底層
            self.addChild(point)
            arrPoint.append(point)
        }
        
        
    }
    
    
    func roleDidCollideWithObstacle(){
        print("Hit\n")
        runningRock.removeFromParent()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        player.texture = SKTexture(imageNamed: "nick2.png")
        runAction(SKAction.waitForDuration(3))
        //died()//不知道是哪個物件碰撞到所以error
    }
    
    func died(){
        let gameover = GameOverScene(size:self.size,score: score)
        let skview = self.view! as SKView
        skview.ignoresSiblingOrder = true
        skview.presentScene(gameover)
    }
    
    func randomObstacleQuantity(){
        quantity = (Int(arc4random()) % 4) + 1
    }
    
    func randomObstacleIndex(){
        obstacleIndex = (Int(arc4random()) % 64)
        if arrPoint[obstacleIndex].isEdge == false{
            if (obstacleIndex%8 == 7){
                
            }else{
                obstacleIndex = obstacleIndex + (7 - (obstacleIndex%8))
            }
        }else{
            randomObstacleIndex()
        }
    }
    
    //警告閃爍動畫
    func Light() {
        let light = SKSpriteNode(imageNamed: "warning")
        light.xScale = 0.6
        light.yScale = 0.6
        
        light.position = arrPoint[obstacleIndex].position
        self.addChild(light)
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)//閃爍3次
        light.runAction(blink3times)
        light.zPosition = 20
    }
    
    
    
    //從右邊新增隨機的石頭
    func add_right_rock() {
        let runningRock = SKSpriteNode(imageNamed: "stone")
        runningRock.xScale = 0.3
        runningRock.yScale = 0.33
        
       runningRock.position = arrPoint[obstacleIndex].position
        self.addChild(runningRock)
        
        runningRock.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.runningRock.size.width / 4))
        runningRock.physicsBody?.dynamic = true
        runningRock.physicsBody?.affectedByGravity = false
        runningRock.physicsBody!.categoryBitMask = CollideType.rock.rawValue
        runningRock.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        runningRock.physicsBody?.collisionBitMask = 0
        
        
        runningRock.speed = 1.0
        
        let minDuration = 2.0
        let maxDuration = 3.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.5)
        let action = SKAction.moveTo(arrPoint[obstacleIndex-7].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( runningRock.removeFromParent )
        runningRock.runAction(SKAction.repeatActionForever(rotate))
        runningRock.runAction(SKAction.sequence([action,actoin_done]))
        runningRock.zPosition = 20
        
    }
    
//    func add_left_rock() {
//        let missile3 = SKSpriteNode(imageNamed: "missile03")
//        let light = SKSpriteNode(imageNamed: "warning")
//        light.xScale = 0.6
//        light.yScale = 0.6
//        light.zRotation = CGFloat(M_PI)
//        //light.runAction(SKAction.rotateToAngle(CGFloat(M_PI), duration: 0.5))
//        missile3.xScale = 0.5
//        missile3.yScale = 0.4
//        
//        missile3.position = arrPoint[obstacleIndex-7].position
//        light.position = arrPoint[obstacleIndex-7].position
//        
//        
//        self.addChild(light)
//        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
//        let blink3times = SKAction.repeatAction(blink, count: 3)//閃爍3次
//        light.runAction(blink3times)
//        
//        missile3.physicsBody = SKPhysicsBody(rectangleOfSize: missile3.size)
//        missile3.physicsBody?.dynamic = true //2
//        missile3.physicsBody?.affectedByGravity = false
//        missile3.physicsBody!.categoryBitMask = CollideType.missile.rawValue
//        missile3.physicsBody!.contactTestBitMask = CollideType.player.rawValue
//        missile3.physicsBody?.collisionBitMask = 0
//        
//        light.zPosition = 20
//        missile3.zPosition = 20
//        missile3.speed = 3
//        
//        let minDuration = 2.0
//        let maxDuration = 4.0
//        let duration_range = maxDuration - minDuration
//        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
//        
//        let action = SKAction.moveTo(arrPoint[obstacleIndex].position, duration: actualDuration)
//        let action_done = SKAction.runBlock( missile3.removeFromParent )
//        //missile.runAction(SKAction.sequence([action,action_done]))
//        runAction(SKAction.sequence([SKAction.runBlock{light.runAction(blink3times)},SKAction.waitForDuration(2),SKAction.runBlock{missile3.runAction(SKAction.sequence([action,action_done]))}]))
//        self.addChild(missile3)
//    }
    
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
        score++
        //score = Int(score / 10)
        if( (score%10) == 0){
            DurationSpeedUP = DurationSpeedUP - 0.3
            if DurationSpeedUP < 0.5 {
                DurationSpeedUP = 0.5
            }
        }
    }
    
}
