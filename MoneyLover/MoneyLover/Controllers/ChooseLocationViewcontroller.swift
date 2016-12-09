//
//  ChooseLocationViewcontroller.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/8/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit
import MapKit

protocol ChooseLocationDelegate: class {
    func didChooseLocation(namePlace: String)
}

class ChooseLocationViewcontroller: UIViewController {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController: UISearchController?
    var selectedPin: MKPlacemark?
    weak var delegate: ChooseLocationDelegate?
    let reuseAnnotation = "pin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        if let locationSearchTable = storyboard?.instantiateViewControllerWithIdentifier("LocationSearchTable") as? LocationSearchTable {
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            locationSearchTable.mapView = mapView
            locationSearchTable.handleMapSearchDelegate = self
        }
        if let searchBar = resultSearchController?.searchBar {
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for places"
        }
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
}

extension ChooseLocationViewcontroller: HandleMapSearchDelegate {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension ChooseLocationViewcontroller: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseAnnotation) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseAnnotation)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        let buttonRect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let button = UIButton(frame: buttonRect)
        button.setBackgroundImage(UIImage(named: "car_icon"), forState: .Normal)
        button.addTarget(self, action:#selector(getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        if let selectedPin = selectedPin, let namePlace = selectedPin.name {
            delegate?.didChooseLocation(namePlace)
        }
        return pinView
    }
    
    func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }
}

extension ChooseLocationViewcontroller: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.presentAlertWithTitle("Error", message: "Can't access location,please check connect network")
    }
}
