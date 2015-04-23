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
   
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: AnyObject? = touches.first
        let location = touch?.locationInNode(self)
        let node = self.nodeAtPoint(location!)
        
        if node.name == nil {
            return
        }
        
        switch node.name! {
        case "AboutShape", "AboutLabel":
            touchDelegate?.sceneDidPressAboutButton(self)
        case "WorkShape", "WorkLabel":
            touchDelegate?.sceneDidPressWorkButton(self)
        case "ProjectsShape", "ProjectsLabel":
            touchDelegate?.sceneDidPressProjectsButton(self)
        default:
            break
        }
    }
    
}

protocol UniverseSceneDelegate {
    func sceneDidPressAboutButton(scene: UniverseScene)
    func sceneDidPressWorkButton(scene: UniverseScene)
    func sceneDidPressProjectsButton(scene: UniverseScene)
}
