//
//  ForecastViewController.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 02/02/21.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var forecastTableView: UITableView!
    var viewModel = ForeCastViewModel()
    var cityname :String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bindViewModel()
    }
    func bindViewModel ()
    {
        viewModel.controller = self
        forecastTableView.dataSource = viewModel
        forecastTableView.delegate = viewModel
        viewModel.loadData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
