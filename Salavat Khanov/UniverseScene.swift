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
    var shouldMarkTouchedNode = true
    
    override func didMoveToView(view: SKView) {
        for childNode in circleNodes {
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
            if shouldMarkTouchedNode {
                circleNode.alpha = 0.35
            }
            touchDelegate?.scene(self, didPressNodeType: nodeType, withTouch: touch, color: circleNode.fillColor)
        } else {
            
            // Push all circles
            for childNode in circleNodes {
                var randomNumber = CGFloat(50 + arc4random() % 100)
                randomNumber *= (randomNumber % 2 == 0) ? 1 : -1
                childNode.physicsBody?.applyImpulse(CGVectorMake(randomNumber, 250))
            }
        }
        
        if allCirclesWereMarkedTouched {
            unmarkTouchedNodes()
            shouldMarkTouchedNode = false
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
    
    func unmarkTouchedNodes() {
        for childNode in circleNodes {
            childNode.alpha = 1.0
        }
    }
    
    var circleNodes: [SKShapeNode] {
        return scene!.children as! [SKShapeNode]
    }
    
    var allCirclesWereMarkedTouched: Bool {
        var result = true
        for childNode in circleNodes {
            if childNode.alpha == 1.0 {
                result = false
            }
        }
        return result
    }
    
}

protocol UniverseSceneDelegate {
    func scene(scene: UniverseScene, didPressNodeType node: NodeType, withTouch touch: UITouch, color: UIColor)
}
