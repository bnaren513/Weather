//
//  Clouds.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//
import UIKit

class Clouds: NSObject,Codable {
    
    var all: Int?

    init(with dict: [String: Any]) {
        all = dict[keys.all] as? Int
    }
}
