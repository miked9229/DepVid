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

    var steps: [MKRoute.Step] = []
    var startLocation: MKMapItem?
    var endLocation: MKMapItem?

    var cellid = "cellid"
    var cellheaderid = "cellheaderid"

    convenience init() {
        self.init(collectionViewLayout: Self.makeLayout())
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        collectionView.backgroundColor = .white
        
        // very impotant to register the custom header and directions cell
        
        collectionView.register(DiectionsCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellheaderid)
        collectionView.register(DirectionsCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return steps.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? DirectionsCell else {
             return UICollectionViewCell()
        }
        
        cell.stepLabel.text = "\(indexPath.row + 1). \(steps[indexPath.row].instructions)"

        cell.stepLabel.numberOfLines = 2
        return cell
    }
}

extension DirectionsCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let endLoc = endLocation else { return UICollectionReusableView()}
        guard let locName = endLoc.name else { return UICollectionReusableView()}
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellheaderid, for: indexPath) as! DiectionsCellHeaderView
        header.directionsLabel.text = "Directions to \(locName)"
        return header
    }
}
