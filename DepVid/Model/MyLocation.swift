//
//  MyLocation.swift
//  DepVid
//
//  Created by Michael Doroff on 2/9/21.
//

import UIKit

enum LocationType: String {
    case doctor = "doctor"
    case emergency = "emergency room"
    case pharmacy = "pharmacy"

    /// The detail-photo shown on a selected-pin callout/detail screen.
    var pinPhoto: UIImage? {
        switch self {
        case .emergency: return UIImage(named: "emergencyphoto")
        case .doctor:     return UIImage(named: "hospitalphoto")
        case .pharmacy:   return UIImage(named: "pharmacistphoto")
        }
    }

    /// The map-pin glyph used in the annotation view.
    var pinImage: UIImage? {
        switch self {
        case .pharmacy:  return UIImage(named: "greenMapPin")
        case .doctor:    return UIImage(named: "blueMapPin")
        case .emergency: return UIImage(named: "redMapPin")
        }
    }
}
