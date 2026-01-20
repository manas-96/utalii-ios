//
//  LoginVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 27/09/22.
//

import UIKit
import SwiftyJSON

class LoginVC: UIViewController {
   
    
   
    //MARK: - Outlet
    @IBOutlet weak var imgHideShow: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnTitle: UILabel!
    
    //MARK: - Variable
    var viewType = ""
    var passwordShow = false
    var marrLoginModel : LoginModel!
    var marrPersonalInfo : PersonalInfo!
    var marrBankInfo : BankInfo!
    var vcName = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        print(newVCName)
        
        //        if(viewType == "Guide"){
//            txtEmail.text = "igi184@goigi.in"
//            txtPassword.text = "123456"
//
//        }
//        else{
//            txtEmail.text = "igi128@goigi.in"
//            txtPassword.text = "123456"
//
////            txtEmail.text = "dkassiane@gmail.com"
////            txtPassword.text = "Utalii@2023"
//        }
        
        imgHideShow.image = UIImage(named: "showpasswoed")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    
 override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "Guest")
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorBlue
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false


    }
    
    func callAddFCMTokenAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId" : UserDefaults.standard.string(forKey: KU_USERID) ?? "",
                    "fcmToken" : FCMToken]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_AddFCMToken, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
        
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    //MARK :- Our Function
    func setTheme() {
        if (viewType == "Guide") {
            btnTitle.text = "Login to Earn"
        } else {
            btnTitle.text = "Login to Explore"
        }
    }
     
    func saveJSON(json: JSON, key:String){
        if let jsonString = json.rawString() {
            UserDefaults.standard.setValue(jsonString, forKey: key)
            
        }
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnLogin(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtEmail.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter username")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPassword.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter password")
        }
        else{
            if(viewType == "Guide"){
                callLoginAPI(type: 2)
            }
            else{
                callLoginAPI(type: 1)
            }
        }
    }
    
    @IBAction func btnCreateAccount(_ sender: UIButton) {
     
        
        let vc:SignupVC = storyBoard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        vc.viewType = self.viewType
        vc.vcName = self.vcName
        self.navigationController?.pushViewController(vc, animated: true)
        
     //   let vc:PhoneNumberVerification = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVerification") as! PhoneNumberVerification
     //   self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnForgot(_ sender: UIButton) {
        let vc:ForgotPasswordVC = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnHideShowPassword(_ sender: UIButton) {
        if (passwordShow) {
            passwordShow = false
            txtPassword.isSecureTextEntry = true
            imgHideShow.image = UIImage(named: "hidepassword")
        } else {
            passwordShow = true
            txtPassword.isSecureTextEntry = false
            imgHideShow.image = UIImage(named: "showpasswoed")
        }
    }
    
    //MARK: - Api Call
    func callLoginAPI(type: Int){
        IJProgressView.shared.showProgressView()

        UserDefaults.standard.set(txtPassword.text ?? "" , forKey: "password") //setObject
        UserDefaults.standard.set(txtEmail.text ?? "" , forKey: "email") //setObject

        
        let dict = ["password":txtPassword.text ?? "","emailId":txtEmail.text ?? "","userType":type] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_Login, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
         // sid 25 apr
            self.saveJSON(json: JSON(apiResponce), key: KU_USERRESPONCE)

            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                if(self.marrLoginModel.personalInfo != nil){
                    self.marrPersonalInfo = self.marrLoginModel.personalInfo
                    
                    if(self.marrPersonalInfo.userType.equalIgnoreCase("\(type)")){
                        UserDefaults.standard.set(true, forKey: KU_ISLOGIN)
                        UserDefaults.standard.set(self.txtPassword.text!, forKey: KU_PASSWORD)
                        UserDefaults.standard.set(self.marrPersonalInfo.userId, forKey: KU_USERID)
                        UserDefaults.standard.set(self.marrPersonalInfo.userType, forKey: KU_USERTYPE)
                        UserDefaults.standard.set(self.marrPersonalInfo.fullName, forKey: KU_FULLNAME)
                        UserDefaults.standard.set(self.marrPersonalInfo.emailId, forKey: KU_EMAILID)
                        UserDefaults.standard.set(self.marrPersonalInfo.countryNameCode, forKey: KU_COUNTRYNAMECODE)
                        UserDefaults.standard.set(self.marrPersonalInfo.mobileNo, forKey: KU_MOBILENO)
                        UserDefaults.standard.set(self.marrPersonalInfo.countryNameCodeEmg, forKey: KU_COUNTRYNAMECODEEMG)
                        UserDefaults.standard.set(self.marrPersonalInfo.emergencyNumber, forKey: KU_EMERGENCYNUMBER)
                        let mob1 =   UserDefaults.standard.string(forKey: KU_EMERGENCYNUMBER)

                        UserDefaults.standard.set(self.marrPersonalInfo.profilePic, forKey: KU_PROFILEPIC)
                        UserDefaults.standard.set(self.marrPersonalInfo.coverpic, forKey: KU_COVERPiIC)
                        UserDefaults.standard.set(self.marrPersonalInfo.minimumCharge, forKey: KU_MINIMUMCHARGE)
                        UserDefaults.standard.set(self.marrPersonalInfo.currencyType, forKey: KU_CURRENCTTYPE)
                        UserDefaults.standard.set(self.marrPersonalInfo.currencySymbol, forKey: KU_CURRENCYSYMBOL)
                        UserDefaults.standard.set(self.marrPersonalInfo.license, forKey: KU_LICENSE)
                        UserDefaults.standard.set(self.marrPersonalInfo.isAvailability, forKey: KU_ISAVAILABILITY)
                        UserDefaults.standard.set(self.marrPersonalInfo.tripCompleted, forKey: KU_TRIPCOMPLETED)
                        UserDefaults.standard.set(self.marrPersonalInfo.bankInfoStatus, forKey: KU_BANKINFOSTATUS)
                        
                        
                        if(self.marrPersonalInfo.bankInfo != nil){
                            self.marrBankInfo = self.marrPersonalInfo.bankInfo
                            UserDefaults.standard.set(self.marrBankInfo.bankId, forKey: KU_BANKID)
                            UserDefaults.standard.set(self.marrBankInfo.accountHolderName, forKey: KU_ACCOUNTHOLDERNAME)
                            UserDefaults.standard.set(self.marrBankInfo.accountNumber, forKey: KU_ACCOUNTNUMBER)
                            UserDefaults.standard.set(self.marrBankInfo.abaNumber, forKey: KU_ABANUMBER)
                            UserDefaults.standard.set(self.marrBankInfo.bankName, forKey: KU_BANKNAME)
                            UserDefaults.standard.set(self.marrBankInfo.bankAddress, forKey: KU_BANKADDRESS)
                            UserDefaults.standard.set(self.marrBankInfo.created, forKey: KU_CREATED)
                            UserDefaults.standard.set(self.marrBankInfo.updated, forKey: KU_UPDATED)
                        }
                        if(type == 2) {
                            ConstantFunction.sharedInstance.guideHome()
                        }
                        else {
                            self.callAddFCMTokenAPI()
                            ConstantFunction.sharedInstance.touristHome()
                        }
                    }
                    else{
                            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Invalid Email")
                    }
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
