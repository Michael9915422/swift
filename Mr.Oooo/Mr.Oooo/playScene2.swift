//
//  playScene2.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/4.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

class playScene2: SKScene {

    let main = SKSpriteNode(imageNamed: "tab_settings")
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        main.xScale = 0.2
        main.yScale = 0.2
       
        main.position = CGPointMake(CGRectGetMidX(self.frame)*1.75, CGRectGetMidY(self.frame)*0.25)
        
        self.addChild(main)
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
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            sprite.runAction(SKAction.repeatActionForever(action))
            self.addChild(sprite)
            
            
        }
    }

}
