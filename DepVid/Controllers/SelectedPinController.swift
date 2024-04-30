//
//  SelectedPinController.swift
//  DepVid
//
//  Created by Michael Doroff on 2/12/21.
//

import UIKit
import MapKit

class SelectedPinController: UIViewController {
    
    var name: String?;
    var address: String?
    var photo: UIImage?
    var startLocation: MKMapItem?
    var endLocation: MKMapItem?
    var route: MKRoute?
    
    func didSet() {
        nameLabel.text = name
        addressLabel.text = address
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        return label
    }()
    
    var addressLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var directionsButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Get Directions", for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5.0
        return button
        
    }()
    
    @objc func getDirections() {
        
        let directionsMapController = DirectionsMapController()
        directionsMapController.name = name
        directionsMapController.address = address
        directionsMapController.startLocation = startLocation
        directionsMapController.endLocation = endLocation
        present(directionsMapController, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        didSet()
        
        let imageView = UIImageView(image: photo?.withRenderingMode(.alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            addressLabel,
            imageView,
            directionsButton
        
        ])
        stack.spacing = 20
        stack.axis = .vertical
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
