//
//  Weather.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
//

import Foundation
import UIKit

class Weather: NSObject, Codable {
    var description_str: String?
    var weatherDescription: String?
    var icon: String?
    init(with dict: [String: Any]) {
        description_str = dict[keys.main] as? String
        weatherDescription = dict[keys.description] as? String
        icon = dict[keys.icon] as? String
    }

}
