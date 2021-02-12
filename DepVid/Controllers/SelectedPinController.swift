//
//  SelectedPinController.swift
//  DepVid
//
//  Created by Michael Doroff on 2/12/21.
//

import UIKit

class SelectedPinController: UIViewController {
    
    var name: String?;
    var address: String?
    var photo: UIImage?
    
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
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: photo?.withRenderingMode(.alwaysOriginal))
        
        let stack = UIStackView(arrangedSubviews: [UIView(),nameLabel, addressLabel, imageView, UIView()])
        
        stack.axis = .vertical
        
    
        didSet()
        
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
}
