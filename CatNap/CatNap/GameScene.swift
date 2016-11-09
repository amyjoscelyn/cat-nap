//
//  GameScene.swift
//  CatNap
//
//  Created by Amy Joscelyn on 11/8/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory
{
    static let None:    UInt32 = 0
    static let Cat:     UInt32 = 0b1 // 1 in binary
    static let Block:   UInt32 = 0b10 // 2
    static let Bed:     UInt32 = 0b100 // 4
    static let Edge:    UInt32 = 0b1000 // 8
    static let Label:   UInt32 = 0b10000 // 16
}

protocol EventListenerNode
{
    func didMoveToScene()
}

protocol InteractiveNode
{
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var bedNode: BedNode!
    var catNode: CatNode!
    var playable = true
    
    override func didMove(to view: SKView)
    {
        // Calculate playable margin
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height - maxAspectRatioHeight) / 2
        
        let playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: size.height - playableMargin * 2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
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
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if !playable { return }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed
        {
            print("SUCCESS")
            win()
        }
        else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge
        {
            print("FAIL")
            lose()
        }
    }
    
    func inGameMessage(text: String)
    {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    func newGame()
    {
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = scaleMode
        view!.presentScene(scene)
    }
    
    func lose()
    {
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        
        inGameMessage(text: "Try again...")
        
        perform(#selector(newGame), with: nil, afterDelay: 5)
        
        catNode.wakeUp()
    }
    
    func win()
    {
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice job!")
        
        perform(#selector(GameScene.newGame), with: nil, afterDelay: 3)
        
        catNode.curlAt(scenePoint: bedNode.position)
    }
}
