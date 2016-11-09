//
//  CatNode.swift
//  CatNap
//
//  Created by Amy Joscelyn on 11/9/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit

class CatNode: SKSpriteNode, EventListenerNode
{
    func didMoveToScene()
    {
        print("cat added to scene")
    }
}
