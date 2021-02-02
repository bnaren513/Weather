//
//  Wind.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
//

import UIKit

class Wind: NSObject {
    
    var speed: Double?
    var deg: Double?
    
    init(with dict: [String: Any]) {
        speed = dict[keys.speed] as? Double
        deg = dict[keys.deg] as? Double
    }


}
