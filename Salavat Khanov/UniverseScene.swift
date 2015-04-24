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
        let touch = touches.first as! UITouch
        let location = touch.locationInNode(self)
        let node = nodeAtPoint(location)
        
        if let nodeType = findNodeTypeForNode(node), circleNode = circleNodeForNode(node) {
            touchDelegate?.scene(self, didPressNodeType: nodeType, withTouch: touch, color: circleNode.fillColor)
        }
    }
    
    func findNodeTypeForNode(node: SKNode) -> NodeType? {
        if node.name == nil {
            return nil
        }
        if let circleNode = circleNodeForNode(node) {
            return NodeType.findByName(circleNode.name!)
        }
        return nil
    }
    
    func circleNodeForNode(node: SKNode) -> SKShapeNode? {
        // check this node
        if node is SKShapeNode {
            return node as? SKShapeNode
        }
        // not found? check parent
        if node.parent is SKShapeNode {
            return node.parent as? SKShapeNode
        }
        return nil
    }
    
}

protocol UniverseSceneDelegate {
    func scene(scene: UniverseScene, didPressAboutButtonWithTouch touch: UITouch)
    func scene(scene: UniverseScene, didPressWorkButtonWithTouch touch: UITouch)
    func scene(scene: UniverseScene, didPressProjectsButtonWithTouch touch: UITouch)
    func scene(scene: UniverseScene, didPressNodeType node: NodeType, withTouch touch: UITouch, color: UIColor)
}
