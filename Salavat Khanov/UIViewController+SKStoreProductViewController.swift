//
//  UIViewController+SKStoreProductViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/19/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import StoreKit

extension UIViewController {
    
    func presentStoreProductViewController(iTunesItemIdentifier identifier: String, delegate: SKStoreProductViewControllerDelegate) {
        let params = [SKStoreProductParameterITunesItemIdentifier: identifier]
        let storeController = SKStoreProductViewController()
        storeController.delegate = delegate
        
        storeController.loadProductWithParameters(params) { (result, error) -> Void in
            if result {
                self.presentViewController(storeController, animated: true, completion: nil)
            } else {
                UIAlertView(title: "Uh oh!", message: "There was a problem opening the App Store", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
        
    }
}
