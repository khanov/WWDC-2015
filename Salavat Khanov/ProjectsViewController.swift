//
//  ProjectsViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/18/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressIndicator: SKProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pin content view to screen width
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -0)
        view.addConstraints([leftConstraint, rightConstraint])
        
        setupProgressView()
    }

    func setupProgressView() {
        progressIndicator.percentInnerCircle = CGFloat(currentProgress)
        progressIndicator.progressLabel.text = "\(endDate.daysLeft)"
        progressIndicator.metaLabel.text = "DAYS LEFT"
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

}

extension NSDate {
    var daysLeft: Int { return lroundf(Float(hoursLeft) / 24.0) }
    var hoursLeft: Int { return lroundf(Float(minutesLeft) / 60.0) }
    var minutesLeft: Int { return lroundf(Float(secondsLeft) / 60.0) }
    var secondsLeft: Int { return lroundf(Float(timeIntervalSinceDate(NSDate()))) }
}
