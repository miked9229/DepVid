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
        
        let imageView = UIImageView(image: photo?.withRenderingMode(.alwaysOriginal))
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, addressLabel, UIView()])
        let imageStack = UIStackView(arrangedSubviews: [imageView])
        
        let totalStack = UIStackView(arrangedSubviews: [infoStack, imageView])
        
        imageStack.axis = .vertical
        infoStack.axis = .vertical
        
        totalStack.axis = .horizontal
        
        didSet()
        
        view.addSubview(infoStack)
        view.addSubview(imageView)
        view.addSubview(directionsButton)
        
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        infoStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        
        imageView.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        directionsButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24).isActive = true
        directionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        directionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
}
