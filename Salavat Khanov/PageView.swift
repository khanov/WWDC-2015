//
//  PageView.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/21/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

class PageView: UIView {

    weak var backgroundImageView: UIImageView!
    weak var mainLabel: UILabel!
    weak var metaLabel: UILabel!
}

extension PageView {
    func addBackgroundImageNamed(photoNamed: String) {
        let photo = UIImage(named: photoNamed)
        let imageView = UIImageView(image: photo!)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        backgroundImageView = imageView
        addAndPinSubviewToEdges(imageView)
    }
    
    func addAndPinSubviewToEdges(subview: UIView) {
        addSubview(subview)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["subview": subview]))
    }
    
    func addAndPinMainLabel(label: UILabel, leadingSpacing: Double = 20, trailingSpacing: Double = 20, topSpacing: Double = 25) {
        mainLabel = label
        addSubview(label)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leadingSpacing)-[label]-(>=\(trailingSpacing))-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(topSpacing)-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
    }
    
    func addAndPinMetaLabel(label: UILabel, leadingSpacing: Double = 20, trailingSpacing: Double = 20, bottomSpacing: Double = 15) {
        metaLabel = label
        addSubview(label)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leadingSpacing)-[label]-\(trailingSpacing)-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-\(bottomSpacing)-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
    }
}