//
//  DirectionsMapController.swift
//  DepVid
//
//  Created by Michael Doroff on 2/16/21.
//

import UIKit
import MapKit

class DirectionsMapController: UIViewController {
    
    var name: String?
    var address: String?
    var startLocation: MKMapItem?
    var endLocation: MKMapItem?
    let mapView = MKMapView()
    var route: [MKRoute.Step]!
    
    override func viewDidLoad() {
        
        let nameAndAddressView = returnNameAndAddressLabel()
        
        view.addSubview(mapView)
        view.addSubview(nameAndAddressView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        nameAndAddressView.translatesAutoresizingMaskIntoConstraints = false
        
        nameAndAddressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        nameAndAddressView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        nameAndAddressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nameAndAddressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        
        mapView.trailingAnchor.constraint(equalTo: nameAndAddressView.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: nameAndAddressView.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: nameAndAddressView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addPinsToMap()
    
    }
    
    public func addPinsToMap() {
        
        guard let startlocationCoordinate = startLocation?.placemark.coordinate else { return }
        
        guard let endLocationCoordinate = endLocation?.placemark.coordinate else { return }
        
        let endAnnotation = MKPointAnnotation()
        
        endAnnotation.coordinate = endLocationCoordinate
        
        mapView.addAnnotation(endAnnotation)
    
        getDirections(startlocationCoordinate: startlocationCoordinate)
        
    }
    
    fileprivate func getDirections(startlocationCoordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: .init(latitude: startlocationCoordinate.latitude, longitude: startlocationCoordinate.longitude), span: span)
        
        // Use the MKDirections request for MapViews
        
        let directionsRequest = MKDirections.Request()

        directionsRequest.source = startLocation
        directionsRequest.destination = endLocation

        let directions = MKDirections(request: directionsRequest)

        directions.calculate { (res, err) in
            if let err = err {
                print("Failed to find routing info", err)
                return
            }

            if let firstRoute = res?.routes.first {
                self.mapView.addOverlay(firstRoute.polyline)
            }
            
            self.route = res?.routes.first?.steps

        }
        mapView.setRegion(region, animated: false)
    }
    
    fileprivate func returnNameAndAddressLabel() -> UIView {
        
        let nameAndAddressView = UIView()
        nameAndAddressView.backgroundColor = .white
        
        let namelabel = UILabel()
        namelabel.text = name
        namelabel.numberOfLines = 0
        
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        addressLabel.text = address
        
        let button = UIButton()
        button.addTarget(self, action: #selector(goToDirectionTable), for: .touchUpInside)
        button.setTitle("Get List Of Directions", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5.0
 
        let stack = UIStackView(arrangedSubviews: [namelabel, addressLabel])
    
        stack.axis = .vertical
        
        nameAndAddressView.addSubview(stack)
        nameAndAddressView.addSubview(button)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        stack.leadingAnchor.constraint(equalTo: nameAndAddressView.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: nameAndAddressView.trailingAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16).isActive = true
        button.leadingAnchor.constraint(equalTo: nameAndAddressView.leadingAnchor, constant: 16).isActive = true
        button.trailingAnchor.constraint(equalTo: nameAndAddressView.trailingAnchor, constant: -16).isActive = true
        
        return nameAndAddressView
        
    }
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = .init(width: 200, height: 200)
        return layout
    }()

    
    @objc fileprivate func goToDirectionTable() {
        
        let vc = DirectionsCollectionViewController(collectionViewLayout:flowLayout)
        vc.steps = Array(route[1...route.count-1])
        vc.startLocation = startLocation
        vc.endLocation = endLocation
        present(vc, animated: true)
        
    }
}
extension DirectionsMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if !(annotation is CustomAnnotation) { return nil }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.image = #imageLiteral(resourceName: "default")
        return annotationView
    }
}
