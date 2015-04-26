//
//  UIViewController+SKStoreProductViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/19/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import StoreKit
import KINWebBrowser
import pop

extension UIViewController {
    
    func presentStoreProductViewController(iTunesItemIdentifier identifier: String, delegate: SKStoreProductViewControllerDelegate) {
        let params = [SKStoreProductParameterITunesItemIdentifier: identifier]
        let storeController = SKStoreProductViewController()
        storeController.delegate = delegate
        
        storeController.loadProductWithParameters(params) { (result, error) -> Void in
            if result == false {
                UIAlertView(title: "Uh oh!", message: "There was a problem opening the App Store", delegate: nil, cancelButtonTitle: "OK").show()
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        presentViewController(storeController, animated: true, completion: nil)
    }
    
    func presentWebBrowserWithURL(url: String) {
        let browser = KINWebBrowserViewController.webBrowser()
        navigationController?.pushViewController(browser, animated: true)
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        browser.loadURLString(url)
        browser.tintColor = .whiteColor()
        browser.actionButtonHidden = true
    }
    
    func presentViewController(viewControllerToPresent: UIViewController, fromLocation location: CGPoint, color: UIColor, completion: (() -> Void)?) {
        let rectView = UIView(frame: CGRectMake(0, 0, 100, 100))
        rectView.center = CGPointMake(location.x, location.y)
        rectView.backgroundColor = color
        rectView.layer.cornerRadius = rectView.frame.width / 2
        view.addSubview(rectView)
        
        let points = [view.frame.origin,
            CGPointMake(view.frame.origin.x + view.frame.width, view.frame.origin.y + view.frame.height),
            CGPointMake(0, view.frame.origin.y + view.frame.height),
            CGPointMake(view.frame.origin.x + view.frame.width, 0),
            CGPointZero
        ]
        var longestDistance = -Double.infinity
        for point in points {
            let distance = Double(hypotf(Float(location.x - point.x), Float(location.y - point.y)))
            if distance > longestDistance {
                longestDistance = distance
            }
        }
        let scale = CGFloat(longestDistance) / rectView.layer.cornerRadius
        
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.fromValue = NSValue(CGSize: CGSizeMake(1, 1))
        animation.toValue = NSValue(CGSize: CGSizeMake(scale, scale))
        animation.completionBlock = { (animation, finished) in
            if finished {
                self.presentViewController(viewControllerToPresent, animated: false) {
                    rectView.removeFromSuperview()
                }
                completion?()
            }
        }
        
        rectView.layer.pop_addAnimation(animation, forKey: "FrameAnimation")
    }
    
}
