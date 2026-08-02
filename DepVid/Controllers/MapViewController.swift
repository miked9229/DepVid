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
    var onPinSelected: ((PinSelection) -> Void)?
    fileprivate let annotationViewReuseIdentifier = "CustomAnnotationView"

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

        Task { [weak self] in
            guard let self else { return }
            defer { hud.dismiss() }
            do {
                let response = try await search.start()
                for mapItem in response.mapItems {
                    let annotation = CustomAnnotation(name: mapItem.name, address: mapItem.phoneNumber, locationType: locationType.rawValue, mapItem: mapItem)

                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    annotation.name = mapItem.name
                    annotation.address = mapItem.address()
                    annotation.annotationPhoto = locationType.pinPhoto
                    annotation.selectedPhoto = locationType.pinPhoto

                    mapView.addAnnotation(annotation)
                }

                label.text = "Please pick a pin:\n\n Green - Pharmacies \n Blue - Doctors \n Red - Emergency Rooms "
            } catch {
                print("Error: ", error)
            }
        }
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

        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }

        let annotationView: CustomAnnotationView
        if let dequeued = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewReuseIdentifier) as? CustomAnnotationView {
            annotationView = dequeued
            annotationView.annotation = customAnnotation
            annotationView.name = customAnnotation.name
            annotationView.address = customAnnotation.address
            annotationView.mapItem = customAnnotation.mapItem
            annotationView.selectedPhoto = customAnnotation.selectedPhoto
        } else {
            annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: annotationViewReuseIdentifier, name: customAnnotation.name, address: customAnnotation.address, mapItem: customAnnotation.mapItem ?? MKMapItem(), selectedPhoto: customAnnotation.selectedPhoto)
        }

        if let locationType = customAnnotation.locationType.flatMap(LocationType.init) {
            annotationView.image = locationType.pinImage
        } else {
            annotationView.image = UIImage(named: "default")
        }

        annotationView.accessibilityIdentifier = annotationViewReuseIdentifier
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        let customAnnotationView = view as? CustomAnnotationView

        let selection = PinSelection(
            name: customAnnotationView?.name,
            address: customAnnotationView?.address,
            photo: customAnnotationView?.selectedPhoto,
            startLocation: startLocation,
            endLocation: customAnnotationView?.mapItem
        )

        onPinSelected?(selection)
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

