//
//  HomeViewModel.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
//


import UIKit

import UIKit

class HomeViewModel: NSObject  {
    
    var controller : HomeViewController?
    var cityname = "Bangalore"
    lazy var coreProvider: CoredataProvider = {
        return CoredataProvider()
    }()
    
    var weather: WeatherObject?
    
    override init() {
        super.init()
    }
    
    func loadData()
    {
        let method = "weather?q=\(cityname)&appid=\(AppSecureKeys.API_KEY)"
        
        serviceCall(method: method)
    }
    func serviceCall(method :String)
    {
        ServiceManager.sharedInstance.requestWithParameters(paramaters: "", andMethod:method , onSuccess: {(_ json: Any) -> Void in
            
            
            guard let result = json as? [String: Any] else {
               
                return
            }
            print(result)
            let weatherData = WeatherObject(with: result)
           
            print(weatherData)
           
              
                self.configureData(data: weatherData)
            
        },
        onError: {(_ error: Error?) -> Void in
            
            print("Failed to login:\(error?.localizedDescription ?? "")")
        })
    }
    
    func configureData(data:WeatherObject)
    {
        let exist = coreProvider.isExist(name: cityname)
        if exist == false
        {
            coreProvider.createData(data: data)
        }
        controller?.cityNameLabel.text = data.name ?? "N/A"
        controller?.descriptionLabel.text = data.weather?.description_str ?? "N/A"
        
        if  let temp = data.main?.temp{
            let celsius = convertTemp(temp: temp, from: .kelvin, to: .celsius) // 18°C
            controller?.temperataureLabel.text = "\(celsius)"
        }
        
        if  let temp = data.main?.feels_like{
            let celsiusTemp = temp - 273.15
            controller?.feelslikeLabel.text = String(format: "%.0f%@", "\u{00B0}", celsiusTemp)
        }
        
        if let visibility = data.visibility{
            let formatedString = String(format:"%.2f",Float(visibility / 1000.0 + 0.005))
            controller?.visibilityLabel.text = "\(formatedString) Km"
        }
        
        if let humidity = data.main?.humidity{
            controller?.humidityLabel.text = "\(humidity)%"
        }
        
        
        if let wind = data.wind?.speed{
            controller?.windLabel.text = "\(wind) Kmph"
        }
        
        if let sunrise = data.sys?.sunrise{
            let time = timeStringFromUnixTime(unixTime:sunrise)
            controller?.sunriseLabel.text = "\(time)"
        }
        
        if let sunset = data.sys?.sunset{
            let time = timeStringFromUnixTime(unixTime:sunset)
            controller?.sunsetLabel.text = "\(time)"
        }
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        controller?.timeLabel.text = "\(dateString)"
        
        if  let lat = data.coord?.lat {
            controller?.lattitudeLabel.text = "Latitude: \(lat)"
        }
        if  let long = data.coord?.lon{
            controller?.longitudeLabel.text = "Longitude: \(long)"
        }
        
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date as Date)
    }
    
    
}
extension String{
    var isEmptyString: Bool {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        return false
    }
    
}


