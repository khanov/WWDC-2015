//
//  AboutViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/19/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import MapKit

class AboutViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    weak var hiPageView: UIView!
    weak var mapPageView: UIView!
    weak var usatuPageView: UIView!
    weak var msumPageView: UIView!
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pin content view to screen width
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -0)
        view.addConstraints([leftConstraint, rightConstraint])
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        setupHiPage()
        setupMapPage()
        setupUSATUPage()
        setupMSUMPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if didSetupConstraints == false {
            setupPageConstraints()
            didSetupConstraints = true
        }
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Pages
    
    func setupHiPage() {
        let hiPageView = createNewPageView()
        hiPageView.addPhotoBackground("Sal-Photo")
        self.hiPageView = hiPageView
        
        let label = UILabel(pageText: "Hi! My name is Salavat Khanov.\nIt’s nice to meet you.")
        hiPageView.addAndPinLabel(label)
    }
    
    func setupMapPage() {
        let myCoordinates = CLLocationCoordinate2DMake(54.72455119397011, 55.94216976486916)
        let annotation = MKPointAnnotation()
        annotation.coordinate = myCoordinates
        
        let mapView = MKMapView()
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView.scrollEnabled = false
        mapView.addAnnotation(annotation)
        
        let mapPageView = createNewPageView()
        self.mapPageView = mapPageView
        mapPageView.addAndPinSubviewToEdges(mapView)
        
        let label = UILabel(pageText: "I am from Ufa, Russia.\n\nSiri told me that’s 6K+ miles away from San Francisco and we have exactly 12 hours time difference.")
        mapPageView.addAndPinLabel(label)
    }
    
    func setupUSATUPage() {
        let usatuPageView = createNewPageView()
        usatuPageView.addPhotoBackground("USATU-Photo")
        self.usatuPageView = usatuPageView
        
        let label = UILabel(pageText: "I'm currently pursuing my Bachelor's degree of Software Engineering at Ufa State Aviation Technical University.")
        label.textColor = UIColor.whiteColor()
        usatuPageView.addAndPinLabel(label)
    }
    
    func setupMSUMPage() {
        let msumPageView = createNewPageView()
        msumPageView.addPhotoBackground("MSUM-Photo")
        self.msumPageView = msumPageView
        
        let label = UILabel(pageText: "In 2013, I won a scholarship from the US Government to study Computer Science at Minnesota State University Moorhead for a semester.")
        label.textColor = UIColor.whiteColor()
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        msumPageView.addAndPinLabel(label)
    }
    
    // MARK: - Constraints
    
    func setupPageConstraints() {

        let pages = [hiPageView, mapPageView, usatuPageView, msumPageView]
        for pageView in pages {
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView]))
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[pageView(==scrollView)]",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView, "scrollView": scrollView]))
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageView(==scrollView)]",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView, "scrollView": scrollView]))
        }
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[hiView][mapView][usatuView][msumView]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["mapView": mapPageView, "hiView": hiPageView, "usatuView": usatuPageView, "msumView": msumPageView]))
    }
    
}

// MARK: - Helpers

private extension UILabel {
    convenience init(pageText: String) {
        self.init(frame: CGRectZero)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        numberOfLines = 0
        text = pageText
        font = UIFont(name: "HelveticaNeue-Light", size: 19)
        textColor = UIColor.blackColor()
        sizeToFit()
    }
}

private extension UIView {
    func addPhotoBackground(photoNamed: String) {
        let photo = UIImage(named: photoNamed)
        let imageView = UIImageView(image: photo!)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
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
    
    func addAndPinLabel(label: UILabel) {
        addSubview(label)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]-(>=20)-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
    }
}

private extension AboutViewController {
    func createNewPageView() -> UIView {
        let pageView = UIView()
        pageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageView.clipsToBounds = true
        containerView.addSubview(pageView)
        return pageView
    }
}

