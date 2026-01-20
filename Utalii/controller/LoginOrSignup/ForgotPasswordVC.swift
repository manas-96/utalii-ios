//
//  ForgotPasswordVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 13/10/22.
//

import UIKit
import SwiftyJSON

class ForgotPasswordVC: UIViewController {
    //MARK:- Outlet
 
    @IBOutlet weak var txtEmail: UITextField!
 
    @IBOutlet weak var txtOTP: UITextField!

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    @IBOutlet weak var imgPassword1: UIImageView!
    @IBOutlet weak var imgPassword2: UIImageView!
    
    //MARK:- Variable
    var isGiver = false
    var parentVC = LoginVC()
    var isShowPassword = false
    var isShowConfirmPassword = false
    
    var marrLoginModel : LoginModel!
    var otpIS = ""
    var userid = ""
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        imgPassword1.image = UIImage(named: "passwordshow")
        imgPassword2.image = UIImage(named: "passwordshow")
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Our Function
    func setTheme(){
        
    }
    
    //MARK:- DataSource & Deleget
    
    //MARK:- Click Action
    @IBAction func btnSendOTP(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtEmail.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter email Or phone")
        }
        else{
            callOTPSendfyAPI()
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtPassword.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter password")
        }
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtConfirmPassword.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter confirm password")
        }
        else if(txtPassword.text != txtConfirmPassword.text!){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: passwordnotMatch1)
        }
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtOTP.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter OTP")
        }
        else{
            callOTPVeryfyAPI()
        }
    }
    
    @IBAction func btnHideShowPassword(_ sender: UIButton) {
        if(isShowPassword){
            imgPassword1.image = UIImage(named: "passwordshow")
            isShowPassword = false
            txtPassword.isSecureTextEntry = true
        }
        else{
            imgPassword1.image = UIImage(named: "passwordhide")
            isShowPassword = true
            txtPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnHideShowConfirmPassword(_ sender: UIButton) {
        if(isShowConfirmPassword){
            imgPassword2.image = UIImage(named: "passwordshow")
            isShowConfirmPassword = false
            txtConfirmPassword.isSecureTextEntry = true
        }
        else{
            imgPassword2.image = UIImage(named: "passwordhide")
            isShowConfirmPassword = true
            txtConfirmPassword.isSecureTextEntry = false
        }
    }
    //MARK:- Api Call
    func callOTPSendfyAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["email":txtEmail.text!]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_GetOTPForgotPassword, parameter: dict, completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                self.otpIS = self.marrLoginModel.otp
                self.userid = self.marrLoginModel.userId
             //   ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
            }
            else{
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
            
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()

        }
    }
    
    func callOTPVeryfyAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":userid,"otp":txtOTP.text!,"newPassword":txtPassword.text!,"conPassword":txtConfirmPassword.text!]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_ForgotPassword, parameter: dict, completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){ 
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
            
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()

        }
    }
    
}
