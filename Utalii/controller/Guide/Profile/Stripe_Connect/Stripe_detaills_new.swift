//
//  Stripe_detaills_new.swift
//  Utalii
//
//  Created by IOSKOL on 14/12/23.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreMedia



class Stripe_detaills_new: UIViewController {
    
    @IBOutlet weak var stripe_ID: UILabel!
    @IBOutlet weak var NAME: UILabel!
    
    @IBOutlet weak var PHONE: UILabel!
    
    @IBOutlet weak var EMAIL: UILabel!
    @IBOutlet weak var WEBSITE: UILabel!
    @IBOutlet weak var COUNTRY: UILabel!
    
    @IBOutlet weak var CHARGES_ENABLED: UILabel!
    
    @IBOutlet weak var CREATED: UILabel!
    
    @IBOutlet weak var DEFAULT_CURRENCY: UILabel!
    
    @IBOutlet weak var PAYOUT_ENABLED: UILabel!
    
    @IBOutlet weak var TYPE: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddetails()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func loaddetails(){
       
        
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        APIhandler.SharedInstance.API_WithParameters(aurl: API_StripeConnectDetails, parameter: dict, completeBlock: { [self] (responseObj) in
            IJProgressView.shared.hideProgressView()
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            print("The response is \(responseObj.value(forKey: "status"))")
            let status = responseObj.value(forKey: "status") as! String
            let dict = responseObj.value(forKey: "stripeInfo") as! NSDictionary
            if(status == "1"){
            print("OK")
                let name = dict.value(forKey: "name") as! String
                self.NAME.text = name
                
                let email = dict.value(forKey: "email") as! String
                self.EMAIL.text = email
                let phone = dict.value(forKey: "phone") as! String
                self.PHONE.text = phone
                let stripeId = dict.value(forKey: "stripeId") as! String
                self.stripe_ID.text = stripeId
                let type = dict.value(forKey: "type") as! String
                self.TYPE.text = type
                
                let website = dict.value(forKey: "website") as! String
                self.WEBSITE.text = website
                
                let country = dict.value(forKey: "country") as! String
                self.COUNTRY.text = country
                let charges_enabled = dict.value(forKey: "charges_enabled") as! Bool
                if(charges_enabled){
                    self.CHARGES_ENABLED.text = "True"
                }else
                {
                    self.CHARGES_ENABLED.text = "False"
                    
                }
                
                
                let created = dict.value(forKey: "created") as! NSNumber
                self.CREATED.text = ("\(created)")
               
                let default_currency = dict.value(forKey: "default_currency") as! String
                self.DEFAULT_CURRENCY.text = default_currency
                
                let payouts_enabled = dict.value(forKey: "payouts_enabled") as! Bool
                
                if(payouts_enabled){
                    self.PAYOUT_ENABLED.text = "True"
                }else
                {
                    self.PAYOUT_ENABLED.text = "False"
                    
                }
                

            }else{
                
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Stripe not connected")

                
            }
            
                
            
            

        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
        
        
        
    }
    
    
    
    
}






struct StripeResponse: Codable {
    let status: String
    let stripeInfo: StripeInfo

    private enum CodingKeys: String, CodingKey {
        case status
        case stripeInfo = "stripeInfo"
    }
}

struct StripeInfo: Codable {
    let stripeId: String
    let name: String
    let phone: String
    let email: String
    let website: String
    let capabilities: Capabilities
    let chargesEnabled: Bool
    let country: String
    let created: TimeInterval
    let defaultCurrency: String
    let externalAccounts: ExternalAccounts
    let payoutsEnabled: Bool
    let type: String

    private enum CodingKeys: String, CodingKey {
        case stripeId
        case name
        case phone
        case email
        case website
        case capabilities
        case chargesEnabled = "charges_enabled"
        case country
        case created
        case defaultCurrency = "default_currency"
        case externalAccounts = "external_accounts"
        case payoutsEnabled = "payouts_enabled"
        case type
    }
}

struct Capabilities: Codable {
    let cardPayments: String
    let transfers: String

    private enum CodingKeys: String, CodingKey {
        case cardPayments = "card_payments"
        case transfers
    }
}

struct ExternalAccounts: Codable {
    let brand: String
    let country: String
    let cvcCheck: String
    let expMonth: String
    let expYear: Int?  // Make expYear optional to handle both string and integer representations
    let last4: String
    let fingerprint: String
    let funding: String

    private enum CodingKeys: String, CodingKey {
        case brand
        case country
        case cvcCheck = "cvc_check"
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case last4
        case fingerprint
        case funding
    }
}

// Assuming jsonD
