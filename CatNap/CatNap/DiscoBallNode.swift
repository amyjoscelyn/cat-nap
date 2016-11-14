//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by Amy Joscelyn on 11/14/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

import SpriteKit
import AVFoundation

class DiscoBallNode: SKSpriteNode, EventListenerNode, InteractiveNode
{
    private var player: AVPlayer!
    private var video: SKVideoNode!
    private var isDiscoTime: Bool = false {
        didSet {
            video.isHidden = !isDiscoTime
            ///up to here
        }
    }
    private let spinAction = SKAction.repeatForever(
        SKAction.animate(with: [
            SKTexture(imageNamed: "discoball1"),
            SKTexture(imageNamed: "discoball2"),
            SKTexture(imageNamed: "discoball3")
            ], timePerFrame: 0.2))
    
    func didMoveToScene()
    {
        isUserInteractionEnabled = true
        
        let fileUrl = Bundle.main.url(forResource: "discolights-loop", withExtension: "mov")
        player = AVPlayer(url: fileUrl!)
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(
            x: scene!.frame.midX,
            y: scene!.frame.midY)
        video.zPosition = -1
        video.alpha = 0.75
        scene!.addChild(video)
        
//        video.play()
        video.isHidden = true
        video.pause()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReachEndOfVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func interact()
    {
        if !isDiscoTime
        {
            isDiscoTime = true
        }
    }
    
    func didReachEndOfVideo()
    {
        print("rewind")
        player.currentItem!.seek(to: kCMTimeZero)
        player.play()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
