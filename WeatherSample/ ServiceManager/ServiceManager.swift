//
//  ServiceManager.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import Foundation

public typealias SuccessCallback = (_ json: [AnyHashable: Any]?) -> Void
public typealias SuccessCallbackWithObjects = (_ objects: [Any]?) -> Void
public typealias ErrorCallback = (_ error: Error?) -> Void
public typealias ProgressBlock = (_ progress: Float) -> Void

class ServiceManager :NSObject
{
    
    
    enum RequestType: String {
        case get    = "GET"
        case post = "POST"
    }
    
    enum ContentType: String {
        case contentJSON = "application/json"
    }
    

    static let sharedInstance : ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()
    
    override init() {
        super.init()
    }
    func requestWithParameters(paramaters params: Any, andMethod path: String?, onSuccess: @escaping SuccessCallback, onError: @escaping ErrorCallback) {
        
        guard let serviceUrl = URL(string: Api.BASE_URL + path!) else { return  }
        
        print(serviceUrl)
        
        var request : URLRequest = URLRequest(url: serviceUrl as URL)
        
        
        request.httpMethod = RequestType.get.rawValue
        request.setValue(ContentType.contentJSON.rawValue, forHTTPHeaderField: "Content-Type")
        _ = (params as AnyObject).description
       
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let data = data,
                   let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    print(jsonResult)
                    //Use GCD to invoke the completion handler on the main thread
                    DispatchQueue.main.async() {
                        onSuccess(jsonResult as? [AnyHashable : Any])
                    }
                }
            } catch let error as NSError {
                
                
                print(error.localizedDescription)
                print(error.code)
                onError(error.localizedDescription as? Error)
            }
        }
        dataTask.resume()
    }
    
    
    
    
    
    
}
