//
//  BanckDetailVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class BanckDetailVC: UIViewController {
  
    //MARK: - Outlet
    @IBOutlet weak var txtFullBeneficiaryName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAbaNumber: UITextField!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtBankAddress: UITextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var viewSubmitHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var viewEditHeight: NSLayoutConstraint!
    
    //MARK: - Variable
    var marrBankInfo : BankInfo!
    var marrLoginModel : LoginModel!
    var marrPersonalInfo : PersonalInfo!
    
    var fromLogin = false
    var userId = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        if(marrBankInfo == nil || ConstantFunction.sharedInstance.isEmpty(txt: marrBankInfo.accountHolderName)) {
            viewSubmit.isHidden = false
            viewSubmitHeight.constant = 45
            
            viewEdit.isHidden = true
            viewDelete.isHidden = true
            viewEditHeight.constant = 0
        } else {
            viewSubmit.isHidden = true
            viewSubmitHeight.constant = 0
            
            viewEdit.isHidden = false
            viewDelete.isHidden = false
            viewEditHeight.constant = 45
        }  
    }
    
    func setBankDetails() {
        if marrBankInfo != nil {
                    self.txtFullBeneficiaryName.text = self.marrBankInfo.accountHolderName ?? ""
                    self.txtAccountNumber.text = self.marrBankInfo.accountNumber ?? ""
                    self.txtAbaNumber.text = self.marrBankInfo.abaNumber ?? ""
                    self.txtBankName.text = self.marrBankInfo.bankName ?? ""
                    self.txtBankAddress.text = self.marrBankInfo.bankAddress ?? ""
                }
//                else {
//                    self.txtFullBeneficiaryName.text = self.marrBankInfo.accountHolderName ?? ""
//                    self.txtAccountNumber.text = self.marrBankInfo.accountNumber ?? ""
//                    self.txtAbaNumber.text = self.marrBankInfo.abaNumber ?? ""
//                    self.txtBankName.text = self.marrBankInfo.bankName ?? ""
//                    self.txtBankAddress.text = self.marrBankInfo.accountHolderName ?? ""
//                }
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
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorBlue
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        setBankDetails()
    }
    
    //MARK :- Our Function
    func setTheme() {
        imgBack.changePngColorTo(color: white)
    }
                   
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtBankName.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter bank name")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtAbaNumber.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter aba number")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtAccountNumber.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter account number")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtBankName.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter bank name")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtFullBeneficiaryName.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter beneficiary name")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtBankAddress.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter bank address")
        } else {
            callEditBanck()
        }
    }
         
    @IBAction func btnDelete(_ sender: UIButton) {
        callDeleteBank()
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtBankName.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter bank name")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtAbaNumber.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter aba number")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtAccountNumber.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter account number")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtBankName.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter bank name")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtFullBeneficiaryName.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter beneficiary name")
        } else if(ConstantFunction.sharedInstance.isEmpty(txt: txtBankAddress.text ?? "")) {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter bank address")
        } else {
                callAddBanck()
        }
    }
   
    //MARK: - Api Call
    func callAddBanck() {
        IJProgressView.shared.showProgressView()
        let dict = ["userId":fromLogin ? self.userId:UserDefaults.standard.string(forKey: KU_USERID) ?? "","accountHolderName":txtFullBeneficiaryName.text ?? "","accountNumber":txtAccountNumber.text ?? "","bankName":txtBankName.text ?? "","abaNumber":txtAbaNumber.text ?? "","bankAddress":txtBankAddress.text ?? ""] as [String : Any]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_ADDBANCKINFO, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }     
            IJProgressView.shared.hideProgressView()
            
            
            
            if(!self.fromLogin){
                self.marrLoginModel = nil
                let apiResponce = JSON(responseObj)
                self.marrLoginModel = LoginModel(apiResponce)
                
                
                self.callLoginAPI(type: 2)
                
                
                if(self.marrLoginModel.status.equalIgnoreCase("1")){
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    IJProgressView.shared.hideProgressView()
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
                }
            }
            else{
                self.marrLoginModel = nil
                let apiResponce = JSON(responseObj)
                self.marrLoginModel = LoginModel(apiResponce)
                
                if(self.marrLoginModel.status.equalIgnoreCase("1")){
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                    ConstantFunction.sharedInstance.login()
                    UserDefaults.standard.set("FIRST", forKey: "isFirstLogin")
                    UserDefaults.standard.set("BANK", forKey: "ISSTRIPEORBANK")

                }
                else{
                    IJProgressView.shared.hideProgressView()
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
                }
                
            }
            
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func saveJSON(json: JSON, key:String){
        if let jsonString = json.rawString() {
            UserDefaults.standard.setValue(jsonString, forKey: key)
            
        }
    }
    
    
    //MARK: - Api Call
    func callLoginAPI(type: Int){
        IJProgressView.shared.showProgressView()
        
      let password = UserDefaults.standard.string(forKey: "password")
      let email = UserDefaults.standard.string(forKey: "email")

        
        let dict = ["password": password ?? "","emailId": email ?? "","userType":type] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_Login, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            self.saveJSON(json: JSON(apiResponce), key: KU_USERRESPONCE)

            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                if(self.marrLoginModel.personalInfo != nil){
                    self.marrPersonalInfo = self.marrLoginModel.personalInfo
                    
                    if(self.marrPersonalInfo.userType.equalIgnoreCase("\(type)")){
                        UserDefaults.standard.set(true, forKey: KU_ISLOGIN)
                      //  UserDefaults.standard.set(self.txtPassword.text!, forKey: KU_PASSWORD)
                        UserDefaults.standard.set(self.marrPersonalInfo.userId, forKey: KU_USERID)
                        UserDefaults.standard.set(self.marrPersonalInfo.userType, forKey: KU_USERTYPE)
                        UserDefaults.standard.set(self.marrPersonalInfo.fullName, forKey: KU_FULLNAME)
                        UserDefaults.standard.set(self.marrPersonalInfo.emailId, forKey: KU_EMAILID)
                        UserDefaults.standard.set(self.marrPersonalInfo.countryNameCode, forKey: KU_COUNTRYNAMECODE)
                        UserDefaults.standard.set(self.marrPersonalInfo.mobileNo, forKey: KU_MOBILENO)
                        UserDefaults.standard.set(self.marrPersonalInfo.countryNameCodeEmg, forKey: KU_COUNTRYNAMECODEEMG)
                        UserDefaults.standard.set(self.marrPersonalInfo.emergencyNumber, forKey: KU_EMERGENCYNUMBER)
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
                        else{
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


    
    
    func callEditBanck() {
        IJProgressView.shared.showProgressView()
        let dict = ["bankId":marrBankInfo.bankId,"userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","accountHolderName":txtFullBeneficiaryName.text ?? "","accountNumber":txtAccountNumber.text ?? "","bankName":txtBankName.text ?? "","abaNumber":txtAbaNumber.text ?? "","bankAddress":txtBankAddress.text ?? ""] as [String : Any]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_EDITBANKINFO, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()   
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
           
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callDeleteBank() {
        IJProgressView.shared.showProgressView()
        let dict = ["bankId":marrBankInfo.bankId,"userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]
             
        APIhandler.SharedInstance.API_WithParameters(aurl: API_DELETEBANK, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
          // a  self.callLoginAPI(type: 2)
            
            self.viewSubmit.isHidden = false
            self.viewSubmitHeight.constant = 45
            
            self.viewEdit.isHidden = true
            self.viewDelete.isHidden = true
            self.viewEditHeight.constant = 0
            
            self.txtFullBeneficiaryName.text =  ""
            self.txtAccountNumber.text =  ""
            self.txtAbaNumber.text = ""
            self.txtBankName.text = ""
            self.txtBankAddress.text = ""
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.navigationController?.popViewController(animated: true)
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
