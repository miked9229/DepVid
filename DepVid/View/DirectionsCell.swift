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
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        stepLabel.font = .systemFont(ofSize: 14)
        NSLayoutConstraint.activate([
            stepLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stepLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stepLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stepLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
