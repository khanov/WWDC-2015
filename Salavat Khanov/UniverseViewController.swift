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

class UniverseViewController: UIViewController, UniverseSceneDelegate {
    
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
            scene.touchDelegate = self
            skView.presentScene(scene)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Shape touches
    
    func sceneDidPressAboutButton(scene: UniverseScene) {
        performSegueWithIdentifier("showAboutScreen", sender: self)
    }
    
    func sceneDidPressWorkButton(scene: UniverseScene) {
        performSegueWithIdentifier("showWorkScreen", sender: self)
        
    }
    
    func sceneDidPressProjectsButton(scene: UniverseScene) {
        performSegueWithIdentifier("showProjectsScreen", sender: self)
    }
    
    // Mark: - Page View Controller
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWorkScreen" || segue.identifier == "showProjectsScreen" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let pageViewContoller = navigationController.viewControllers.first as! SLPagingViewController
            configurePageViewController(pageViewContoller)
        }
    }
    
    func configurePageViewController(controller: SLPagingViewController) {
        controller.pagingViewMovingRedefine = { (scrollView, subviews) -> Void in
            // Twitter Like
            let width = UIScreen.mainScreen().bounds.size.width
            let mid = width/2 - 45
            let xOffset = scrollView.contentOffset.x
            for (i, v) in enumerate(subviews as! [UILabel]) {
                var alpha: CGFloat = 0.0
                if v.frame.origin.x < mid {
                    alpha = 1 - (xOffset - CGFloat(i)*width) / width;
                }
                else if v.frame.origin.x > mid {
                    alpha = (xOffset - CGFloat(i)*width) / width + 1
                }
                else if v.frame.origin.x == mid-5 {
                    alpha = 1.0;
                }
                v.alpha = alpha
            }
        }
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
