//
//  PayNowVC.swift
//  Utalii
//
//  Created by sid on 15/05/23.
//

import UIKit
import WebKit
import SwiftyJSON

var strCheck = ""

class PayNowVC: UIViewController,WKNavigationDelegate,WKUIDelegate{
    //MARK:- Outlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imgBack: UIImageView!
    
    //MARK:- Variable
    var weburl = "www.google.com"
    var parentVC = SelectATourVC()
    
    var issucsess = false
    var isHome = false
    var isBack = false
    var longi = ""
    var latti = ""
    var touristName = ""
    var guideName = ""
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        
        webView.uiDelegate = self

        print("URL IS::: \(weburl)")
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imgBack.changePngColorTo(color: white)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let url = URL(string: "about:blank")
          let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isBack = true
    }
     
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            if(isBack == false){
            if(webView.estimatedProgress != 1.0){
                IJProgressView.shared.showProgressView()
            }
            else {
                IJProgressView.shared.hideProgressView()
            }
            print(webView.estimatedProgress)
            }
        }
    }
    
    //MARK:- Our Function
    func customize() {
        self.webView.navigationDelegate = self
        IJProgressView.shared.showProgressView()
 
        let url = URL(string: weburl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //MARK:- DataSource & Delegete
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IJProgressView.shared.hideProgressView()
        if let url = webView.url?.absoluteString{
            print("URL IS ::: \(url)")
            if(url.contains("https://utaliiworld.com/payment/stripeStatus")){
                if(url.contains("Successful")){
                    let taxid1 = url.components(separatedBy: "txnId=")
                    let taxid2 = taxid1[1].components(separatedBy: "&orderId")
                    if(taxid2.count > 0){
                        issucsess = true
                        showAlert(withTitle:"Transaction Successful", withMessage: " Booking Successful \nTransaction ID: \(taxid2[0])")
                    }
                } else {
                    issucsess = false
                    showAlert1(withTitle:"Transaction failed", withMessage: "")
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        IJProgressView.shared.hideProgressView()
    }
    
    func convertBase64(string: String) -> String{
          if let data = (string).data(using: String.Encoding.utf8) {
              let base64 = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
           //   print(base64)// dGVzdDEyMw==\n
              return base64
          }
          return ""
      }
    
    func calltwilioAPI(msg: String,phone: String) {

        var tokanIS = ""
        let username = userName1
        let password1 = password1
        let credentials =  username+":"+password1
          
        tokanIS = "Basic \(convertBase64(string: credentials))"
         
        IJProgressView.shared.showProgressView()
        let dict = ["Body":msg,"To":phone,"From": fromNumber]
        
        APIhandler.SharedInstance.API_WithSendsmsParameters(aurl: API_SendSMS, auth: tokanIS, parameter: dict, completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            print("SMS DATA IS: \(apiResponce)")
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    //MARK:- ClickAction
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func showAlert(withTitle title: String, withMessage message:String) {
        
        // calltwilioAPI(msg: "SMS has been send to \(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")", phone: "\(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            
             //   self.parentVC.callSucsessPayment(isSucsess: self.issucsess)
      
            strCheck = "Yes"
            touristMainVC.viewBooking()
           
            
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showAlert1(withTitle title: String, withMessage message:String) {
        calltwilioAPI(msg: "SMS has been send to \(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")", phone: "\(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    //MARK:- Api Call
}
