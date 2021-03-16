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
        if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country!
        }
        return addressString
    }
}

