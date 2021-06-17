//
//  AddCityViewModel.swift
//  SampleWeather
//
//  Created by OSIS-001 on 06/03/21.
//

import Foundation
import CoreLocation

class AddCityViewModel{
    
    func addCityValidation(model:AddCityModel, onSuccessCompletion:()->(), onFailureCompletion:(String)->()){
        
//        guard let _ = model.cityName, let _ = model.latitude, let _ = model.longitude else {
//            onFailureCompletion(MessageStrings.kSelectLocation)
//            return
//        }
        
           
        onSuccessCompletion()
    }
    
    
//    func getSelectedLocationDetails(model:AddCityModel, onSuccessCompletion:@escaping(CityModel)->(), onFailureCompletion:@escaping(String)->()){
//
//        let urlStr = "\(AppUrls.baseUrl)\(AppUrls.weather)lat=\((model.latitude ?? 0))&lon=\(model.longitude ?? 0)&appid=\(AppUrls.appID)"
//        guard let url =  URL(string: urlStr) else {
//            onFailureCompletion(MessageStrings.KSomethingWrong)
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = RequestMethod.Post.value()
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        APIClient.shared.getData(request: request) { (data, resCode, error) in
//
//            if let _error = error{
//                onFailureCompletion(_error.localizedDescription)
//            }else{
//
//                if let _dataDict = data as? [String:Any]{
//
//                    let cityModel = CityModel(dict: _dataDict)
//
//                    onSuccessCompletion(cityModel)
//                }
//            }
//        }
        
   // }
    
}
