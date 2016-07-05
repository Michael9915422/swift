//
//  playScene1.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/4.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

class playScene1: SKScene,SKPhysicsContactDelegate {
    
    let main = SKSpriteNode(imageNamed: "tab_settings")
    let start = SKSpriteNode(imageNamed: "LEVEL2")
    let runningstone = SKSpriteNode(imageNamed: "stone")
    let missile = SKSpriteNode(imageNamed: "missile01")
    let missile2 = SKSpriteNode(imageNamed: "missile02")
    let missile3 = SKSpriteNode(imageNamed: "missile03")
    let missile4 = SKSpriteNode(imageNamed: "missile04")
    let icecream = SKSpriteNode(imageNamed: "Icecream")
    var player = SKSpriteNode(imageNamed: "nick3.png")
    let warning = SKSpriteNode(imageNamed: "warning")
    let stop_action = SKAction.removeFromParent()
    let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
    let square = SKSpriteNode(imageNamed: "square01")
    let graySquare = SKSpriteNode(imageNamed: "graySquare")
    var arrPoint  = [ESquare]()
    var currIndex = 28
    var obstacleIndex = 0
    var icecream_index = 0
    var quantity = 4
    var isFind = false
    var stepNum = 0
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    var score = 0
    var DurationSpeedUP = 4.0
    
    
    enum CollideType:UInt32{
        case player = 1
        case missile = 2
        case runningstone = 3
        case icecream = 4
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor = UIColor.blackColor()
        self.physicsWorld.contactDelegate = self
        let backgroundMusic = SKAudioNode(fileNamed: "one-direction-made-in-the-a-m-drag-me-down[songsx.pk].mp3")
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
        //player.position = CGPointMake(CGRectGetMidX(self.frame)*0.25, CGRectGetMidY(self.frame)*1.25)
        player.position = arrPoint[28].position
        player.physicsBody = SKPhysicsBody(rectangleOfSize: self.player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.categoryBitMask = CollideType.player.rawValue
        player.physicsBody?.contactTestBitMask = CollideType.missile.rawValue

        
       
        player.zPosition = 20
        runningstone.zPosition = 20
        main.zPosition = 30
        //self.addChild(warning)
        self.addChild(player)
        //self.addChild(missile)
        self.addChild(runningstone)
        self.addChild(main)
        
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
            point.xScale = 0.7
            point.yScale = 0.7
            let row = Int(i/8)
            let col = i%8
            let width = Int(square.size.width / 2.65)
            //let width = 0
            let x = col * (width+4) - (2*width)
            let y = row * (width+4) - (2*width) - 20
            point.position = CGPointMake(CGRectGetMidX(self.frame)*0.75+CGFloat(x), CGRectGetMidY(self.frame)/1.5+CGFloat(y))
            if row == 0 || row == 7 || col == 0 || col == 7{
                point.isEdge = true
                point.texture = graySquare.texture
                point.xScale = 0.7
                point.yScale = 0.7
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
    
    
    func roleDidCollideWithObstacle(missile:SKSpriteNode,player:SKSpriteNode){
        print("Hit")
        missile.removeFromParent()
        let action = SKAction.runBlock({player.texture = SKTexture(imageNamed: "nick2-2")})
        let die = SKAction.runBlock({self.died()})
        runAction(SKAction.sequence([action,SKAction.waitForDuration(1.5),die]))
        
    }
    
    func original_player(){
        player.texture = SKTexture(imageNamed: "nick3")
        player.physicsBody = SKPhysicsBody(rectangleOfSize: self.player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = CollideType.player.rawValue
        player.physicsBody?.contactTestBitMask =  CollideType.missile.rawValue
        player.physicsBody?.collisionBitMask = 0

    }
    
    func PlyerGetUnbrokenStatus(icecream:SKSpriteNode,player:SKSpriteNode){
        print("blin-blin")
        icecream.removeFromParent()
        let begin = SKAction.runBlock({player.texture = SKTexture(imageNamed: "nick1")})
       
        let action = SKAction.runBlock({ player.physicsBody = nil})
//        let change_face = SKAction.sequence([SKAction.runBlock({player.texture = SKTexture(imageNamed: "nick1")}),SKAction.waitForDuration(3),SKAction.runBlock({player.texture = SKTexture(imageNamed: "nick2")})])
        let end = SKAction.runBlock({self.original_player()})
        let action2 = SKAction.runBlock({player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)})
        runAction(SKAction.sequence([begin,action,SKAction.waitForDuration(5),action2,end]))
        
           }
    
    func didBeginContact(contact: SKPhysicsContact) {
 
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == 1) && (secondBody.categoryBitMask == 2) {
            roleDidCollideWithObstacle(secondBody.node as! SKSpriteNode, player: firstBody.node as! SKSpriteNode)
        }
        if (firstBody.categoryBitMask == 1) && (secondBody.categoryBitMask == 4) {
            PlyerGetUnbrokenStatus(secondBody.node as! SKSpriteNode, player: firstBody.node as! SKSpriteNode)
        }
    }
    
    func died(){
        let gameover = GameOverScene(size:self.size,score: score)
        let skview = (self.view)! as SKView
        skview.ignoresSiblingOrder = true
        skview.presentScene(gameover)
    }
    
    func randomObstacleQuantity(){
        quantity = (Int(arc4random()) % 5) + 1
        for i in 1...quantity {
            randomObstacleIndex()
        }
        score++
        if ((score % 2) == 0){
            print("Ice-cream")
            randomIcecreamIndex()
            runAction(SKAction.sequence([SKAction.runBlock({self.unbroken()})]))
            
        }
    }
    
    func randomIcecreamIndex(){
        var x = (Int(arc4random()) % 63)
        if(arrPoint[x].isEdge == true){
            randomIcecreamIndex()
        }else{
            if x == 0 || x == 7 || x == 56 || x == 63{
                randomIcecreamIndex()
            }else{
                icecream_index = x
            }
        }
        
    }
    
    func randomObstacleIndex(){
       obstacleIndex = (Int(arc4random()) % 64)
        if arrPoint[obstacleIndex].isEdge == false{
           randomObstacleIndex()
        }else{
            if (0 < obstacleIndex) && obstacleIndex < 7 {
                add_bottom_Missile()
            }
            else if (obstacleIndex % 8) == 0 {
                add_left_Missile()
            }
            else if (obstacleIndex % 8 ) == 7 {
                add_right_Missile()
            }
            else if (56 < obstacleIndex) && (obstacleIndex < 63) {
                add_top_Missile()
            }
            else {randomObstacleIndex()}
        }
    }
    
        //從右邊新增隨機的飛彈
    func add_right_Missile() {
        let missile = SKSpriteNode(imageNamed: "missile01")
        let light = SKSpriteNode(imageNamed: "warning")
        missile.xScale = 0.5
        missile.yScale = 0.4
        light.xScale = 0.6
        light.yScale = 0.6
        
        missile.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(missile)
        self.addChild(light)
        print("\(obstacleIndex)")
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        missile.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(0.1), center: CGPointMake(CGRectGetMaxX(self.missile.frame)*0.9, CGRectGetMidY(self.missile.frame)))
        missile.physicsBody?.dynamic = true
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = CollideType.missile.rawValue
        missile.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        missile.physicsBody?.collisionBitMask = 0
        
        missile.zPosition = 20
        light.zPosition = 30
        missile.speed = 3.5
        
        let minDuration = 2.0
        let maxDuration = 3.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let action = SKAction.moveTo(arrPoint[obstacleIndex-7].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( missile.removeFromParent )
        
        
        runAction(SKAction.sequence([SKAction.runBlock({light.runAction(blink3times)}),SKAction.waitForDuration(2),SKAction.runBlock({missile.runAction(SKAction.sequence([action,actoin_done]))})]))
    
    }
    
    func add_top_Missile() {
        let missile = SKSpriteNode(imageNamed: "missile02")
        let light = SKSpriteNode(imageNamed: "warning2")
        missile.xScale = 0.4
        missile.yScale = 0.5
        light.xScale = 0.6
        light.yScale = 0.6
        
        missile.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(missile)
        self.addChild(light)
        print("\(obstacleIndex)")
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.size)
        missile.physicsBody?.dynamic = true //2
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = CollideType.missile.rawValue
        missile.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        missile.physicsBody?.collisionBitMask = 0
        
        light.zPosition = 30
        missile.zPosition = 20
        missile.speed = 3.5
        
        let minDuration = 2.0
        let maxDuration = 4.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let action = SKAction.moveTo(arrPoint[obstacleIndex-56].position, duration: actualDuration)
        let actoin_done = SKAction.runBlock( missile.removeFromParent )
        let playSound = SKAction.playSoundFileNamed("", waitForCompletion: false)
        //missile.runAction(SKAction.sequence([action,actoin_done]))
        runAction(SKAction.sequence([SKAction.runBlock({light.runAction(blink3times)}),SKAction.waitForDuration(2),SKAction.runBlock({missile.runAction(SKAction.sequence([action,actoin_done]))})]))
        
    }
   
    //無敵狀態
    func unbroken(){
        let icecream = SKSpriteNode(imageNamed: "Icecream")
        icecream.xScale = 0.125
        icecream.yScale = 0.125
        
        icecream.position = arrPoint[icecream_index].position
        //icecream.position = arrPoint[28].position
        icecream.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(icecream.size.width/4))
        icecream.physicsBody?.dynamic = false
        icecream.physicsBody?.affectedByGravity = false
        icecream.physicsBody!.categoryBitMask = CollideType.icecream.rawValue
        icecream.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        icecream.physicsBody?.collisionBitMask = 0
        
        icecream.zPosition = 30
        self.addChild(icecream)
        runAction(SKAction.sequence([SKAction.waitForDuration(3),SKAction.runBlock({icecream.removeFromParent()})]))
    }
    
    func add_left_Missile() {
        let missile = SKSpriteNode(imageNamed: "missile03")
        let light = SKSpriteNode(imageNamed: "warning3")
        light.xScale = 0.6
        light.yScale = 0.6
        
        missile.xScale = 0.5
        missile.yScale = 0.4
        print("\(obstacleIndex)")
        missile.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        
        
        self.addChild(light)
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)//閃爍3次
        light.runAction(blink3times)
        
        missile.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(0.1), center: CGPointMake(CGRectGetMaxX(self.missile.frame)*0.9, CGRectGetMidY(self.missile.frame)))
        missile.physicsBody?.dynamic = true //2
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = CollideType.missile.rawValue
        missile.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        missile.physicsBody?.collisionBitMask = 0
        
        light.zPosition = 30
        missile.zPosition = 20
        missile.speed = 3.5
        
        let minDuration = 2.0
        let maxDuration = 4.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let action = SKAction.moveTo(arrPoint[obstacleIndex+7].position, duration: actualDuration)
        let action_done = SKAction.runBlock( missile.removeFromParent )
        //missile.runAction(SKAction.sequence([action,action_done]))
        runAction(SKAction.sequence([SKAction.runBlock{light.runAction(blink3times)},SKAction.waitForDuration(2),SKAction.runBlock{missile.runAction(SKAction.sequence([action,action_done]))}]))
        self.addChild(missile)
    }

    
    func add_bottom_Missile() {
        let missile = SKSpriteNode(imageNamed: "missile04")
        let light = SKSpriteNode(imageNamed: "warning4")
        missile.xScale = 0.4
        missile.yScale = 0.5
        light.xScale = 0.6
        light.yScale = 0.6
        
        missile.position = arrPoint[obstacleIndex].position
        light.position = arrPoint[obstacleIndex].position
        self.addChild(light)
        self.addChild(missile)
        print("\(obstacleIndex)")
        
        let blink = SKAction.sequence([SKAction.fadeInWithDuration(0.25),SKAction.fadeOutWithDuration(0.25)])
        let blink3times = SKAction.repeatAction(blink, count: 3)
        
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.size)
        missile.physicsBody?.dynamic = true //2
        missile.physicsBody?.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = CollideType.missile.rawValue
        missile.physicsBody!.contactTestBitMask = CollideType.player.rawValue
        missile.physicsBody?.collisionBitMask = 0
        
        light.zPosition = 30
        missile.zPosition = 20
        missile.speed = 3.5
        
        let minDuration = 2.0
        let maxDuration = 4.0
        let duration_range = maxDuration - minDuration
        let actualDuration = ( Double(arc4random() ) % duration_range) + minDuration
        
        let action = SKAction.moveTo(arrPoint[obstacleIndex+56].position, duration: actualDuration)
        let action_done = SKAction.runBlock( missile.removeFromParent )
        //missile.runAction(SKAction.sequence([action,actoin_done]))
        runAction(SKAction.sequence([SKAction.runBlock{light.runAction(blink3times)},SKAction.waitForDuration(2),SKAction.runBlock{missile.runAction(SKAction.sequence([action,action_done]))}]))
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
        if( (score%10) == 0){
            DurationSpeedUP = DurationSpeedUP - 0.3
            if DurationSpeedUP < 1 {
                DurationSpeedUP = 1
            }
        }
    }
    
}
