//
//  TouristProfileVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 30/09/22.
//

import UIKit
import SwiftyJSON

class TouristProfileVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    @IBOutlet weak var imgLogout: UIImageView!
    @IBOutlet weak var imgEditDetail: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgCall1: UIImageView!
    @IBOutlet weak var imgCall2: UIImageView!
    
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblEmergencyContact: UILabel!
    @IBOutlet weak var imgUser: UIImageView!

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblNotificationCounter: UILabel!
    @IBOutlet weak var viewNotificationCounter: UIView!
    
    //MARK: - Variable
    var marrLoginModel : LoginModel!
    var marrDetails : Details!
    var marrNotificationListModel : NotificationListModel!
    var marrNotiList = [NotiList]()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        callUserInfoAPI()

        viewNotificationCounter.isHidden = true

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        touristMainVC.showMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorAccent
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        callUserInfoAPI()
        callGetNotificationAPI()

    }
    
    //MARK :- Our Function
    func setTheme(){
        imgNotification.changePngColorTo(color: white)
        imgLocation.changePngColorTo(color: colorAccent)
        imgLogout.changePngColorTo(color: white)
        imgEditDetail.changePngColorTo(color: white)
        
        imgCall1.changePngColorTo(color: colorAccent)
        imgCall2.changePngColorTo(color: colorAccent)
        imgEmail.changePngColorTo(color: colorAccent)
        
        viewMain.clipsToBounds = false
        viewMain.layer.cornerRadius = CGFloat(8)
        viewMain.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnNotification(_ sender: UIButton) {
        touristMainVC.hideMenu()
        let vc:NotificationHistoryVC = touristStoryBoard.instantiateViewController(withIdentifier: "NotificationHistoryVC") as! NotificationHistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnChangePassword(_ sender: UIButton) {
        let vc:ChangePasswordVC = guideStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnEditProfie(_ sender: UIButton) {
        let vc:TouristEditProfileVC = storyBoard.instantiateViewController(withIdentifier: "TouristEditProfileVC") as! TouristEditProfileVC
        vc.marrDetails = self.marrDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
    @IBAction func btnLogout(_ sender: UIButton) {
        ConstantFunction.sharedInstance.login()
        newVCName = ""
        newIsFrom = ""
        UserDefaults.standard.removeObject(forKey: "Guest")

    }
    
    //MARK: - Api Call
    func callGetNotificationAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_NOTIFICATIONLIST, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            
            self.marrNotificationListModel = NotificationListModel(apiResponce)
            
            if(self.marrNotificationListModel.status.equalIgnoreCase("1")){
                if(self.marrNotificationListModel.notiList?.count ?? 0 > 0){
                    self.marrNotiList = self.marrNotificationListModel.notiList!
                    var sum = 0
                    for x in self.marrNotiList{
                        if(x.seen == "0"){
                            sum += 1
                        }
                    }
                    if(sum != 0){
                        self.lblNotificationCounter.text = "\(sum)"
                        self.viewNotificationCounter.isHidden = false
                    }
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrNotificationListModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    //MARK: - Api Call
    func callUserInfoAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_UserInfo, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.details != nil){
                self.marrDetails = self.marrLoginModel.details!
                
                self.lblEmail.text = self.marrDetails.email
                self.lblContactNo.text = UserDefaults.standard.string(forKey: KU_MOBILENO) 
                
                self.lblEmergencyContact.text = UserDefaults.standard.string(forKey: KU_EMERGENCYNUMBER)
                self.lblUserName.text = self.marrDetails.fullName
                self.lblAddress.text = self.marrDetails.address
                
                let urlNew:String = (self.marrDetails.profilePic).replacingOccurrences(of: " ", with: "%20")
                self.imgUser.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
 
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
