//
//  GameOverScene.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/7.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let main = SKSpriteNode(imageNamed: "MainMenu")
    let retry = SKSpriteNode(imageNamed: "Retry")
    let scoreText = SKLabelNode(fontNamed: "Chalkduster")
    init(size:CGSize,score:Int){
        super.init(size:size)
        backgroundColor = UIColor.blackColor()
        self.scoreText.text = "Score: "+String(score)
        print("score \(score)")
        self.scoreText.fontSize = 48
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        scoreText.zPosition = 20
        main.xScale = 0.5
        main.yScale = 0.5
        retry.xScale = 0.5
        retry.yScale = 0.5
        main.position = CGPointMake(CGRectGetMidX(self.frame)*1.5,CGRectGetMidY(self.frame)/2)
        retry.position = CGPointMake(CGRectGetMidX(self.frame)*0.5,CGRectGetMidY(self.frame)/2)
        self.addChild(main)
        self.addChild(retry)
        self.addChild(scoreText)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.retry
            {
                print("Start the game1")
                let start_game = playBegin(size:self.size)
                let skview = self.view! as SKView
                skview.ignoresSiblingOrder = true
                skview.presentScene(start_game)
            }
            if self.nodeAtPoint(location) == self.main
            {
                print("Main Menu~")
                let back = GameScene(size:self.size)
                let skview = self.view! as SKView
                skview.ignoresSiblingOrder = true
                skview.presentScene(back)
            }
            
        }
    }
}
