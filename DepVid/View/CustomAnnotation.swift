//
//  CustomAnnotation.swift
//  DepVid
//
//  Created by Michael Doroff on 2/9/21.
//

import MapKit

class CustomAnnotation: MKPointAnnotation {
    
    var name: String?
    var address: String?
    var locationType: String?
    var mapItem: MKMapItem?
    
    init(name: String?, address: String?, locationType: String?, mapItem: MKMapItem?) {
        self.name = name
        self.address = address
        self.locationType = locationType
        self.mapItem = mapItem
        
    }
    
}
