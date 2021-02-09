//
//  MapViewController.swift
//  DepVid
//
//  Created by Michael Doroff on 2/9/21.
//

import UIKit
import MapKit
import JGProgressHUD


// MARK: MapViewController: UIViewController

class MapViewController: UIViewController {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
    
        requestLocation()
        setUpInitialUI()
        
    }
        
    fileprivate func getLocations(region: MKCoordinateRegion, locationType: LocationType)  {
        
        // use the MKRequest to search for pharmacy, hospital, covid testing, etc.
        
        let hud = JGProgressHUD()
        hud.textLabel.text = "Pulling Information on Health Services..."
        hud.show(in: view)

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationType.rawValue
        request.region = region
            
        let search = MKLocalSearch(request: request)
        search.start { (resp, err) in
            
            if let err = err {
                print("Error: ", err)
                
            }
            resp?.mapItems.forEach({ (mapitem) in
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapitem.placemark.coordinate
                annotation.title = mapitem.name
                self.mapView.addAnnotation(annotation)
            })
            
        }
        hud.dismiss()
    }
        
    fileprivate func setUpInitialUI() {
        
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: MapViewController: MapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if !(annotation is MKPointAnnotation) { return nil }

        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // show custom call out
        
    }
}

// MARK: MapViewController: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    
    // important method to implement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("Called method")
        guard let location = locations.first else { return }
        let locationCoordinate = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: .init(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude), span: span)
        
        mapView.setRegion(region, animated: false)
        mapView.removeAnnotations(mapView.annotations)

        let locationTypes = [LocationType.pharmacy, LocationType.doctor, LocationType.emergency]

        for locType in locationTypes {
            getLocations(region: region, locationType: locType)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        handleAuthorization(manager: manager)
        
    }
    
    fileprivate func handleAuthorization(manager: CLLocationManager) {
        
        /* Once you receive authorization from the user you need to call
         manager.startUpdatingLocation() once for the method did didUpdateLocations
         to be called */
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Received Authorized When In Use authorization")
//            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
        case .authorizedAlways:
//            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            print("Received Always Authorized authorization")
        case .denied:
            print("Received Denied authorization")
        case .notDetermined:
            print("User did not provide adequate permissions")
        case .restricted:
            print("Received restricted authorization")
        default:
            print("Unknown behavior")
        }
    }
    
    fileprivate func requestLocation() {
        
        /*
         Xcode Version 12.3 (12C33)
         If you are running this application in the iOS simulator,
         make sure that the location is set. You can do this by going to
         Features => Location => CustomLocation. This information is taken
         from: https://stackoverflow.com/questions/32543754/ios-9-error-domain-kclerrordomain-code-0-null
         
         */
        locationManager.requestWhenInUseAuthorization()
    }
}

