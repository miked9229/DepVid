//
//  DirectionsTableViewController.swift
//  DepVid
//
//  Created by Michael Doroff on 2/21/21.
//

import UIKit
import MapKit
import LBTATools


class DirectionsCollectionViewController: UICollectionViewController {
    
    var steps: [MKRoute.Step]!
    
    var cellid = "cellid"
    var cellheaderid = "cellheaderid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.register(DiectionsCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellheaderid)
        collectionView.register(DirectionsCell.self, forCellWithReuseIdentifier: cellid)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return steps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellid = "cellid"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? DirectionsCell else {
             return UICollectionViewCell()
        }
        
        cell.stepLabel.text = steps[indexPath.row].instructions
        return cell
    }
}

extension DirectionsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
