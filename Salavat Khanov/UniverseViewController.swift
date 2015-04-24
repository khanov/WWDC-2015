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
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            motionManager.deviceMotionUpdateInterval = 0.025
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { [weak scene] (motion, error) in
                let gravity = motion.gravity
                dispatch_async(dispatch_get_main_queue()) {
                    scene?.physicsWorld.gravity = CGVectorMake(CGFloat(gravity.x*10), CGFloat(gravity.y*10))
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
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Shape touches
    
    func scene(scene: UniverseScene, didPressNodeType node: NodeType, withTouch touch: UITouch, color: UIColor) {
        var controller: UINavigationController
        
        switch node {
        case .About:
            controller = storyboard?.instantiateViewControllerWithIdentifier("AboutScreen") as! UINavigationController
        case .Map:
            controller = storyboard?.instantiateViewControllerWithIdentifier("MapScreen") as! UINavigationController
        case .MyPocket:
            controller = storyboard?.instantiateViewControllerWithIdentifier("MyPocketScreen") as! UINavigationController
        case .Lapka:
            controller = storyboard?.instantiateViewControllerWithIdentifier("LapkaScreen") as! UINavigationController
        case .When:
            controller = storyboard?.instantiateViewControllerWithIdentifier("WhenScreen") as! UINavigationController
        case .Mario:
            controller = storyboard?.instantiateViewControllerWithIdentifier("MarioScreen") as! UINavigationController
        }
        
        let location = touch.locationInView(view)
        controller.navigationBar.barTintColor = color
        presentViewController(controller, fromLocation: location, color: color, completion: nil)
    }
    
    func scene(scene: UniverseScene, didPressAboutButtonWithTouch touch: UITouch) {
        let location = touch.locationInView(view)
        let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("AboutScreen") as! UINavigationController
        presentViewController(aboutVC, fromLocation: location, completion: nil)
    }
    
    func scene(scene: UniverseScene, didPressWorkButtonWithTouch touch: UITouch) {
        let location = touch.locationInView(view)
        let workVC = self.storyboard?.instantiateViewControllerWithIdentifier("WorkScreen") as! UINavigationController
        if let pageViewContoller = workVC.viewControllers.first as? SLPagingViewController {
            configurePageViewController(pageViewContoller)
        }
        presentViewController(workVC, fromLocation: location, completion: nil)
    }
    
    func scene(scene: UniverseScene, didPressProjectsButtonWithTouch touch: UITouch) {
        let location = touch.locationInView(view)
        let projectsVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProjectsScreen") as! UINavigationController
        if let pageViewContoller = projectsVC.viewControllers.first as? SLPagingViewController {
            configurePageViewController(pageViewContoller)
        }
        presentViewController(projectsVC, fromLocation: location, completion: nil)
    }
    
    // Mark: - Page View Controller
    
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

enum NodeType: String {
    case About = "AboutShape"
    case Map = "MapShape"
    case MyPocket = "MyPocketShape"
    case Lapka = "LapkaShape"
    case When = "WhenShape"
    case Mario = "SuperMarioShape"
    
    static func findByName(name: String) -> NodeType? {
        switch name {
        case NodeType.About.rawValue:
            return .About
        case NodeType.Map.rawValue:
            return .Map
        case NodeType.MyPocket.rawValue:
            return .MyPocket
        case NodeType.Lapka.rawValue:
            return .Lapka
        case NodeType.When.rawValue:
            return .When
        case NodeType.Mario.rawValue:
            return .Mario
        default:
            return nil
        }
    }
}
