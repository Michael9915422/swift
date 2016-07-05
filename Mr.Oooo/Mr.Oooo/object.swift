//
//  object.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/9.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

class object: SKSpriteNode {
    let runningstone = SKSpriteNode(imageNamed: "stone")
    let missile = SKSpriteNode(imageNamed: "missile01")
    let missile2 = SKSpriteNode(imageNamed: "missile02")
    let missile3 = SKSpriteNode(imageNamed: "missile03")
    let missile4 = SKSpriteNode(imageNamed: "missile04")
    let warning = SKSpriteNode(imageNamed: "warning")
    var obstacleIndex = 0
    var quantity = 4
}
