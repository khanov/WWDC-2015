//
//  AboutViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/19/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import MapKit
import pop

class AboutViewController: UIViewController, MKMapViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    weak var hiPageView: PageView!
    weak var mapPageView: PageView!
    weak var usatuPageView: PageView!
    weak var msumPageView: PageView!
    
    var didSetupConstraints = false
    
    static let enableMapHintText = "Long press the map to enable scrolling\nand see it for yourself!"
    static let disableMapHintText = "Long press the map again to disable scrolling."
    
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeDirection: CLLocationDirection!
    var planeAnnotationPosition: Int = 0
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pin content view to screen width
        let leftConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -0)
        view.addConstraints([leftConstraint, rightConstraint])
        
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.delegate = self
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollView.alpha = 0.0
        navigationController?.navigationBar.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let appearAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        appearAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        appearAnimation.fromValue = 0.0
        appearAnimation.toValue = 1.0
        
        navigationController?.navigationBar.pop_addAnimation(appearAnimation, forKey: "AppearAnimation")
        scrollView.pop_addAnimation(appearAnimation, forKey: "AppearAnimation")
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // MARK: - Pages
    
    func setupHiPage() {
        let label = UILabel(pageText: "Hi! My name is Salavat Khanov.\nIt’s nice to meet you.")
        
        let hiPageView = createNewPageView()
        self.hiPageView = hiPageView
        hiPageView.addBackgroundImageNamed("Sal-Photo")
        hiPageView.addAndPinMainLabel(label)
    }
    
    func setupMapPage() {
        let myCoordinates = CLLocationCoordinate2DMake(54.7245, 55.9421)
        let moscowCoordinates = CLLocationCoordinate2DMake(55.7500, 37.6167)
        let netherlandsCoordinates = CLLocationCoordinate2DMake(52.3740, 5.55)
        let mosconeCoordinates = CLLocationCoordinate2DMake(37.7842, -122.4016)
        
        var coordinates: [CLLocationCoordinate2D]
        coordinates = [myCoordinates, moscowCoordinates, netherlandsCoordinates, mosconeCoordinates]
        flightpathPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 4)
        
        let myAnnotation = MKPointAnnotation()
        myAnnotation.title = "Salavat Khanov"
        myAnnotation.subtitle = "Ufa, Russia"
        myAnnotation.coordinate = myCoordinates
        
        let mosconeAnnotation = MKPointAnnotation()
        mosconeAnnotation.title = "WWDC 2015"
        mosconeAnnotation.subtitle = "San Francisco, CA"
        mosconeAnnotation.coordinate = mosconeCoordinates
        
        planeAnnotation = MKPointAnnotation()
        planeAnnotation!.title = "Plane"
        
        let mapView = MKMapView()
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
        mapView.setRegion(MKCoordinateRegion(center: myCoordinates, span: MKCoordinateSpanMake(17, 177)), animated: false)
        mapView.delegate = self
        mapView.addAnnotation(myAnnotation)
        mapView.addAnnotation(mosconeAnnotation)
        mapView.addAnnotation(planeAnnotation!)
        mapView.addOverlay(flightpathPolyline)
        
        let mainLabel = UILabel(pageText: "I am from Ufa, Russia.\n\nSiri told me that’s 6K+ miles away from San Francisco and we have exactly 12 hours time difference.")
        
        let hintLabel = UILabel(metaText: AboutViewController.enableMapHintText)
        hintLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        hintLabel.layer.cornerRadius = 5
        hintLabel.clipsToBounds = true
        
        let mapPageView = createNewPageView()
        self.mapPageView = mapPageView
        mapPageView.addAndPinSubviewToEdges(mapView)
        mapPageView.addAndPinMainLabel(mainLabel)
        mapPageView.addAndPinMetaLabel(hintLabel)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "mapPageViewLongPressed:")
        mapPageView.addGestureRecognizer(longPressRecognizer)
    }
    
    func setupUSATUPage() {
        let label = UILabel(pageText: "I'm currently pursuing my Bachelor's degree of Software Engineering at Ufa State Aviation Technical University.")
        label.textColor = UIColor.whiteColor()
        label.addShadow()
        
        let usatuPageView = createNewPageView()
        self.usatuPageView = usatuPageView
        usatuPageView.addBackgroundImageNamed("USATU-Photo")
        usatuPageView.addAndPinMainLabel(label)
    }
    
    func setupMSUMPage() {
        let label = UILabel(pageText: "In 2013, I won a scholarship from the US Government to study Computer Science for a semester at Minnesota State University Moorhead.\n\nI was awarded the Dean's List Certificate.")
        label.textColor = UIColor.whiteColor()
        label.addShadow()
        
        let msumPageView = createNewPageView()
        self.msumPageView = msumPageView
        msumPageView.addBackgroundImageNamed("MSUM-Photo")
        msumPageView.addAndPinMainLabel(label)
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
    
    // MARK: - Gestures
    
    func mapPageViewLongPressed(sender: UILongPressGestureRecognizer) {
        if let mapView = mapPageView.subviews.first as? MKMapView where sender.state == .Began {
            let enableMap = scrollView.scrollEnabled
            mapView.scrollEnabled = enableMap
            mapView.zoomEnabled = enableMap
            mapView.rotateEnabled = enableMap
            scrollView.scrollEnabled = !enableMap
            mapPageView.mainLabel.alpha = enableMap ? 0.0 : 1.0
            mapPageView.metaLabel.text = enableMap ? AboutViewController.disableMapHintText : AboutViewController.enableMapHintText
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 3
            polylineRenderer.alpha = 0.5
            return polylineRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isEqual(planeAnnotation) == false {
            return nil
        }
        
        let pinIdentifier = "Pin"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
        }
        
        annotationView.image = UIImage(named: "Plane")
        return annotationView
    }
    
    // MARK: - Plane
    
    func updatePlanePositionAndDirection() {
        let step = 8
        
        if planeAnnotationPosition + step >= flightpathPolyline.pointCount {
            planeAnnotationPosition = 0
        }
        
        let previousMapPoint = flightpathPolyline.points()[planeAnnotationPosition]
        planeAnnotationPosition += step
        let nextMapPoint = flightpathPolyline.points()[planeAnnotationPosition]
        
        planeDirection = directionBetweenPoints(previousMapPoint, nextMapPoint)
        planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        if let mapView = mapPageView.subviews.first as? MKMapView, planeAnnotationView = mapView.viewForAnnotation(planeAnnotation) {
            planeAnnotationView.transform = CGAffineTransformRotate(mapView.transform, CGFloat(degreesToRadians(planeDirection)))
            if mapView.scrollEnabled == false {
                mapView.setRegion(MKCoordinateRegion(center: planeAnnotation.coordinate, span: MKCoordinateSpanMake(17, 177)), animated: false)
            }
        }
        
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.04 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            self.updatePlanePositionAndDirection()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Animate plane only when the map view is visible
        if CGRectIntersectsRect(scrollView.bounds, mapPageView.frame) == true && planeAnnotationPosition == 0 {
            updatePlanePositionAndDirection()
        }
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
    convenience init(metaText: String) {
        self.init(frame: CGRectZero)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        numberOfLines = 0
        text = metaText
        font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textColor = UIColor.blackColor()
        textAlignment = .Center
        sizeToFit()
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSizeMake(1.0, 1.0);
    }
}

private extension AboutViewController {
    func createNewPageView() -> PageView {
        let pageView = PageView()
        pageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageView.clipsToBounds = true
        containerView.addSubview(pageView)
        return pageView
    }
}

func directionBetweenPoints(sourcePoint: MKMapPoint, destinationPoint: MKMapPoint) -> CLLocationDirection {
    let x = destinationPoint.x - sourcePoint.x
    let y = destinationPoint.y - sourcePoint.y
    return fmod(radiansToDegrees(atan2(y, x)), 360.0) + 90.0
}

private func radiansToDegrees(radians: Double) -> Double {
    return radians * 180 / M_PI
}

private func degreesToRadians(degrees: Double) -> Double {
    return degrees * M_PI / 180
}

