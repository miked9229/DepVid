//
//  CustomAnnotationView.swift
//  DepVid
//
//  Created by Michael Doroff on 2/12/21.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    var name: String?
    var address: String?
    var mapItem: MKMapItem?
    var selectedPhoto: UIImage?

    init(annotation: MKAnnotation?, reuseIdentifier: String?, name: String?, address: String?, mapItem: MKMapItem, selectedPhoto: UIImage?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.name = name
        self.address = address
        self.mapItem = mapItem
        self.selectedPhoto = selectedPhoto
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
