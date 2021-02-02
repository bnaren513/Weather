//
//  ViewController.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
//

import UIKit

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
    
    var viewModel = HomeViewModel()
    var transitionDelegate = PopupTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bindViewModel()
    }
    
    func bindViewModel ()
    {
        viewModel.controller = self
        viewModel.loadData()
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
    func resetHandler(alert: UIAlertAction!) {
        
        viewModel.coreProvider.deleteAllData("Weathers")
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "cities")
        viewModel.loadData()
    }
    
    
}

