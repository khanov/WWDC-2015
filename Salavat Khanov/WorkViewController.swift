//
//  WorkTableViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/16/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class WorkViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconButton2: UIButton?
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTextTopConstraint: NSLayoutConstraint!
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add white borders
        iconButton.layer.borderColor = UIColor.whiteColor().CGColor
        iconButton2?.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if didSetupConstraints == false && CGRectIntersectsRect(titleLabel.frame, iconButton.frame) == true {
            titleTopConstraint.constant = 85
            mainTextTopConstraint.constant = 20
            didSetupConstraints = true
        }
    }

}
