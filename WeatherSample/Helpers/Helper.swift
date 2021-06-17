//
//  Helper.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func showAlert(withTitle title: String, message : String, onOkAction: (()->())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            onOkAction?()
        }
        alertController.addAction(OKAction)
        if UIApplication.shared.applicationState == .active{
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    func showAlert(message : String, onOkAction: (()->())? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: StaticData.KAppName, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                onOkAction?()
            }
            alertController.addAction(OKAction)
            if UIApplication.shared.applicationState == .active{
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

    
    func showAlert(message : String, onYESAction: @escaping (()->()), onNOAction: @escaping (()->())) {
        let alertController = UIAlertController(title: StaticData.KAppName, message: message, preferredStyle: .alert)
        let turnOnAction = UIAlertAction(title: "YES", style: .default) { action in
            onYESAction()
        }
        let cancelAction = UIAlertAction(title: "NO", style: .cancel) { action in
            onNOAction()
        }
        alertController.addAction(turnOnAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

        
}
