//
//  HelpViewController.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 02/02/21.
//

import UIKit
import WebKit

class HelpViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet  var webpage: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webpage.navigationDelegate = self
       
        if let url = URL(string: Api.webpageurl){

            let requestObj = URLRequest(url: url as URL)
            webpage.load(requestObj)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:- WKNavigationDelegate

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    print(error.localizedDescription)
       
    }


    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Strat to load")
        
        }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("finish to load")
        
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
