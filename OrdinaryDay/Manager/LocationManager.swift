//
//  LocationManager.swift
//  OrdinaryDay
//
//  Created by Austin's Macbook Pro M3 on 10/4/24.
//

//import CoreLocation
import Foundation

//protocol LocationManager {
//    func auth()
//    func getLocation() -> CLLocation?
//}

//final class LocationManagerImpl: LocationManager {
//    private let clLocationManager = CLLocationManager()
//
//    func auth() {
//        switch clLocationManager.authorizationStatus {
//            case .authorizedWhenInUse:  // Location services are available.
//                break
//            case .restricted, .denied:  // Location services currently unavailable.
//                break
//            case .notDetermined:        // Authorization not determined yet.
//                clLocationManager.requestWhenInUseAuthorization()
//                break
//            default:
//                break
//            }
//    }
//
//    func getLocation() -> CLLocation? {
//        clLocationManager.location
//    }
//}
