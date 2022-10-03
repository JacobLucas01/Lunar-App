//
//  LocationManager.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/17/22.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//
//    @Published var location: CLLocation?
//
//    var locationManager: CLLocationManager?
//
//    func checkIfLocationServicesIsEnable() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager?.requestAlwaysAuthorization()
//            locationManager?.startUpdatingLocation()
//            locationManager!.delegate = self
//        } else {
//            print("Location services denied")
//        }
//    }
//
//    private func checkLocationAuthorization() {
//        guard let locationManager = locationManager else { return }
//
//        switch locationManager.authorizationStatus {
//
//        case .notDetermined:
//            locationManager.requestAlwaysAuthorization()
//        case .restricted:
//            print("Your location is restricted")
//        case .denied:
//            print("Your location is denied. Go into app to change it.")
//        case .authorizedAlways, .authorizedWhenInUse:
//            location = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
//            break
//        @unknown default:
//            break
//        }
//
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
//}


class LocationManager: NSObject,CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    @Published var location = CLLocation()
    @Published var loc = CLLocationCoordinate2D()
    

    private let manager = CLLocationManager()
    
    override init() {
            super.init()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locations.last.map {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                )
                location = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                loc = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            }
        }
}
