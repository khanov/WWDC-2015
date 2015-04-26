//
//  MapViewController.swift
//  Salavat Khanov
//
//  Created by Salavat Khanov on 4/24/15.
//  Copyright (c) 2015 Arty Technology. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeDirection: CLLocationDirection!
    var planeAnnotationPosition: Int = 0
    
    var shouldUpdatePlanePosition = true
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appearAnimationCompletionBlock = { _ in
            self.mapView.alpha = 1.0
            self.navigationController?.navigationBar.alpha = 1.0
        }
        
        setupMapPage()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updatePlanePositionAndDirection()
    }
    
    override func viewWillDisappear(animated: Bool) {
        shouldUpdatePlanePosition = false
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Map
    
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
        
        mapView.setRegion(MKCoordinateRegion(center: myCoordinates, span: MKCoordinateSpanMake(17, 177)), animated: false)
        mapView.delegate = self
        mapView.addAnnotation(myAnnotation)
        mapView.addAnnotation(mosconeAnnotation)
        mapView.addAnnotation(planeAnnotation!)
        mapView.addOverlay(flightpathPolyline)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .blueColor()
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
        
        planeDirection = directionBetweenPoints(previousMapPoint, destinationPoint: nextMapPoint)
        planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        if let planeAnnotationView = mapView.viewForAnnotation(planeAnnotation) {
            planeAnnotationView.transform = CGAffineTransformRotate(mapView.transform, CGFloat(degreesToRadians(planeDirection)))
            if mapView.scrollEnabled == false {
                mapView.setRegion(MKCoordinateRegion(center: planeAnnotation.coordinate, span: MKCoordinateSpanMake(17, 177)), animated: false)
            }
        }
        
        if shouldUpdatePlanePosition {
            var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.04 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.updatePlanePositionAndDirection()
            }
        }
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, destinationPoint: MKMapPoint) -> CLLocationDirection {
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

}
