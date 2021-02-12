//
//  CustomCallOutView.swift
//  DepVid
//
//  Created by Michael Doroff on 2/12/21.
//

import UIKit

class CustomCallOutView: UIView {
    
    var name: String?
    var address: String?
    var photo: UIImage?
    
     var exitButton: UIButton = {
        
        let exitButton = UIButton(type: .close)
        exitButton.addTarget(self, action: #selector(exitCommand), for: .touchUpInside)
        return exitButton
        

    }()
    
    @objc private func exitCommand() {
        self.removeFromSuperview()
        print("Remove from superview!")
    }
    
    var nameLabel: UILabel = {
        
        let nameLabel = UILabel()
        return nameLabel
        
    }()
    
    var addressLabel: UILabel = {
        
        let addressLabel = UILabel()
        return addressLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public convenience init(name: String?, address: String?, photo: UIImage?) {
        self.init(frame: .zero)
        self.name = name
        self.address = address
        self.photo = photo
        setupCustomCallOut()
    }
    
    
    public func setupCustomCallOut() {
        
        self.backgroundColor = .red
        
        nameLabel.text = name
        
        addSubview(exitButton)
//        addSubview(nameLabel)
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        exitButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        exitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
