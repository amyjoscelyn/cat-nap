//
//  SpringNode.swift
//  CatNap
//
//  Created by Amy Joscelyn on 11/11/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit

class SpringNode: SKSpriteNode, EventListenerNode, InteractiveNode
{
    func didMoveToScene()
    {
        print("spring added to scene")
        
        isUserInteractionEnabled = true
    }
    
    func interact()
    {
        isUserInteractionEnabled = false
        
        physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250), at: CGPoint(x: size.width / 2, y: size.height))
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.removeFromParent()
            ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
