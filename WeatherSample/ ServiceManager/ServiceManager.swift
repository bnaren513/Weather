//
//  ServiceManager.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 01/02/21.
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
        
        
        let url : NSString = Api.BASE_URL + path! as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        print(searchURL)
        
       // let serviceurl = URL(string: Api.BASE_URL + path!)
        var request : URLRequest = URLRequest(url: searchURL as URL)
        request.httpMethod = RequestType.get.rawValue
        request.setValue(ContentType.contentJSON.rawValue, forHTTPHeaderField: "Content-Type")
        _ = (params as AnyObject).description
        //NSJSONWritingPrettyPrinted
//        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//        var jsonString: String? = nil
//        if let aData = jsonData {
//            jsonString = String(data: aData, encoding: .utf8)
//        }
//        print("\(jsonString ?? "")")
//        let postData: Data? = jsonString?.data(using: .utf8, allowLossyConversion: true)
//        request.httpBody = postData
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
