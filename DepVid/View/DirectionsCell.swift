//
//  DirectionsCell.swift
//  DepVid
//
//  Created by Michael Doroff on 2/21/21.
//

import UIKit
import LBTATools

class DirectionsCell: UICollectionViewCell {

    var stepLabel = UILabel(text: "Test")
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stepLabel)
        
        backgroundColor = .white
     
        stepLabel.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
