//
//  PhoneNumberVerification.swift
//  Utalii
//
//  Created by IOSKOL on 14/03/24.
//

import UIKit
import SwiftyJSON
import NBBottomSheet
import SwiftyJSON
import Photos
import MobileCoreServices
import GooglePlaces
import GoogleMaps

import SDWebImage
import Alamofire
class PhoneNumberVerification: UIViewController, CountriesViewControllerDelegate, Otp_Verification,stripe_Details {
   
    
    

    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var phone_number: UITextField!
    var countriesViewController = CountriesViewController()
    var countryCodestr = "1"
    var countryShortName = "US"
    var mobilenumerFinal = ""
    var viewType = ""
    var userID = ""
    var stripemodels : StripeModelRec!
    @IBOutlet weak var bankaccountbutton: UIButton!
    @IBOutlet weak var stripeConnectbutton: UIButton!
    
    @IBOutlet weak var verify_button: UIButton!
    var Stripeconnectdetails : StripeDetailModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCountryPicker()
        // Do any additional setup after loading the view.
       // userID = "521"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupCountryPicker(){
        self.countriesViewController = CountriesViewController()
        self.countriesViewController.delegate = self
        self.countriesViewController.allowMultipleSelection = false
        if let info = self.getCountryAndName() {
            countryCodestr = info.countryCode!
            self.countryShortName = info.countryShortName! //🇺🇸
            
            countryCode.text = ("\(info.countryFlag!) (\(countryShortName)) \(countryCodestr)")
            
            UserDefaults.standard.set(info.countryFlag ?? "" , forKey: "countryFlag") //setObject
            UserDefaults.standard.set(info.countryShortName ?? "" , forKey: "countryShortName") //setObject
            UserDefaults.standard.set(info.countryCode ?? "", forKey: "countryCode") //setObject
            
            
            
           // self.lblCountryCode.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(info.countryCode!)"
        }
    }
    private func getCountryAndName(_ countryParam: String? = nil) -> CountryModel? {
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonObj = JSON(data)
                let countryData = CountryListModel.init(jsonObj.arrayValue)
                let locale: Locale = Locale.current
                var countryCode: String?
                if countryParam != nil {
                    countryCode = countryParam
                } else {
                    countryCode = locale.region?.identifier
                }
                let currentInfo = countryData.country?.filter({ (cm) -> Bool in
                    return cm.countryShortName?.lowercased() == countryCode?.lowercased()
                })
                
                if currentInfo!.count > 0 {
                    return currentInfo?.first
                } else {
                    return nil
                }
                
            } catch {
                // handle error
            }
        }
        return nil
    }
    
    @IBAction func selectCountrycode(_ sender: Any) {
        
        CountriesViewController.show(countriesViewController: self.countriesViewController, toVar: self, stripe_status: false)
    }
    func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) {
        
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        if let info = self.getCountryAndName(country.countryCode) {
            countryCodestr = info.countryCode!
            let countryFlag = info.countryFlag
            countryShortName = info.countryShortName ?? ""
            print (phone_number.text!)
           // var mobile = phone_number.text!
            countryCode.text = ("\(countryFlag ?? "🇺🇸")(\(countryShortName)) \(countryCodestr)")
            UserDefaults.standard.set(info.countryFlag ?? "" , forKey: "countryFlag") //setObject
            UserDefaults.standard.set(info.countryShortName ?? "" , forKey: "countryShortName") //setObject
            UserDefaults.standard.set(info.countryCode ?? "", forKey: "countryCode") //setObject
            print(countryCodestr)
            self.dismiss(animated: true)
        }
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country) {
        
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country]) {
        
    }

    @IBAction func verify_button(_ sender: Any) {
        
        if(phone_number.text == ""){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Enter Phone Number")
        }else{
            
            let mobile = "\(String(describing: countryCodestr)) \(phone_number.text!)"
            self.mobilenumerFinal = mobile
            
            checkStripe()
            
          
             
        }
        
    }
    
    func otpVerified(otp_type: String) {
        
        self.verify_button.setTitle("Verified", for: .normal)
        self.verify_button.isEnabled = false
        
        
        
            
    }
    
    @IBAction func connect_Stripe(_ sender: Any) {
        getStripeURL()
    }
    
    @IBAction func bankaccountaction(_ sender: Any) {
        let vc:BanckDetailVC = guideStoryBoard.instantiateViewController(withIdentifier: "BanckDetailVC") as! BanckDetailVC
      //  vc.marrBankInfo = self.marrBankInfo
      //  vc.marrLoginModel = self.marrLoginModel
      //  vc.marrPersonalInfo = self.marrPersonalInfo
        vc.fromLogin = true
        vc.userId = self.userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getStripeURL(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":self.userID]
        APIhandler.SharedInstance.API_WithParameters(aurl: API_StripeConnect, parameter: dict, completeBlock: { [self] (responseObj) in
            IJProgressView.shared.hideProgressView()
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.Stripeconnectdetails = StripeDetailModel(apiResponce)
            if(self.Stripeconnectdetails.status.equalIgnoreCase("1")){
                print("the received stripe \(self.Stripeconnectdetails.stripeUrl)")
                print("the received stripe \(self.Stripeconnectdetails.returnUrl)")
                
                DispatchQueue.main.async {
                    let vc:Stripe_Connect_Webview = guideStoryBoard.instantiateViewController(withIdentifier: "Stripe_Connect_Webview") as! Stripe_Connect_Webview
                    vc.weburl = self.Stripeconnectdetails.stripeUrl
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
        
    }
    func StripeDetails_Receive(StripeID: String, StripeSuccess: Bool) {
        if(StripeSuccess){
            UserDefaults.standard.set(StripeID, forKey: KU_STRIPECONNECTSTATUS)
            UserDefaults.standard.set(StripeID, forKey: KU_STRIPEACCOUNTID)
            UserDefaults.standard.set("1", forKey: KU_STRIPECONNECTSTATUS)

           // self.StripeConnectButtion.setTitle("Stripe Connected", for: .normal)
           // stripeConnected = true
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Stripe Account Connected")
            ConstantFunction.sharedInstance.login()
            UserDefaults.standard.set("FIRST", forKey: "isFirstLogin")
            UserDefaults.standard.set("STRIPE", forKey: "ISSTRIPEORBANK")
        }
        else{
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Stripe Account Creation Failed")
           // stripeConnected = false
        }
    }
    
    
    //MARK: - Api Call
    func checkStripe(){
        self.verify_button.isEnabled = false

        IJProgressView.shared.showProgressView()

        let dict = ["userId":self.userID,"mobile":self.mobilenumerFinal,"countryNameCode":self.countryShortName]
        APIhandler.SharedInstance.API_WithParameters(aurl: API_StripeConnectCheck, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                self.verify_button.setTitle("Verified", for: .normal)

                print("\(dict)  -- \(responseObj)")
                
            }
            IJProgressView.shared.hideProgressView()

            print(JSON(responseObj))
            let apiResponce = JSON(responseObj)
            self.stripemodels =  StripeModelRec(apiResponce)
            if(self.stripemodels.status == "1"){
                
                
                if(self.stripemodels.stripeConnectSupport == "1"){
                    print("Show stripe Connect")
                    self.bankaccountbutton.isHidden = true
                    self.stripeConnectbutton.isHidden = false
                }else{
                    print("Show bank account")
                    self.bankaccountbutton.isHidden = false
                    self.stripeConnectbutton.isHidden = true
                }
                print("Verification")
                let vc : OTP_Screen = (guideStoryBoard.instantiateViewController(withIdentifier: "OTP_Screen") as! OTP_Screen)
                vc.user_id = self.userID
                vc.mobilenumber = self.mobilenumerFinal
                vc.OtpType = "Mobile"
                vc.delegate = self
                vc.countryNameCode = self.countryShortName
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                self.verify_button.isEnabled = true
                self.verify_button.setTitle("Verify", for: .normal)
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.stripemodels.error)
            }
            
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
            self.verify_button.isEnabled = true
            self.verify_button.setTitle("Verify", for: .normal)
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Unable to reach server")
        }
    }
    

}
struct StripeModelRec{
    var status = ""
    var error = ""
    var message = ""
    var mobile = ""
    var stripeConnectSupport = ""

    init(_ json: JSON) {
     
        status = json["status"].stringValue
        error = json["error"].stringValue
        message = json["message"].stringValue
        mobile = json["mobile"].stringValue
        stripeConnectSupport = json["stripeConnectSupport"].stringValue
    }
}
