//
//  Stripe_Connect_Webview.swift
//  Utalii
//
//  Created by IOSKOL on 02/11/23.
//

import UIKit
import WebKit
import SwiftyJSON
protocol stripe_Details:AnyObject{
    
    func StripeDetails_Receive(StripeID:String,StripeSuccess:Bool)
    
}

class Stripe_Connect_Webview: UIViewController,WKNavigationDelegate,WKUIDelegate {

 
    
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var imgBack: UIImageView!
    var weburl = "www.google.com"
    var issucsess = false
    var isHome = false
    var isBack = false
    var longi = ""
    var latti = ""
    var touristName = ""
    var guideName = ""
    var parentVC = SelectATourVC()
    weak var delegate: stripe_Details?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        webView.uiDelegate = self
        print("URL IS::: \(weburl)")
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func back_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        
    }
    func customize() {
        self.webView.navigationDelegate = self
        IJProgressView.shared.showProgressView()
 
        let url = URL(string: weburl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
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
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IJProgressView.shared.hideProgressView()
        if let url = webView.url?.absoluteString{
            print("URL IS ::: \(url)")
            if(url.contains("https://utaliiworld.com/payment/stripeConnectStatus")){
                if(url.contains("status=success")){
        
                        //issucsess = true
                        //showAlert(withTitle:"Transaction Successful", withMessage: " Booking Successful \nTransaction ID: \(taxid2[0])")
                    let urlString = url
                    let parameters = extractParameters(from: urlString)
                    print("statusMsg: \(parameters.statusMsg ?? "N/A")")
                    print("stripeaccId: \(parameters.stripeaccId ?? "N/A")")
                    print("userId: \(parameters.userId ?? "N/A")")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.StripeDetails_Receive(StripeID: parameters.stripeaccId ?? "", StripeSuccess: true)
                    }

                } else {
                    let urlString = url
                    let parameters = extractParameters(from: urlString)
                    print("statusMsg: \(parameters.statusMsg ?? "N/A")")
                    //print("stripeaccId: \(parameters.stripeaccId ?? "N/A")")
                    print("userId: \(parameters.userId ?? "N/A")")
                    issucsess = false
                    //showAlert1(withTitle:"Transaction failed", withMessage: parameters.statusMsg ?? "N/A")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.StripeDetails_Receive(StripeID: parameters.stripeaccId ?? "", StripeSuccess: false)
                    }

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
    func showAlert(withTitle title: String, withMessage message:String) {
        
        // calltwilioAPI(msg: "SMS has been send to \(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")", phone: "\(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            
             //   self.parentVC.callSucsessPayment(isSucsess: self.issucsess)
      
            self.navigationController?.popViewController(animated: true)

           
            
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showAlert1(withTitle title: String, withMessage message:String) {
      //  calltwilioAPI(msg: "SMS has been send to \(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")", phone: "\(UserDefaults.standard.string(forKey: KU_MOBILENO) ?? "")")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func extractParameters(from urlString: String) -> (statusMsg: String?, stripeaccId: String?, userId: String?) {
        if let url = URL(string: urlString),
           let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            
            var extractedParameters: (statusMsg: String?, stripeaccId: String?, userId: String?) = (nil, nil, nil)
            
            if let queryItems = components.queryItems {
                for item in queryItems {
                    if item.name == "statusMsg" {
                        extractedParameters.statusMsg = item.value
                    } else if item.name == "stripeaccId" {
                        extractedParameters.stripeaccId = item.value
                    } else if item.name == "userId" {
                        extractedParameters.userId = item.value
                    }
                }
            }
            
            return extractedParameters
        }
        
        return (nil, nil, nil)
    }
    
    
    
    
}



struct StripeDetailModel{
    var status = ""
    var error = ""
    var stripeUrl = ""
    var returnUrl = ""

    init(_ json: JSON) {
        error = json["error"].stringValue
        status = json["status"].stringValue
        stripeUrl = json["stripeUrl"].stringValue
        returnUrl = json["returnUrl"].stringValue
    }
}
