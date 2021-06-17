//
//  PopViewModel.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//


import UIKit

class PopViewModel: NSObject  {
    
    var controller : PopupViewController?
    lazy var coreProvider: CoredataProvider = {
        return CoredataProvider()
    }()
    
    
    var citiesArray = [String]()
    
    override init() {
        super.init()
    }
    
    func loadData()
    {
        controller?.holdingView.layer.cornerRadius = 10
        controller?.add_txt.delegate = controller ?? PopupViewController()
        // Register the table view cell class and its reuse id
        let defaults = UserDefaults.standard
        self.citiesArray = defaults.object(forKey: "cities") as? [String] ?? [String]()
    }
    func doneAction()
    {
        guard let text = controller?.add_txt.text, !text.isEmptyString else {return}
        
        
        let method = "weather?q=\(text)&appid=\(AppSecureKeys.API_KEY)"
        
        ServiceManager.sharedInstance.requestWithParameters(paramaters: "", andMethod:method , onSuccess: {(_ json: Any) -> Void in
            
            
            guard let result = json as? [String: Any] else {
                
                return
            }
            print(result)
            let weatherData = WeatherObject(with: result)
            if weatherData.name?.isEmptyString == false
            {
                self.controller?.delegate?.myVCDidFinishaddCity(weatherData)
                self.controller?.dismiss(animated: true, completion: nil)
                if (!(self.citiesArray.contains(text)))
                {
                self.citiesArray.append(text)
                let defaults = UserDefaults.standard
                defaults.set(self.citiesArray, forKey: "cities")
                
                print(weatherData)
                }
            }
            else
            {
                Utilities.displayError(message: StaticData.cityNameCheck, from: self.controller ?? PopupViewController())
            }
            
            //self.configureData(data: weatherData)
            
        },
        onError: {(_ error: Error?) -> Void in
            
            print("Failed to login:\(error?.localizedDescription ?? "")")
        })
    }
    
}

extension PopViewModel: UITableViewDelegate, UITableViewDataSource
{
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = citiesArray.count
        if count == 0 {
            tableView.show(messaage: "No Cities")
            tableView.separatorStyle = .none
            
        }else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (controller?.citiesTablview?.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        // set the text from the data model
        cell.textLabel?.text = self.citiesArray[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        controller?.add_txt.text = self.citiesArray[indexPath.row]
    }
}


