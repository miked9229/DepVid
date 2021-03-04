//
//  DirectionsCellHeader.swift
//  DepVid
//
//  Created by Michael Doroff on 2/21/21.
//

import UIKit
import MapKit
import LBTATools

class DiectionsCellHeaderView: UICollectionReusableView {

    var endLocation: MKMapItem?
    
    let directionsLabel = UILabel(text: "Directions", font: .boldSystemFont(ofSize: 16), textColor: .black, textAlignment: .center, numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    
    }
    
    private func setupViews() {
        
        addSubview(directionsLabel)
        
        directionsLabel.centerXToSuperview()
        directionsLabel.centerYToSuperview()
        
        
        directionsLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16).isActive = true
        
        directionsLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
