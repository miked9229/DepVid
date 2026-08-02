//
//  MKMapItem.swift
//  DepVid
//
//  Created by Michael Doroff on 2/12/21.
//

import MapKit

// This utility function was written by Brian Voong (https://github.com/bhlvoong) and assists users
// in parsing the address of the placemark from MKMapItem items.
// code was learned from https://www.letsbuildthatapp.com/course/Maps%20UIKit%20SwiftUI

// Proper Citation:
// Brian Voong
// 2021-02-12
// Maps UIKit SwiftUI
// Code version: Unknown
// Type: Source Code
// https://www.letsbuildthatapp.com/course/Maps%20UIKit%20SwiftUI

extension MKMapItem {
    
    func address() -> String {

        var addressString = ""
        if let subThoroughfare = placemark.subThoroughfare {
            addressString = subThoroughfare + " "
        }
        if let thoroughfare = placemark.thoroughfare {
            addressString += thoroughfare + ", "
        }
        if let postalCode = placemark.postalCode {
            addressString += postalCode + " "
        }
        if let locality = placemark.locality {
            addressString += locality + ", "
        }
        if let administrativeArea = placemark.administrativeArea {
            addressString += administrativeArea + " "
        }
        if let country = placemark.country {
            addressString += country
        }
        return addressString
    }
}

