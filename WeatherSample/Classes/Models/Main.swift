//
//  Main.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//
import UIKit

class Main: NSObject, Codable {
    
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Int?
    var  humidity: Int?
    var sea_level: Int?
    var grnd_level: Int?

    
    init(with dict: [String: Any]) {
        temp = dict[keys.temp] as? Double
        feels_like = dict[keys.feels_like] as? Double
        temp_min = dict[keys.temp_min] as? Double
        temp_max = dict[keys.temp_max] as? Double
        pressure = dict[keys.pressure] as? Int
        humidity = dict[keys.humidity] as? Int
        sea_level = dict[keys.sea_level] as? Int
        grnd_level = dict[keys.grnd_level] as? Int
    }

}
