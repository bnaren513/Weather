//
//  ViewController.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var temperataureLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    let locationManager = CLLocationManager()
    
    var viewModel = HomeViewModel()
    var transitionDelegate = PopupTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationGetting()
        self.bindViewModel()
    }
    
    func bindViewModel ()
    {
        viewModel.controller = self
       // viewModel.loadData()
    }
    
    @IBAction func tapOnAdd(_ sender: Any)
    {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CityListViewController") as! CityListViewController
        vc.completion = { name in
            self.viewModel.cityname = name ?? "Bangalore"
            self.viewModel.loadData()
        }
        self.present(vc, animated: true)
        
    }
    @IBAction func weatherShow() {
        let actionSheet = UIAlertController(title: "Weather Status", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Today", style: .default, handler: todayHandler))
        actionSheet.addAction(UIAlertAction(title: "Forecast", style: .default, handler: forecastHandler))
       

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    func forecastHandler(alert: UIAlertAction!) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ForecastViewController") as! ForecastViewController
        vc.cityname = viewModel.cityname
        self.present(vc, animated: true)
        
    }
    func todayHandler(alert: UIAlertAction!) {
        // Do something...
        let method = "weather?q=\(viewModel.cityname)&appid=\(AppSecureKeys.API_KEY)"
        
        viewModel.serviceCall(method: method)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Reset", style: .default, handler: resetHandler))
      
       

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func helpAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        self.present(vc, animated: true)
    }
    func resetHandler(alert: UIAlertAction!) {
        
        viewModel.coreProvider.deleteAllData("Weathers")
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "cities")
        viewModel.loadData()
    }
    
    
}

extension HomeViewController:CLLocationManagerDelegate{
    
    func locationGetting()
    {
        locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
    }
   
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }else{
                        self.showAlert(message: "Location permissions are not enabled. Please enble to access location") {
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                            }
                        }

            
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
    
            guard error == nil else {
                DispatchQueue.main.async {
                    
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
               
                return
            }
            
            guard let firstPlace = placemarks?.first else {
                
                return
            }
            
            print(firstPlace)
           
            //let method = "weather?q=\(text)&appid=\(AppSecureKeys.API_KEY)"
            let method = "\(Api.weather)lat=\((firstPlace.location?.coordinate.latitude ?? 0))&lon=\(firstPlace.location?.coordinate.longitude ?? 0)&appid=\(AppSecureKeys.API_KEY)"
            
            ServiceManager.sharedInstance.requestWithParameters(paramaters: "", andMethod:method , onSuccess: {(_ json: Any) -> Void in
                
                let folderdict : NSDictionary = json as! [String:Any] as NSDictionary
                guard let result = json as? [String: Any] else {
                    
                    return
                }
                print(result)
                let weatherData = WeatherObject(with: result)
                self.viewModel.configureData(data: weatherData)
                //self?.weatherArray = folderdict["list"] as! [AnyObject];
               // self.controller?.forecastTableView.reloadData()
            },
            onError: {(_ error: Error?) -> Void in
                
                print("Failed to login:\(error?.localizedDescription ?? "")")
            })
            

            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location)
    }
    
    
    
}
