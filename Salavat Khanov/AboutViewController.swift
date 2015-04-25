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
    weak var storyPageView: PageView!
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
        
        view.backgroundColor = .blackColor()
        
        // Transparent Navigation Bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = .clearColor()
        navigationController?.view.backgroundColor = .clearColor()
        
        setupHiPage()
//        setupMapPage()
        setupUSATUPage()
        setupMSUMPage()
        setupStoryPage()
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
        let label = UILabel(pageText: "In 2013, I won a scholarship from the US Government to study Computer Science for a semester at Minnesota State University Moorhead.\n\nI was lucky enough to be awarded the Dean's List Certificate.")
        label.textColor = UIColor.whiteColor()
        label.addShadow()
        
        let msumPageView = createNewPageView()
        self.msumPageView = msumPageView
        msumPageView.addBackgroundImageNamed("MSUM-Photo")
        msumPageView.addAndPinMainLabel(label)
    }
    
    func setupStoryPage() {
        let label = UILabel(pageText: "What’s your story?\n\nHere’s mine.\n\nSix years ago, because I liked technology and design and wanted to learn more how to make websites, I decided to create a blog. It was dedicated to the Mac and iPhone.\n\nLater, I got my first iPhone and was fascinated by its camera capabilities and all the apps available to process photos. I thought it would be cool to create another blog — about taking photos on the iPhone — iPhoneography.\n\nSoon, I realized that I was becoming more interested in app development than just writing about them. So I started to learn Objective-C. All the good Objective-C books were in English at the time. For me, that meant I had to work on my English skills first. So I did that.\n\nWhile still learning Objective-C, I thought that I need a little side project to practice Objective-C. That’s how I ended up creating a Mac game like Super Mario. I had never developed games before and knew nothing about it — this was so much fun!\n\nThen something big happened. I won a scholarship to study Computer Science in the US for one semester. Since I had never been abroad, you can imagine how excited I was to visit America!\n\nAfter coming back home from the US, I had half a year of free time (I had to take one year off at my home university to study in the US). During this time I released my first iOS app on the App Store.\n\nShortly, I landed a job at Lapka as an iOS Developer. The team was located in Moscow, so I worked remotely from my home town. While working at Lapka, I learned many things about iOS development and working for startups. I was pleasently surprised that they were not afraid to give me the freedom of doing whatever I think is best for Lapka, even though I didn’t have a lot of experience.\n\nSoon, WWDC ’14 was announced and Lapka said I’m going! For a few years, I had been only dreaming of going to WWDC sometime in the future. Who would have thought I’m going in two months?! I couldn’t be more excited.\n\nWWDC was amazing. I have never met so many great iOS and Mac developers in one place. Many of them I knew only from Twitter. I left WWDC very motivated and touched by the community.\n\nI later joined another team, who worked on an app for storing personal documents and other sensitive information like passwords on iOS. I worked there only for a few months because I couldn’t study and work simultaneusly full-time. This app was featured by Apple many times and climbed to the #1 place on the Russian App Store.\n\nSo, that was my story. Like Steve Jobs said in his Stanford speech, “You can't connect the dots looking forward; you can only connect them looking backward.” When I was creating my first blog, I didn’t even think it would lead me to this amazing journey.\n\nWhat’s your story? I’d like to hear it at WWDC '15!\n\nThank you.\n\n~ Sal")
        label.textColor = .whiteColor()
        label.font = UIFont(name: "GillSans", size: 18)
        label.sizeToFit()
        
        let storyPageView = createNewPageView()
        self.storyPageView = storyPageView
        storyPageView.backgroundColor = .blackColor()
        storyPageView.mainLabel = label
        storyPageView.addSubview(label)
        
        storyPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]-(>=20)-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        storyPageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-45-[label]-45-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["label": label]))
        
    }
    
    // MARK: - Constraints
    
    func setupPageConstraints() {

        let pages = [hiPageView, usatuPageView, msumPageView, storyPageView]
        for pageView in pages {
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView]))
            
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[pageView(==scrollView)]",
                options: NSLayoutFormatOptions.allZeros,
                metrics: nil,
                views: ["pageView": pageView, "scrollView": scrollView]))
            
            if pageView != storyPageView {
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageView(==scrollView)]",
                    options: NSLayoutFormatOptions.allZeros,
                    metrics: nil,
                    views: ["pageView": pageView, "scrollView": scrollView]))
            }
        }
        
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[hiView][usatuView][msumView][storyView]|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["hiView": hiPageView, "usatuView": usatuPageView, "msumView": msumPageView, "storyView": storyPageView]))
    }
    
    // MARK: - Gestures
    
    func mapPageViewLongPressed(sender: UILongPressGestureRecognizer) {
        if let mapView = mapPageView.subviews.first as? MKMapView where sender.state == .Began {
            let enableMap = scrollView.scrollEnabled
            mapView.scrollEnabled = enableMap
            mapView.zoomEnabled = enableMap
            mapView.rotateEnabled = enableMap
            scrollView.scrollEnabled = !enableMap
            
            let animation = POPSpringAnimation(propertyNamed: kPOPViewAlpha)
            animation.toValue = enableMap ? 0.0 : 1.0
            mapPageView.mainLabel.pop_addAnimation(animation, forKey: "alpha")
            
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
        // Paged view disabled for the Story text
        if CGRectIntersectsRect(scrollView.bounds, storyPageView.frame) == true {
            scrollView.pagingEnabled = false
        } else {
            scrollView.pagingEnabled = true
        }
        
        let scrollViewHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height;
        let scrollOffset = scrollView.contentOffset.y;
        
        if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
//            println("bottom")
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

