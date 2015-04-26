//
//  BaseViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/26/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import StoreKit
import pop

class BaseViewController: UIViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    
    var appearAnimationCompletionBlock: ((POPAnimation!, Bool) -> Void)?
    var showAppearAnimation = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pin content view to screen width
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -0)
        view.addConstraints([leftConstraint, rightConstraint])
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.backgroundColor = navigationController?.navigationBar.barTintColor
        containerView.backgroundColor = navigationController?.navigationBar.barTintColor
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        makeNavigationBarTransparent()
        
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
            appearAnimation.completionBlock = appearAnimationCompletionBlock
            
            navigationController?.navigationBar.pop_addAnimation(appearAnimation, forKey: "AppearAnimation")
            containerView.pop_addAnimation(appearAnimation, forKey: "AppearAnimation")
            
            // don't show anymore
            showAppearAnimation = false
        }
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Transparent Navigation Bar
    
    func makeNavigationBarTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = .clearColor()
        navigationController?.view.backgroundColor = .clearColor()
    }
    
    func restoreNaviagationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    
    // MARK: - Status Bar
    
    var statusBarColor: StatusBarColor = .White {
        didSet {
            switch statusBarColor {
            case .White:
                statusBarStyle = .LightContent
                navigationController?.navigationBar.barStyle = .Black
            case .Black:
                statusBarStyle = .Default
                navigationController?.navigationBar.barStyle = .Default
            }
        }
    }
    
    var statusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private var statusBarStyle: UIStatusBarStyle = .LightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return statusBarHidden
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }

    // MARK: - App Store Button
    
    @IBAction func appStoreButtonPressed(sender: UIButton) {
        presentStoreProductViewController(iTunesItemIdentifier: "\(sender.tag)", delegate: self)
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

enum StatusBarColor {
    case Black
    case White
}
