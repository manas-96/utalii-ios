//
//  SignupVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 27/09/22.
//

import UIKit
import SwiftyJSON

class SignupVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCreatePassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var imgCreatePassword: UIImageView!
    @IBOutlet weak var imgConfirmPassword: UIImageView!

    //MARK: - Variable
    var viewType = ""
    var passwordShow = false
    var passwordShow1 = false
    var vcName = ""
    var marrLoginModel : LoginModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        imgConfirmPassword.image = UIImage(named: "showpasswoed")
        imgCreatePassword.image = UIImage(named: "showpasswoed")
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
    }
    
    //MARK :- Our Function
    func setTheme() {
        if (viewType == "Guide") {
            lblTitle.text = "Register As Guide"
        } else {
            lblTitle.text = "Register As Tourist"
        }
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnCreatePassword(_ sender: UIButton) {
        if (passwordShow) {
            passwordShow = false
            txtCreatePassword.isSecureTextEntry = true
            imgCreatePassword.image = UIImage(named: "hidepassword")
        }
        else{
            passwordShow = true
            txtCreatePassword.isSecureTextEntry = false
            imgCreatePassword.image = UIImage(named: "showpasswoed")
        }
    }
    
    @IBAction func btnConfirmPassword(_ sender: UIButton) {
        if(passwordShow1){
            passwordShow1 = false
            txtConfirmPassword.isSecureTextEntry = true
            imgConfirmPassword.image = UIImage(named: "hidepassword")
        }
        else{
            passwordShow1 = true
            txtConfirmPassword.isSecureTextEntry = false
            imgConfirmPassword.image = UIImage(named: "showpasswoed")
        }
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtEmail.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter email")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtCreatePassword.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter password")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtConfirmPassword.text!)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter confirm password")
        }
        else if(txtCreatePassword.text != txtConfirmPassword.text!){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: passwordnotMatch1)
        }
        else{
            if(viewType == "Guide"){
                callSignUpAPI(type: 2)
            }
            else{
                callSignUpAPI(type: 1)
            }
        }
        
//        let vc:TouristCompliteProfileVC = storyBoard.instantiateViewController(withIdentifier: "TouristCompliteProfileVC") as! TouristCompliteProfileVC
//        vc.viewType = self.viewType
//       // vc.userID = self.marrLoginModel.userId
//        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    @IBAction func btnLogin(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Api Call
    func callSignUpAPI(type: Int){
        IJProgressView.shared.showProgressView()
        let dict = ["password":txtConfirmPassword.text ?? "","emailId":txtEmail.text ?? "","userType":type] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_SignUp, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please authenticate your email address by clicking the link send to you via email!")
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                if(type == 2) {
                    
                    let vc:PhoneNumberVerification = storyBoard.instantiateViewController(withIdentifier: "PhoneNumberVerification") as! PhoneNumberVerification
                    vc.viewType = self.viewType
                    vc.userID = self.marrLoginModel.userId
                    //vc.email = self.txtEmail.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                    /*
                    let vc:CompliteYourProfileVC = storyBoard.instantiateViewController(withIdentifier: "CompliteYourProfileVC") as! CompliteYourProfileVC
                    vc.viewType = self.viewType
                    vc.userID = self.marrLoginModel.userId
                    vc.email = self.txtEmail.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                     */
                }
                else{
                    let vc:TouristCompliteProfileVC = storyBoard.instantiateViewController(withIdentifier: "TouristCompliteProfileVC") as! TouristCompliteProfileVC
                    vc.viewType = self.viewType
                    vc.userID = self.marrLoginModel.userId
                    vc.email = self.txtEmail.text!
                    vc.vcName = self.vcName
                    self.navigationController?.pushViewController(vc, animated: true)
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
