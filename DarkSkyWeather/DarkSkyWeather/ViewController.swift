//
//  ViewController.swift
//  DarkSkyWeather
//
//  Created by Nomadic on 12/24/19.
//  Copyright © 2019 Nomadic. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate
{
    // UI Lables
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationManager = CLLocationManager();
    
    // url addres and key given by darksky website
    let weatherURL = ""
    let key = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        // Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // Get GPS Coordinate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0
        {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longtitude = \(location.coordinate.longitude), latitude \(location.coordinate.latitude)")
            
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            
            
            let params : [String : String] = ["key" : key, "latitude": lat, "longitude" : lon]
            
            getWeatherData(url: weatherURL, parametr: params)
        }
    }
    
    // If can't find location [no internet connection or airplane mode]
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
    // Get Weather from DarkSky Website
    func getWeatherData(url: String, parametr: [String : String])
    {
        Alamofire.request(url, method: .get, parameters: parametr).responseJSON
            {
                response in
                if response.result.isSuccess
                {
                    print("Success")
                }
                else
                {
                    print("Error")
                }
        }
        
    }
}

