//
//  CityViewModel.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import UIKit
import CoreData

class CityViewModel: NSObject  {
    
    var controller : CityListViewController?
    lazy var coreProvider: CoredataProvider = {
        return CoredataProvider()
    }()
    var manageObjectContext: NSManagedObjectContext!
    
    var data = [NSManagedObject]()
   
    
    override init() {
        super.init()
    }
    
    func loadData(){
        data.removeAll()
        coreProvider.fetchrequest(completion: { (dict) in
            guard let result = dict else{return}
            OperationQueue.main.addOperation {
                self.data.append(contentsOf: result)
                self.controller?.tableview.reloadData()
            }
        })
        
    }
}
extension CityViewModel: UITableViewDelegate, UITableViewDataSource
{
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = data.count
    if count == 0 {
        tableView.show(messaage: "No Cities")
        tableView.separatorStyle = .none
        
    }else {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
    return count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
    let rowdata = data[indexPath.row]
    cell.cityName.text = rowdata.value(forKeyPath: "name") as? String
    if let temp = rowdata.value(forKeyPath: "temp") as? Double{
        let celsius = convertTemp(temp: temp, from: .kelvin, to: .celsius) // 18°C
        cell.temparatureLabel.text = "\(celsius)"
    }
    return cell
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let rowdata = data[indexPath.row]
    let name = rowdata.value(forKeyPath: "name") as? String
    controller?.dismiss(animated: true) {
        self.controller?.completion(name)
    }
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        
        //remove object from core data
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        manageObjectContext.delete(data[indexPath.row] as NSManagedObject)
        do {
            try manageObjectContext.save() }
        catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
        
        //update UI methods
        tableView.beginUpdates()
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
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


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
}
}
