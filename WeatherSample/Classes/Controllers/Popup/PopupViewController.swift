//
//  PopupViewController.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import UIKit
import CoreData

protocol WeatherDelegate:class {
    func myVCDidFinishaddCity(_ property: WeatherObject)
}

class PopupViewController: UIViewController,UITextViewDelegate  {
    @IBOutlet weak var add_txt: UITextView!
    @IBOutlet weak var holdingView: UIView!
    var delegate: WeatherDelegate?
    
    var viewModel = PopViewModel()
    
    
    @IBOutlet weak var citiesTablview:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.bindViewModel()
    }
    
    func bindViewModel()
    {
        viewModel.controller = self
        citiesTablview.delegate = viewModel
        citiesTablview.dataSource = viewModel
        viewModel.loadData()
    }
    
    
    @IBAction func done(_ sender: Any)
    {
        
        viewModel.doneAction()
        
    }
    
    
    @IBAction func onTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
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
extension UITableView{
    func show(messaage: String) {
        let label = UILabel()
        label.frame = self.bounds
        label.text = messaage
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        self.backgroundView = label
    }
}
class Utilities : NSObject {
    static func displayError(message text: String, from viewController: UIViewController) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
}
