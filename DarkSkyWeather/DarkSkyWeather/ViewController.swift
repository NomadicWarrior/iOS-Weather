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
    @IBOutlet weak var weatherIcon: UIImageView!
    
    let locationManager = CLLocationManager();
    
    // url addres and key given by darksky website
    let weatherURL = "https://api.darksky.net/forecast/8c266d664d6da6b7123b05fa0b23e4b8/"
    
    
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
            
            // Call
            getWeatherData(url: weatherURL, latitude: lat, longitude: lon)
        }
    }
    
    // If can't find location [no internet connection or airplane mode]
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
    
    // Get Weather from DarkSky Website
    func getWeatherData(url: String, latitude: String, longitude: String)
    {
       let urlStr = "\(weatherURL)\(latitude),\(longitude)"
        Alamofire.request(urlStr, method: .get,parameters: nil).responseJSON
            {
                response in
                if response.result.isSuccess
                {
                    let weatherJSON : JSON = JSON(response.result.value!)
                    self.updateWeatherDate(json: weatherJSON)
                }
                else
                {
                    print("Error")
                }
        }
        
    }
    
    func updateWeatherDate(json: JSON)
    {
        if let tempResult = json["currently"]["temperature"].double
        {
            let fahrResult = Int(tempResult)
            let temp = (fahrResult - 32) * 5 / 9
            tempLabel.text = String(temp)
            cityLabel.text = json["timezone"].stringValue
            weatherDescriptionLabel.text = json["currently"]["summary"].stringValue
        }
        else
        {
            
        }
    }
}

