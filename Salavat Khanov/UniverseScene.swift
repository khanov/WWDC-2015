//
//  UniverseScene.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/23/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import SpriteKit

class UniverseScene: SKScene {
    
    var touchDelegate: UniverseSceneDelegate?
    
    override func didMoveToView(view: SKView) {
        for childNode in scene!.children as! [SKShapeNode] {            
            let width = childNode.frame.size.width
            let radius = width/2
            
            childNode.path = CGPathCreateWithRoundedRect(CGRectMake(-radius, -radius, width, width), radius, radius, nil)
            childNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            childNode.physicsBody?.restitution = 0.8
        }
    }
   
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as? UITouch
        let location = touch?.locationInNode(self)
        let node = self.nodeAtPoint(location!)
        
        if node.name == nil || touch == nil {
            return
        }
        
        switch node.name! {
        case "AboutShape", "AboutLabel":
            touchDelegate?.scene(self, didPressAboutButtonWithTouch: touch!)
        case "WorkShape", "WorkLabel":
            touchDelegate?.scene(self, didPressWorkButtonWithTouch: touch!)
        case "ProjectsShape", "ProjectsLabel":
            touchDelegate?.scene(self, didPressProjectsButtonWithTouch: touch!)
        default:
            break
        }
    }
    
}

protocol UniverseSceneDelegate {
    func scene(scene: UniverseScene, didPressAboutButtonWithTouch touch: UITouch)
    func scene(scene: UniverseScene, didPressWorkButtonWithTouch touch: UITouch)
    func scene(scene: UniverseScene, didPressProjectsButtonWithTouch touch: UITouch)
}
