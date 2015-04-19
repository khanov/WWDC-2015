//
//  ViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/15/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class UniverseViewController: UIViewController {
    
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var sideProjectsButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!
    @IBOutlet weak var interestsButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMotionEffects()
    }

    func addMotionEffects() {
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -50
        verticalMotionEffect.maximumRelativeValue = 50
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -50
        horizontalMotionEffect.maximumRelativeValue = 50
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
        
        let buttons = [workButton, sideProjectsButton, educationButton, interestsButton]
        for button in buttons {
            button.addMotionEffect(motionGroup)
        }
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        sender.backgroundColor = UIColor.whiteColor()
        sender.titleLabel?.textColor = UIColor.blackColor()
    }
    
    @IBAction func buttonUnpressed(sender: UIButton) {
        sender.backgroundColor = UIColor.blackColor()
        sender.titleLabel?.textColor = UIColor.whiteColor()
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

