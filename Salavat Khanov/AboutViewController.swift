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
        self.hiPageView = hiPageView
        addPhotoBackground("Sal-Photo", toPage: hiPageView)
        
        let label = createPageLabel("Hi! My name is Salavat Khanov.\nIt’s nice to meet you.")
        hiPageView.addSubview(label)
        hiPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        hiPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
    }
    
    func setupMapPage() {
        let mapPageView = createNewPageView()
        mapPageView.backgroundColor = UIColor.orangeColor()
        self.mapPageView = mapPageView
        
        let myCoordinates = CLLocationCoordinate2DMake(54.72455119397011, 55.94216976486916)
        let annotation = MKPointAnnotation()
        annotation.coordinate = myCoordinates
        
        let mapView = MKMapView()
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView.scrollEnabled = false
        mapView.addAnnotation(annotation)
        addAndPinSubview(mapView, toParent: mapPageView)
        
        let label = createPageLabel("I am from Ufa, Russia.\nThat’s 6000+ miles from San Francisco.\nExactly 12 hours time difference.")
        mapPageView.addSubview(label)
        mapPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        mapPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[label]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        
    }
    
    // MARK: - Constraints
    
    func setupPageConstraints() {

        let pages = [hiPageView, mapPageView]
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
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[hiView][mapView]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["mapView": mapPageView, "hiView": hiPageView]))
    }
    
    // MARK: - Helpers
    
    func createPageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.numberOfLines = 0
        label.text = text
        label.font = UIFont(name: "HelveticaNeue-Light", size: 19)
        label.textColor = UIColor.blackColor()
        label.sizeToFit()
        return label
    }
    
    func createNewPageView() -> UIView {
        let pageView = UIView()
        pageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addSubview(pageView)
        return pageView
    }
    
    func addPhotoBackground(photoNamed: String, toPage page: UIView) {
        let photo = UIImage(named: photoNamed)
        let imageView = UIImageView(image: photo!)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        addAndPinSubview(imageView, toParent: page)
    }
    
    func addAndPinSubview(subview: UIView, toParent parent: UIView) {
        parent.addSubview(subview)
        parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["subview": subview]))
        parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["subview": subview]))
    }
    
}
