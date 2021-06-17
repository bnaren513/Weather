//
//  WeatherObject.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import Foundation

struct keys {
    static let coord = "coord"
    static let lon = "lon"
    static let lat = "lat"
    static let weather = "weather"
    static let main = "main"
    static let description = "description"
    static let icon = "icon"
    static let temp = "temp"
    static let feels_like = "feels_like"
    static let temp_min = "temp_min"
    static let temp_max = "temp_max"
    static let pressure = "pressure"
    static let humidity = "humidity"
    static let sea_level = "sea_level"
    static let grnd_level = "grnd_level"
    static let wind = "wind"
    static let speed = "speed"
    static let deg = "deg"
    static let clouds = "clouds"
    static let all = "all"
    static let dt = "dt"
    static let sys = "sys"
    static let country = "country"
    static let sunrise = "sunrise"
    static let sunset = "sunset"
    static let visibility = "visibility"
    static let name = "name"
}

class WeatherObject: NSObject {
    
    var name: String?
    var dt: Double?
    var visibility : Double?

     var coord : Coord?
     var weather: Weather?
     var main: Main?
     var wind: Wind?
     var clouds: Clouds?
     var sys: Sys?
    
    
    init(with dict: [String: Any]) {
        
        visibility = dict[keys.visibility] as? Double
        name = dict[keys.name] as? String
        dt = dict[keys.dt] as? Double
        if let dictionary = dict[keys.coord] as? [String: Any]{
            coord = Coord.init(with: dictionary)
        }
        if let dictionary = dict[keys.weather] as? [[String: Any]]{
            weather = Weather(with: dictionary.first!)
        }
        if let dictionary = dict[keys.main] as? [String: Any]{
            main = Main.init(with: dictionary)
        }
        if let dictionary = dict[keys.wind] as? [String: Any]{
            wind = Wind.init(with: dictionary)
        }
        if let dictionary = dict[keys.clouds] as? [String: Any]{
            clouds = Clouds.init(with: dictionary)
        }
        if let dictionary = dict[keys.sys] as? [String: Any]{
            sys = Sys.init(with: dictionary)
        }
    }

}
