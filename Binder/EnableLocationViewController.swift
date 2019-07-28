//
//  EnableLocationViewController.swift
//  Finder
//
//  Created by Rao Mudassar on 11/5/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import CoreLocation

class EnableLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        UserDefaults.standard.set("", forKey:"lat")
        UserDefaults.standard.set("", forKey:"lon")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // use the feature only available in iOS 9
        // for ex. UIStackView
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
               
                locationManager.startUpdatingLocation()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            print("location")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
      
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey:"lat")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey:"lon")
      
        manager.stopUpdatingLocation()
        
        
    }
   
    @IBAction func allowlocation(_ sender: Any) {
        
        if(UserDefaults.standard.string(forKey:"lat") == ""){
            
            let alertController = UIAlertController(title: NSLocalizedString("Finder", comment: ""), message: NSLocalizedString("Please enable your location.", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            self.performSegue(withIdentifier:"gotoHome", sender: self)
        }
        
    }
}
