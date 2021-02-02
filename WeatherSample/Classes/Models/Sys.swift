//
//  Sys.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
//

import UIKit

class Sys: NSObject,Codable {
    var country: String?
    var sunrise: Double?
    var sunset: Double?
    
    init(with dict: [String: Any]) {
        country = dict[keys.country] as? String
        sunrise = dict[keys.sunrise] as? Double
        sunset = dict[keys.sunset] as? Double
    }

}
