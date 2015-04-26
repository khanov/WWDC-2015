//
//  WorkTableViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/16/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import StoreKit
import pop

class WorkViewController: UIViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var iconButton2: UIButton?
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTextTopConstraint: NSLayoutConstraint!
    
    var showAppearAnimation = false
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pin content view to screen width
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -0)
        view.addConstraints([leftConstraint, rightConstraint])
        
        // Add white borders
        iconButton.layer.borderColor = UIColor.whiteColor().CGColor
        iconButton2?.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.backgroundColor = navigationController?.navigationBar.barTintColor
        containerView.backgroundColor = navigationController?.navigationBar.barTintColor
        
        // Transparent Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = .clearColor()
        navigationController?.view.backgroundColor = .clearColor()
        
        showAppearAnimation = (view.tag == 1)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if didSetupConstraints == false && CGRectIntersectsRect(titleLabel.frame, iconButton.frame) == true {
            titleTopConstraint.constant = 85
            mainTextTopConstraint.constant = 20
            didSetupConstraints = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if showAppearAnimation {
            containerView.alpha = 0.0
            navigationController?.navigationBar.alpha = 0.0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if showAppearAnimation {
            let appearAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            appearAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            appearAnimation.fromValue = 0.0
            appearAnimation.toValue = 1.0
            
            navigationController?.navigationBar.pop_addAnimation(appearAnimation, forKey: "AppearAnimation")
            containerView.pop_addAnimation(appearAnimation, forKey: "AppearAnimation")
            
            // don't show anymore
            showAppearAnimation = false
        }
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func appStoreButtonPressed(sender: UIButton) {
        presentStoreProductViewController(iTunesItemIdentifier: "\(sender.tag)", delegate: self)
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

}
