//
//  MapViewController.swift
//  DepVid
//
//  Created by Michael Doroff on 2/9/21.
//

import UIKit
import MapKit
import JGProgressHUD
import LBTATools

// MARK: MapViewController: UIViewController

class MapViewController: UIViewController {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var startLocation: MKMapItem?
    var endLocation: MKMapItem?
    let label = UILabel(text: "", font: .boldSystemFont(ofSize: 20), textColor: UIColor.black, textAlignment: .center, numberOfLines: 0)
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        // specifies the amount of distance that the phone must move before location updates are triggered
        
        locationManager.distanceFilter = CLLocationDistance(80000)
        
        mapView.showsUserLocation = true
    
        // Requests that the application get get access to the user's location
        
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
                
                let annotation = CustomAnnotation(name: mapitem.name, address: mapitem.phoneNumber, locationType: locationType.rawValue, mapItem: mapitem)
                
                annotation.coordinate = mapitem.placemark.coordinate
                annotation.title = mapitem.name
                annotation.name = mapitem.name
                annotation.address = mapitem.address()
                
                switch (locationType.rawValue) {
                
                case "emergency room":
                    annotation.annotationPhoto = #imageLiteral(resourceName: "emergencyphoto")
                    annotation.selectedPhoto = #imageLiteral(resourceName: "emergencyphoto")
                case "doctor":
                    annotation.annotationPhoto  = #imageLiteral(resourceName: "hospitalphoto")
                    annotation.selectedPhoto = #imageLiteral(resourceName: "hospitalphoto")
                    
                case "pharmacy":
                    
                    annotation.annotationPhoto  = #imageLiteral(resourceName: "pharmacistphoto")
                    annotation.selectedPhoto = #imageLiteral(resourceName: "pharmacistphoto")
                
                default:
                    annotation.annotationPhoto = nil
                }
                
                self.mapView.addAnnotation(annotation)
            
            })
            
            self.label.text = "Please pick a pin:\n\n Green - Pharmacies \n Blue - Doctors \n Red - Emergency Rooms "
        }
        hud.dismiss()
    }
        
    fileprivate func setUpInitialUI() {
        
        view.addSubview(mapView)
        
        let myLabel = returnDirectionsView()
        
        view.addSubview(myLabel)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        myLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 80, right: 16), size: .init(width: view.frame.width, height: 150))
        myLabel.setupShadow(opacity: 0.5, radius: 1.0, offset: .zero, color: .gray)
    
    }
    
    fileprivate func returnDirectionsView() -> UIView {
        
        let view = UIView(backgroundColor: .white)
        view.addSubview(label)
        label.centerInSuperview()
        return view
    }
}

// MARK: MapViewController: MapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if !(annotation is CustomAnnotation) { return nil }
        
        if let customAnnotation = annotation as? CustomAnnotation {
            
            let annotation = annotation as! CustomAnnotation
            
            let annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "id", name: annotation.name, address: annotation.address, mapItem: annotation.mapItem ?? MKMapItem(), selectedPhoto: annotation.selectedPhoto)
        
            if let locationType = customAnnotation.locationType {
                
                switch locationType {
                case "pharmacy":
                    annotationView.image = #imageLiteral(resourceName: "greenMapPin")
                    
                case "doctor":
                    annotationView.image = #imageLiteral(resourceName: "blueMapPin")
                    
                case "emergency room":
                    annotationView.image = #imageLiteral(resourceName: "redMapPin")
                default:
                    annotationView.image = #imageLiteral(resourceName: "default")
                }
            }
            return annotationView
            
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let customAnnotationView = view as? CustomAnnotationView

        let pinController = SelectedPinController()
        
        pinController.name = customAnnotationView?.name
        pinController.address = customAnnotationView?.address
        pinController.photo = customAnnotationView?.selectedPhoto
        pinController.startLocation = startLocation
        pinController.endLocation = customAnnotationView?.mapItem
        
        present(pinController, animated: true)
        
    }
}

// MARK: MapViewController: CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    // important method to implement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }
        let locationCoordinate = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: .init(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude), span: span)
        
        let placemark = MKPlacemark(coordinate: locationCoordinate)
        startLocation = MKMapItem(placemark: placemark)
        
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
            manager.startUpdatingLocation()
        case .denied:
            label.text = "No Pins Available - DepVid Requires Location Services"
        case .notDetermined:
            label.text = "No Pins Available - DepVid Requires Location Services"
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

