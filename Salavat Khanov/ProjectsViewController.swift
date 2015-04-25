//
//  ProjectsViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/18/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import StoreKit
import AVKit
import AVFoundation
import pop

class ProjectsViewController: UIViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressIndicator: SKProgressIndicator!
    @IBOutlet weak var appStoreButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    
    var showAppearAnimation = false
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pin content view to screen width
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -0)
        view.addConstraints([leftConstraint, rightConstraint])
        
        view.backgroundColor = navigationController?.navigationBar.barTintColor
        containerView.backgroundColor = navigationController?.navigationBar.barTintColor
        
        setupProgressView()
        appStoreButton?.layer.borderColor = appStoreButton?.tintColor?.CGColor
        githubButton?.layer.borderColor = appStoreButton?.tintColor?.CGColor
        
        navigationController?.navigationBar.barStyle = .Black
        showAppearAnimation = (view.tag == 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Transparent Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = .clearColor()
        navigationController?.view.backgroundColor = .clearColor()
        
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
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    // MARK: - Progress View
    
    func setupProgressView() {
        if endDate.compare(NSDate()) == .OrderedDescending {
            // end date is in the future. show how many days left
            progressIndicator?.percentInnerCircle = CGFloat(currentProgress)
            progressIndicator?.progressLabel.text = "\(endDate.daysLeft)"
            progressIndicator?.metaLabel.text = "DAYS LEFT"
        } else {
            // end date is in the past. show done text.
            progressIndicator?.percentInnerCircle = 100.0
            progressIndicator?.progressLabel.text = "✓"
            progressIndicator?.metaLabel.text = "DONE"
        }
    }
    
    var currentProgress: Double {
        let intervalSinceStart = endDate.timeIntervalSinceDate(startDate)
        let intervalSinceNow = NSDate().timeIntervalSinceDate(startDate)
        return intervalSinceNow / intervalSinceStart * 100
    }
    
    var startDate: NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.hour = 10
        dateComponents.day = 14
        dateComponents.month = 4
        dateComponents.year = 2015
        return NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
    }
    
    var endDate: NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.hour = 10
        dateComponents.day = 8
        dateComponents.month = 6
        dateComponents.year = 2015
        return NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
    }
    
    // MARK: - App Store / GitHub Button
    
    @IBAction func appStoreButtonPressed(sender: UIButton) {
        presentStoreProductViewController(iTunesItemIdentifier: "\(sender.tag)", delegate: self)
    }
    
    @IBAction func githubButtonPressed(sender: UIButton) {
        presentWebBrowserWithURL("https://github.com/khanov/When")
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Video
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVideo" {
            let playerViewController = segue.destinationViewController as! AVPlayerViewController
            let filePath = NSBundle.mainBundle().pathForResource("SuperMario", ofType: "mov")!
            let fileURL = NSURL(fileURLWithPath: filePath)
            playerViewController.player = AVPlayer(URL: fileURL)
            playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill
            playerViewController.player.play()
        }
    }
}

// MARK: - Helper

private extension NSDate {
    var daysLeft: Int { return lroundf(Float(hoursLeft) / 24.0) }
    var hoursLeft: Int { return lroundf(Float(minutesLeft) / 60.0) }
    var minutesLeft: Int { return lroundf(Float(secondsLeft) / 60.0) }
    var secondsLeft: Int { return lroundf(Float(timeIntervalSinceDate(NSDate()))) }
}
