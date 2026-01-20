//
//  GuideProfileVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class GuideProfileVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgContactDetail: UIImageView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var imgBanck: UIImageView!
    @IBOutlet weak var imgAddress: UIImageView!
    @IBOutlet weak var viewContactDetail: UIView!
    @IBOutlet weak var viewContactDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var imgBenner: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblGuideName: UILabel!
    @IBOutlet weak var lblTotalComplited: UILabel!
    @IBOutlet weak var lblGuideSeince: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblPermanetAddress: UILabel!
    @IBOutlet weak var lblNotificationCounter: UILabel!
    @IBOutlet weak var viewNotificationCounter: UIView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblGuideplace: UILabel!
    
    @IBOutlet weak var lblAge: UILabel!
    
    //MARK: - Variable
    var isShowContactDetail = false
    var marrLoginModel : LoginModel!
    var marrPersonalInfo : PersonalInfo!
    var marrBankInfo : BankInfo!
    var marrNotificationListModel : NotificationListModel!
    var marrNotiList = [NotiList]()
    var marrGuideDetailModel : GuideDetailModel!
    var marrGuideDetails : GuideDetails!
    var Stripeconnectdetails : StripeDetailModel!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        callSideBar()
        viewNotificationCounter.isHidden = true
      //  self.marrLoginModel = LoginModel
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    //MARK: - STRIPE CONNECT
    
    @IBAction func call_stripe(_ sender: Any) {
        getStripeURL()
    }
    func getStripeURL(){
        IJProgressView.shared.showProgressView()

        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
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
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }

             
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()

        }
        
    }
    
    
    //MARK: - APP FLOW
    override func viewDidAppear(_ animated: Bool) {
        guideMainVC.showVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorBlue
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        callGuideDetail()
        callGetNotificationAPI()

    }
    
    func callGuideDetail(){
        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_GuideDetail, parameter: dict, completeBlock: { [self] (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            
            self.marrGuideDetailModel = GuideDetailModel(apiResponce)

            if(self.marrGuideDetailModel.status.equalIgnoreCase("1")){
                if(self.marrGuideDetailModel.details != nil){
                    self.marrGuideDetails = self.marrGuideDetailModel.details!
                    marrGuideDetails1 = self.marrGuideDetails
                    self.setData()

                    let urlNew:String = (self.marrGuideDetails.coverpic ?? "").replacingOccurrences(of: " ", with: "%20")
                    let urlNew1:String = (self.marrGuideDetails.profilePic ?? "").replacingOccurrences(of: " ", with: "%20")
                    self.imgBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
                    self.imgUser.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "loding.png"))
                }
            }
            else{
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrGuideDetailModel.error)
            }
             
        }) { (errorObj) in
        }
    }
    
    
    //MARK :- Our Function
    func callSideBar() {
        let apiResponce = getJSON(KU_USERRESPONCE)
        self.marrLoginModel = LoginModel(apiResponce!)
        if(apiResponce == nil) {
            
        }
        else if(self.marrLoginModel.status.equalIgnoreCase("1")) {
            if(self.marrLoginModel.personalInfo != nil) {
                self.marrPersonalInfo = self.marrLoginModel.personalInfo
                 if(self.marrPersonalInfo.bankInfo != nil) {
                    self.marrBankInfo = self.marrPersonalInfo.bankInfo
                } else{
                    ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Invalid Email")
                }
            }
        }
    }
    
    func getJSON(_ key: String)-> JSON? {       
        var p = ""
        if let result = UserDefaults.standard.string(forKey: key) {
            p = result
        }
        if p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    return try JSON(data: json)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func setData() {
        
        let date1 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate12(aDate: marrGuideDetails.dob), month: ConstantFunction.sharedInstance.changeDateFormate13(aDate: marrGuideDetails.dob), day: ConstantFunction.sharedInstance.changeDateFormate14(aDate: marrGuideDetails.dob), hour: 5, minute: 9).date!
        
        let date2 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate4(), month: ConstantFunction.sharedInstance.changeDateFormate5(), day: ConstantFunction.sharedInstance.changeDateFormate6(), hour: 5, minute: 9).date!
     
        let years = date2.years(from: date1)
        if(marrGuideDetails.dob == "00-00-00"){
            lblAge.text = ""

        }else{
            lblAge.text = "\(years) Years"

        }
        
        
        
        lblGuideName.text = marrGuideDetails.fullName
        lblTotalComplited.text = marrGuideDetails.tripCompleted
        lblGuideSeince.text = marrGuideDetails.since
        lblAbout.text = marrGuideDetails.descriptions
                    
        lblEmail.text = UserDefaults.standard.string(forKey: KU_EMAILID) ?? ""
        lblContact.text = UserDefaults.standard.string(forKey: KU_MOBILENO) ?? ""
        lblPermanetAddress.text = marrGuideDetails.address
        
        lblLanguage.text = marrGuideDetails.languageKnown
        lblGuideplace.text = marrGuideDetails.address
    }
    
    func setTheme() {
        imgNotification.changePngColorTo(color: white)
        imgContactDetail.changePngColorTo(color: colorBlue)
        imgPassword.changePngColorTo(color: colorBlue)
        imgBanck.changePngColorTo(color: colorBlue)
        imgAddress.changePngColorTo(color: colorBlue)
        
        viewContactDetail.isHidden = true
        viewContactDetailHeight.constant = 0
                
        viewMain.clipsToBounds = false
        viewMain.layer.cornerRadius = CGFloat(8)
        viewMain.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
         
    } 
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnNotification(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:GuideNotificationVC = guideStoryBoard.instantiateViewController(withIdentifier: "GuideNotificationVC") as! GuideNotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
           
    @IBAction func btnYourPackage(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:TourPackageVC = guideStoryBoard.instantiateViewController(withIdentifier: "TourPackageVC") as! TourPackageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func btnEditDetail(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:EditGuideDetailVC = storyBoard.instantiateViewController(withIdentifier: "EditGuideDetailVC") as! EditGuideDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
                
    @IBAction func btnLogout(_ sender: UIButton) {
        
            UserDefaults.standard.set("0", forKey: KU_STRIPECONNECTSTATUS)
            UserDefaults.standard.set(false, forKey: KU_ISLOGIN)
            UserDefaults.standard.setValue("", forKey: KU_USERID)
        //UserDefaults.standard.string(forKey: KU_USERID)
            ConstantFunction.sharedInstance.login()
    }        
    
    @IBAction func btnChangePassword(_ sender: UIButton) {        
        guideMainVC.hideVC()
        let vc:ChangePasswordVC = guideStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
            
    @IBAction func btnBank(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:BanckDetailVC = guideStoryBoard.instantiateViewController(withIdentifier: "BanckDetailVC") as! BanckDetailVC
        vc.marrBankInfo = self.marrBankInfo
        vc.marrLoginModel = self.marrLoginModel
      //  vc.marrPersonalInfo = self.marrPersonalInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func btnContactDetail(_ sender: UIButton) {
        if(isShowContactDetail){
            isShowContactDetail = false
            viewContactDetail.isHidden = true
            viewContactDetailHeight.constant = 0    
        }
        else{
            isShowContactDetail = true
            viewContactDetail.isHidden = false
            viewContactDetailHeight.constant = 203
        }    
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
    
    
    @IBAction func removeacccount(_ sender: Any) {
        let alertController = UIAlertController(title: AppName, message: "Are you sure to delete your account.This will delete all your data", preferredStyle: .alert)

         // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
             UIAlertAction in
             NSLog("OK Pressed")
         }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
             UIAlertAction in
             NSLog("Cancel Pressed")
         }

         // Add the actions
         alertController.addAction(okAction)
         alertController.addAction(cancelAction)

         // Present the controller
         self.present(alertController, animated: true, completion: nil)
        
        
    }
    
}
      
