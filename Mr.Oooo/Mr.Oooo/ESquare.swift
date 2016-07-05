//
//  ESquare.swift
//  Mr.Oooo
//
//  Created by 馬佳誠 on 2016/6/7.
//  Copyright © 2016年 馬佳誠. All rights reserved.
//

import SpriteKit

enum squaretype : Int{
    case white=0,gray
}

class ESquare: SKSpriteNode {
    //上個點
    var prePointIndex = -1
    //周圍的點
    var arrPoint = [Int]()
    var index = 0
    var isEdge = false
    var prePositionIndex = -1
    var type = squaretype.white
    var step = 99
}
