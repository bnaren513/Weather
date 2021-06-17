//
//  AddCityViewController.swift
//  SampleWeather
//
//  Created by OSIS-001 on 06/03/21.
//

import UIKit
import MapKit
import CoreLocation

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var addLocationButton: UIButton!
    
    var delegate: WeatherDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    var citiesArray = [String]()
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //var weatherArray = [AnyObject]()
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    var addModel = AddCityModel()
    let addCityViewModel = AddCityViewModel()
    let coreProvider = CoredataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.citiesArray = defaults.object(forKey: "cities") as? [String] ?? [String]()
        activityView.isHidden = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            
            locationManager.startUpdatingLocation()
            mapView.delegate = self
            mapView.showsUserLocation = true
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    //MARK:- Button Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
       // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocationButtonAction(_ sender: UIButton) {
        
        //self.mapView.centerCoordinate.
        activityView.isHidden = false
        activityIndicator.startAnimating()
        print("map center \(self.mapView.centerCoordinate)")
        let geoCode = CLGeocoder()
        let currentLocation = CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
        geoCode.reverseGeocodeLocation(currentLocation, preferredLocale: .current) { [weak self] (placeMarks, error) in
            
            guard let _self = self else {return}
            guard error == nil else {
                DispatchQueue.main.async {
                    _self.activityView.isHidden = true
                    _self.activityIndicator.stopAnimating()
                   // _self.showAlert(message: error?.localizedDescription ?? "")
                }
               
                return
            }
            
            guard let firstPlace = placeMarks?.first else {
                DispatchQueue.main.async {
                    _self.activityView.isHidden = true
                    _self.activityIndicator.stopAnimating()
                }
                return
            }
            
            print(firstPlace)
            
            _self.addModel.cityName = firstPlace.locality
            _self.addModel.latitude = firstPlace.location?.coordinate.latitude
            _self.addModel.longitude = firstPlace.location?.coordinate.longitude
            
            let urlStr = "\(Api.BASE_URL)\(Api.weather)lat=\((_self.addModel.latitude ?? 0))&lon=\(_self.addModel.longitude ?? 0)&appid=\(AppSecureKeys.API_KEY)"
            guard URL(string: urlStr) != nil else {
               
                return
            }
            guard let text = firstPlace.locality, !text.isEmptyString else {
                DispatchQueue.main.async {
                    _self.activityView.isHidden = true
                    _self.activityIndicator.stopAnimating()
                }
                return
                
            }
            //let method = "weather?q=\(text)&appid=\(AppSecureKeys.API_KEY)"
            let method = "\(Api.weather)lat=\((_self.addModel.latitude ?? 0))&lon=\(_self.addModel.longitude ?? 0)&appid=\(AppSecureKeys.API_KEY)"
            
            ServiceManager.sharedInstance.requestWithParameters(paramaters: "", andMethod:method , onSuccess: {(_ json: Any) -> Void in
                
                let folderdict : NSDictionary = json as! [String:Any] as NSDictionary
               
                                DispatchQueue.main.async {
                                    _self.activityView.isHidden = true
                                    _self.activityIndicator.stopAnimating()
                                }
                guard let result = json as? [String: Any] else {
                    
                    return
                }
                print(result)
                let weatherData = WeatherObject(with: result)
                if weatherData.name?.isEmptyString == false
                {
                    self?.delegate?.myVCDidFinishaddCity(weatherData)
                    self?.dismiss(animated: true, completion: nil)
                    if (!(self?.citiesArray.contains(text) ?? false))
                    {
                        self?.citiesArray.append(text)
                    let defaults = UserDefaults.standard
                        defaults.set(self?.citiesArray, forKey: "cities")
                    
                    print(weatherData)
                    }
                }
                else
                {
                    Utilities.displayError(message: StaticData.cityNameCheck, from: self ?? AddCityViewController())
                }
                //self?.weatherArray = folderdict["list"] as! [AnyObject];
               // self.controller?.forecastTableView.reloadData()
            },
            onError: {(_ error: Error?) -> Void in
                DispatchQueue.main.async {
                    _self.activityView.isHidden = true
                    _self.activityIndicator.stopAnimating()
                }
                print("Failed to login:\(error?.localizedDescription ?? "")")
            })
            

            
        }
        
        
        
    }
    
}


//MARK:- Core Location Delegate Methods

extension AddCityViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }else{
            //            self.showAlert(message: "Location permissions are not enabled. Please enble to access location") {
            //                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            //                    return
            //                }
            //
            //                if UIApplication.shared.canOpenURL(settingsUrl) {
            //                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            //                }
            //            }
            
//            self.showAlert(message: "Location permissions are not enabled. Please enble to access location") { [weak self] in
//                guard let _self = self else {return}
//                _self.locationManager.requestWhenInUseAuthorization()
//            } onNOAction: {
//
//            }
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("updated loaction --------\(locations.first?.coordinate)")
        guard let currentLocation = locations.first else {return}
        
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        //mapView.setRegion(region, animated: true)
        mapView.setCenter(center, animated: true)
        
    }
    
}


//MARK:- Map Kit Delegate Methods

extension AddCityViewController:MKMapViewDelegate{
    
    
}
