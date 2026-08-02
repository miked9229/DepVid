//
//  AppCoordinator.swift
//  DepVid
//

import UIKit
import MapKit

struct PinSelection {
    let name: String?
    let address: String?
    let photo: UIImage?
    let startLocation: MKMapItem?
    let endLocation: MKMapItem?
}

struct DirectionsRequest {
    let name: String?
    let address: String?
    let startLocation: MKMapItem?
    let endLocation: MKMapItem?
}

/// Owns the Map -> SelectedPin -> DirectionsMap -> DirectionsList navigation flow,
/// so view controllers don't need to know how to construct/present the next screen.
final class AppCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let mapVC = MapViewController()
        mapVC.onPinSelected = { [weak self] selection in
            self?.showSelectedPin(selection)
        }
        window.rootViewController = mapVC
        window.makeKeyAndVisible()
    }

    private func showSelectedPin(_ selection: PinSelection) {
        let pinController = SelectedPinController()
        pinController.name = selection.name
        pinController.address = selection.address
        pinController.photo = selection.photo
        pinController.startLocation = selection.startLocation
        pinController.endLocation = selection.endLocation
        pinController.onGetDirections = { [weak self] directions in
            self?.showDirectionsMap(from: pinController, directions)
        }
        window.rootViewController?.present(pinController, animated: true)
    }

    private func showDirectionsMap(from presenter: UIViewController, _ directions: DirectionsRequest) {
        let directionsVC = DirectionsMapController()
        directionsVC.name = directions.name
        directionsVC.address = directions.address
        directionsVC.startLocation = directions.startLocation
        directionsVC.endLocation = directions.endLocation
        directionsVC.onShowDirectionsList = { [weak self, weak directionsVC] route, startLocation, endLocation in
            guard let directionsVC else { return }
            self?.showDirectionsList(from: directionsVC, route: route, startLocation: startLocation, endLocation: endLocation)
        }
        presenter.present(directionsVC, animated: true)
    }

    private func showDirectionsList(from presenter: UIViewController, route: [MKRoute.Step], startLocation: MKMapItem?, endLocation: MKMapItem?) {
        let listVC = DirectionsCollectionViewController()
        listVC.steps = route
        listVC.startLocation = startLocation
        listVC.endLocation = endLocation
        presenter.present(listVC, animated: true)
    }
}
