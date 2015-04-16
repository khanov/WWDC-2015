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
    

}

