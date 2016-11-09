//
//  GameScene.swift
//  CatNap
//
//  Created by Amy Joscelyn on 11/8/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol EventListenerNode
{
    func didMoveToScene()
}

class GameScene: SKScene
{
    var bedNode: BedNode!
    var catNode: CatNode!
    
    override func didMove(to view: SKView)
    {
        // Calculate playable margin
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode
            {
                eventListenerNode.didMoveToScene()
            }
        })
        
        bedNode = childNode(withName: "bed") as! BedNode
        catNode = childNode(withName: "//cat_body") as! CatNode
        
//        bedNode.setScale(1.5)
//        catNode.setScale(1.5)
        
        SKTAudio.sharedInstance()
        .playBackgroundMusic("backgroundMusic.mp3")
    }
}
