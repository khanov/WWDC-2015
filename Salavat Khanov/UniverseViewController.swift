//
//  ViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/15/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class UniverseViewController: UIViewController {
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = UniverseScene.unarchiveFromFile("UniverseScene") as? UniverseScene {
            
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true
            
            motionManager.deviceMotionUpdateInterval = 0.025
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak scene] (motion, error) in
                let gravity = motion.gravity
                dispatch_async(dispatch_get_main_queue()) {
                    scene?.physicsWorld.gravity = CGVectorMake(CGFloat(gravity.x*5), CGFloat(gravity.y*5))
                }
            }
            
            scene.scaleMode = .AspectFit
            scene.size = skView.bounds.size
            scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: scene.frame)
            skView.presentScene(scene)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

private extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}
