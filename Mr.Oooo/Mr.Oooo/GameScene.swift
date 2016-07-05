//
//  GameScene.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/4.
//  Copyright (c) 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let start = SKSpriteNode(imageNamed: "START")
    let start2 = SKSpriteNode(imageNamed: "mode01")
    override func didMoveToView(view: SKView) {
        start.xScale = 0.4
        start.yScale = 0.4
        start2.xScale = 0.3
        start2.yScale = 0.3
        self.start.position = CGPointMake(CGRectGetMidX(self.frame)*1.25, CGRectGetMidY(self.frame)*1.5)
        self.start2.position = CGPointMake(CGRectGetMidX(self.frame)*1.25, CGRectGetMidY(self.frame)*0.75)
        self.addChild(start)
        self.addChild(start2)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.start
            {
                print("Start the game")
                let start_game = playBegin(size:self.size)
                let skview = self.view! as SKView
                skview.ignoresSiblingOrder = true
                skview.presentScene(start_game)
            }
            if self.nodeAtPoint(location) == self.start2
            {
                print("Start the game")
                let start_game = playScene2(size:self.size)
                let skview = self.view! as SKView
                skview.ignoresSiblingOrder = true
                skview.presentScene(start_game)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
