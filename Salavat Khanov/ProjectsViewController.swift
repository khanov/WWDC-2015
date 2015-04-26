//
//  ProjectsViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/18/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ProjectsViewController: BaseViewController {

    @IBOutlet weak var progressIndicator: SKProgressIndicator!
    @IBOutlet weak var appStoreButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProgressView()
        
        appStoreButton?.layer.borderColor = appStoreButton?.tintColor?.CGColor
        githubButton?.layer.borderColor = appStoreButton?.tintColor?.CGColor
        statusBarColor = .White
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
    
    // MARK: - GitHub Button
    
    @IBAction func githubButtonPressed(sender: UIButton) {
        presentWebBrowserWithURL("https://github.com/khanov/When")
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
