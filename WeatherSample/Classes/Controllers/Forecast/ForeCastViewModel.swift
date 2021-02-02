//
//  ForeCastViewModel.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 02/02/21.
//


import UIKit

class ForeCastViewModel: NSObject  {
    var controller : ForecastViewController?

    var weatherArray = [AnyObject]()
    
    override init() {
        super.init()
    }
    func loadData()
    {
        let method = "\(Api.forecast)?q=\(controller!.cityname )&appid=\(AppSecureKeys.API_KEY)"
        
        serviceCall(method: method)
    }
    func serviceCall(method :String)
    {
        ServiceManager.sharedInstance.requestWithParameters(paramaters: "", andMethod:method , onSuccess: {(_ json: Any) -> Void in
            
            let folderdict : NSDictionary = json as! [String:Any] as NSDictionary
           
            self.weatherArray = folderdict["list"] as! [AnyObject];
            self.controller?.forecastTableView.reloadData()
        },
        onError: {(_ error: Error?) -> Void in
            
            print("Failed to login:\(error?.localizedDescription ?? "")")
        })
    }
    
    
}
extension ForeCastViewModel: UITableViewDelegate, UITableViewDataSource
{
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = weatherArray.count
        if count == 0 {
            tableView.show(messaage: "No data found")
            tableView.separatorStyle = .none
            
        }else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastcell", for: indexPath) as! ForecastTableViewCell
        // create a new cell if needed or reuse an old one
        let dict: NSDictionary = weatherArray[indexPath.row] as! NSDictionary
        
        print(dict)
        let data = WeatherObject(with: dict as! [String : Any])
       
        print(data)
        if  let temp = data.main?.feels_like{
            let celsiusTemp = temp - 273.15
            cell.feelslikeLabel?.text =  "Feelslike  =  \(String(format: "%.0f%@", "\u{00B0}", celsiusTemp))"
            
        }
        if let visibility = data.visibility{
            let formatedString = String(format:"%.2f",Float(visibility / 1000.0 + 0.005))
            cell.visibilityLabel?.text =  "Visibility  =  \(formatedString) Km"
           
        }
        
        if let humidity = data.main?.humidity{
            
            cell.humidityLabel?.text =  "Humidity  =  \(humidity)%"
        }
        
        
        if let wind = data.wind?.speed{
            
            cell.windLabel?.text =  "Wind  =  \(wind) Kmph"
        }
        if  let temp = data.main?.temp{
            let celsius = convertTemp(temp: temp, from: .kelvin, to: .celsius) // 18°
            
            cell.temparatureLabel?.text =  "Temprature  =  \(String(describing: celsius))"
        }
        
        // set the text from the data model
       
        cell.dateLabel.text = "Date =  \(timestamptoDate(timestamp: data.dt ?? 0.0))"
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    func timestamptoDate(timestamp :Double) -> String
    {
        
             let date = NSDate(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = NSTimeZone() as TimeZone
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
        
    }
    
}
