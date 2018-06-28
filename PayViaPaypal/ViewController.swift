//
//  ViewController.swift
//  PayViaPaypal
//
//  Created by Pratibha Gupta on 28/06/18.
//  Copyright © 2018 Pratibha Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.frame = UIScreen.main.bounds
        self.webView.scalesPageToFit = true
        self.view.addSubview(self.webView)
        loadAddressURL()
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadAddressURL() {

        self.webView.delegate = self
        let url = Bundle.main.url(forResource: "Checkout", withExtension: "html")
        let req = URLRequest(url: url!)
        self.webView.loadRequest(req)
        
        
    }
    
    func convertToDictionary(text: String?) -> [String: Any]? {
        
        guard let text = text else {
            return [:]
        }
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.url {
            
            if(url.absoluteString .contains("webapps/hermes/button")){
                
                //Send data from here to checkout file like amount, id of product
                var inputPayload = ["id": "123", "amount": "20"]
                inputPayload["token"] = "token \("ABCDEFGH")"
                let serializedData = try! JSONSerialization.data(withJSONObject: inputPayload, options: [])
                let encodedData = String(data: serializedData, encoding: String.Encoding.utf8)
                
                let _ = self.webView.stringByEvaluatingJavaScript(from: "setdetailsForProduct('\(encodedData!)')")
            }
            
            
            let _ = request.url?.scheme
            let _ = request.url?.host
            let jsonString = request.url?.fragment?.removingPercentEncoding
            let jsonDictionary = convertToDictionary(text: jsonString)
            
            if let jsonDictionary = jsonDictionary, let status = jsonDictionary["status"] as? String, let message = jsonDictionary["message"] as? String {
                print(status,message)
                
                if(status == "failed"){
                    //Transaction Failed show error message
                    self.navigationController?.popViewController(animated: true)
                }else{
                    //Transaction success
                    if let paymentId = jsonDictionary["paymentId"] as? String{
                        //Here you will receive payment Id send by server
                    }
                }
            }
        }
        
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
