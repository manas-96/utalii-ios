//
//  ChangePasswordVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class ChangePasswordVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var imgOldPassword: UIImageView!
    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet weak var imgConfirmPassword: UIImageView!

    //MARK: - Variable
    var passwordShow = false
    var passwordShow1 = false
    var passwordShow2 = false
    
    var marrLoginModel : LoginModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
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
    func setTheme(){
        imgOldPassword.image = UIImage(named: "showpasswoed")
        imgNewPassword.image = UIImage(named: "showpasswoed")
        imgConfirmPassword.image = UIImage(named: "showpasswoed")
    }
     
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnOldPassword(_ sender: UIButton) {
        if(passwordShow){
            passwordShow = false
            txtOldPassword.isSecureTextEntry = true
            imgOldPassword.image = UIImage(named: "hidepassword")
        }
        else{
            passwordShow = true
            txtOldPassword.isSecureTextEntry = false
            imgOldPassword.image = UIImage(named: "showpasswoed")
        }
    }
    
    @IBAction func btnNewPassword(_ sender: UIButton) {
        if(passwordShow1){
            passwordShow1 = false
            txtNewPassword.isSecureTextEntry = true
            imgNewPassword.image = UIImage(named: "hidepassword")
        }
        else{
            passwordShow1 = true
            txtNewPassword.isSecureTextEntry = false
            imgNewPassword.image = UIImage(named: "showpasswoed")
        }
    }
    
    @IBAction func btnConfirmPassword(_ sender: UIButton) {
        if(passwordShow2){
            passwordShow2 = false
            txtConfirmPassword.isSecureTextEntry = true
            imgConfirmPassword.image = UIImage(named: "hidepassword")
        }
        else{
            passwordShow2 = true
            txtConfirmPassword.isSecureTextEntry = false
            imgConfirmPassword.image = UIImage(named: "showpasswoed")
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtOldPassword.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: oldPassword)
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtNewPassword.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: newPassword)
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtConfirmPassword.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: confirmPassword)
        }
        else if(txtNewPassword.text != txtConfirmPassword.text!){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: passwordnotMatch1)
        }
        else if(txtNewPassword.text == UserDefaults.standard.string(forKey: KU_PASSWORD) ?? ""){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Don't use the previous password")
        }
        else{
            callChangePassword()
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Api Call
    func callChangePassword(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","oldPassword":txtOldPassword.text!,"newPassword":txtNewPassword.text!]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_ChangePassword, parameter: dict, completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                self.navigationController?.popViewController(animated: true)
                ConstantFunction.sharedInstance.showBottomAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
            }
            else{
                ConstantFunction.sharedInstance.showBottomAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()

        }
    }
}
