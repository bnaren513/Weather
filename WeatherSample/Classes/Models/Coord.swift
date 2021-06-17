//
//  Coord.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//


import UIKit

class Coord: NSObject, Codable {
    var lon: Double?
    var lat: Double?
    init(with dict: [String: Any]) {
        lon = dict[keys.lon] as? Double
        lat = dict[keys.lat] as? Double
    }


}
