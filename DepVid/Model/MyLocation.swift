//
//  MyLocation.swift
//  DepVid
//
//  Created by Michael Doroff on 2/9/21.
//

import Foundation
import MapKit

struct Location {
    
    let locationName: String!
    let locationType: LocationType;
    let locationCoordinates: CLLocationCoordinate2D?
    let annotation: MKAnnotation?
    
    init(locationName: String?, locationType: LocationType, locationCoordinates: CLLocationCoordinate2D?) {
        self.locationName = locationName
        self.locationType = locationType
        self.locationCoordinates = locationCoordinates
    
        let annotation = CustomAnnotation()
        
        if let locationCoordinates = locationCoordinates {
            annotation.coordinate = locationCoordinates
        }
        
        self.annotation = annotation
    }
}

enum LocationType: String {
    case doctor = "doctor"
    case emergency = "emergency room"
    case pharmacy = "pharmacy"
    
}
