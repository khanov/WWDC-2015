//
//  BaseViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/26/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        makeNavigationBarTransparent()
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
    
    // MARK: - Actions
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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

}

enum StatusBarColor {
    case Black
    case White
}
