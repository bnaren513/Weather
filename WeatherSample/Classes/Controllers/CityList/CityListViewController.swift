//
//  CityListViewController.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import UIKit
import CoreData

typealias loadDataCompletionHandler = (String?) -> Void

class CityListViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var completion: loadDataCompletionHandler!
    var viewModel = CityViewModel()
    
    
    var transitionDelegate = PopupTransitionDelegate()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    func bindViewModel()
    {
        viewModel.controller = self
        tableview.delegate = viewModel
        tableview.dataSource = viewModel
        // Do any additional setup after loading the view.
        viewModel.loadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let indexPath = tableview.indexPathForSelectedRow else {return}
        tableview.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func taponMap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddCityViewController") as! AddCityViewController
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = transitionDelegate
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapOnAdd(_ sender: Any)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionDelegate
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
}


extension CityListViewController : WeatherDelegate{
    func myVCDidFinishaddCity(_ property: WeatherObject) {
        let exist = viewModel.coreProvider.isExist(name: property.name!)
        if exist == false
        {
            viewModel.coreProvider.createData(data: property)
        }
        viewModel.loadData()
    }
}

