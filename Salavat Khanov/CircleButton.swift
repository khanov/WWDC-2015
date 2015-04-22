//
//  CircleButton.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/17/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit

@IBDesignable class CircleButton: UIView {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            setupView()
        }
    }
    
    private func setupView() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        
        setNeedsDisplay()
    }

}
