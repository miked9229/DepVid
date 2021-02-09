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
    
    
    override init() {
        super.init()
    }
    
}
