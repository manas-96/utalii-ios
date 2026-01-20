//
//  GuideHomeVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class GuideHomeVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var txtOnlineOffline: UILabel!
    @IBOutlet weak var viewOnlineOffline: UIView!
    
    @IBOutlet weak var lblNewRequest: UILabel!
    @IBOutlet weak var viewOnGoing: UIView!
    @IBOutlet weak var viewOnGoingHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblGuideName: UILabel!
    //MARK: - Variable
    var isOnline = true
    var marrLoginModel : LoginModel!
    var marrGuideDashboardModel : GuideDashboardModel!
    var marrDetail : Detail!
    var marrInProgress : InProgress!
    
    var marrGuideDetailModel : GuideDetailModel!
    var marrGuideDetails : GuideDetails!

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(DeviceToken)
//        print(FCMToken)
        setTheme()
        callGuideDetail()
        callGetDetailAPI()
        UserDefaults.standard.set(false, forKey: KU_ISGUIDESTARTTOUR)
        self.viewOnGoing.isHidden = true
        self.viewOnGoingHeight.constant = 0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        guideMainVC.showVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = background1
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }  
    
    //MARK :- Our Function
    func setTheme(){
        txtOnlineOffline.text = "Go Offline"
        viewOnlineOffline.addViewBorder(borderColor: CGColor(red: 0.357, green: 0.522, blue: 0.953, alpha: 1.0), borderWith: 2, borderCornerRadius: 8)
        txtOnlineOffline.textColor = colorBlue
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnOnlineOffline(_ sender: UIButton) {
        if(isOnline){
            callOfflineOnlineAPI(isAvailability: "0")
        }
        else{
            callOfflineOnlineAPI(isAvailability: "1")
        }
    }
    
    @IBAction func btnPostVideo(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:PostAVideoVC = guideStoryBoard.instantiateViewController(withIdentifier: "PostAVideoVC") as! PostAVideoVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTourPackage(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:TourPackageVC = guideStoryBoard.instantiateViewController(withIdentifier: "TourPackageVC") as! TourPackageVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTourRequest(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:TourRequestVC = guideStoryBoard.instantiateViewController(withIdentifier: "TourRequestVC") as! TourRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOngoingTour(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:GuideOpenTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "GuideOpenTourVC") as! GuideOpenTourVC
        vc.orderId = self.marrInProgress.orderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Api Call
    
    func callOfflineOnlineAPI(isAvailability: String){
        IJProgressView.shared.showProgressView()
        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","isAvailability":isAvailability]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_GOONLINEOFFLINE, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                IJProgressView.shared.hideProgressView()
                if(self.marrLoginModel.isAvailability == "1"){
                    self.isOnline = true
                    self.txtOnlineOffline.text = "Go Offline"
                    
                    self.viewOnlineOffline.addViewBorder(borderColor: CGColor(red: 0.357, green: 0.522, blue: 0.953, alpha: 1.0), borderWith: 2, borderCornerRadius: 8)
                    
                    self.txtOnlineOffline.textColor = colorBlue
                }
                else{
                    self.isOnline = false
                    self.txtOnlineOffline.text = "Go Online"
                    
                    self.viewOnlineOffline.addViewBorder(borderColor: CGColor(red: 0.976, green: 0.549, blue: 0.035, alpha: 1.0), borderWith: 2, borderCornerRadius: 8)
                    
                    self.txtOnlineOffline.textColor = colorAccent
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
    
    func callGetDetailAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_GuideDashboard, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrGuideDashboardModel = GuideDashboardModel(apiResponce)
            if(self.marrGuideDashboardModel.status.equalIgnoreCase("1")){
                if(self.marrGuideDashboardModel.detail != nil){
                    self.marrDetail = self.marrGuideDashboardModel.detail
                    
                    UserDefaults.standard.set(self.marrDetail.address, forKey: KU_ADDRESS)
                    UserDefaults.standard.set(self.marrDetail.latitude, forKey: KU_LOGINLATITUDE)
                    UserDefaults.standard.set(self.marrDetail.longitude, forKey: KU_LOGINLOGITUDE)
                    self.lblGuideName.text = self.marrDetail.fullName

                    if(self.marrDetail.totalUnreadMsgCount == 0){
                        guideMainVC.hideUnRead()
                    }
                    else{             
                        guideMainVC.setUnread(number: "\(self.marrDetail.totalUnreadMsgCount)")
                    }
                    
                    if(self.marrDetail.newRequest == 0){
                        self.lblNewRequest.text = "\(self.marrDetail.newRequest) New Requests"
                        self.lblNewRequest.textColor = colorGray
                    }
                    else{
                        self.lblNewRequest.text = "\(self.marrDetail.newRequest) New Requests"
                        self.lblNewRequest.textColor = colorPrimary
                    }
                    
                    if(self.marrDetail.inProgress != nil && self.marrDetail.inProgress?.orderId != ""){
                        self.marrInProgress = self.marrDetail.inProgress
                        if(self.marrInProgress == nil){
                            UserDefaults.standard.set(false, forKey: KU_ISGUIDESTARTTOUR)
                            self.viewOnGoing.isHidden = true
                            self.viewOnGoingHeight.constant = 0
                        }
                        else{
                            UserDefaults.standard.set(self.marrInProgress.orderId, forKey: KU_GUIDEORDERID)
                            UserDefaults.standard.set(true, forKey: KU_ISGUIDESTARTTOUR)
                            guideMainVC.getUserLocation()
                            self.viewOnGoing.isHidden = false
                            self.viewOnGoingHeight.constant = 80
                        }
                    }
                    else{
                        UserDefaults.standard.set(false, forKey: KU_ISGUIDESTARTTOUR)
                        self.viewOnGoing.isHidden = true
                        self.viewOnGoingHeight.constant = 0
                    }
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrGuideDashboardModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callGuideDetail(){
        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_GuideDetail, parameter: dict, completeBlock: { (responseObj) in
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
//                    self.lblAddress.text = self.marrGuideDetails.address
//                    self.lblGuideName.text = self.marrGuideDetails.fullName
//                    self.viewRate.rating = Double(self.marrGuideDetails.avgRating) ?? 0.00
//                    self.lblComplitedToure.text = self.marrGuideDetails.tripCompleted
//                    self.lblGuideSince.text = self.marrGuideDetails.since
//
//                    self.lblRate.text = "\(self.marrGuideDetails.currencySymbol)\(self.marrGuideDetails.minimumCharge)"
//                    self.lblAvilableFrom.text = ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrGuideDetails.tourStartTime)
//                    self.lblLanguage.text = self.marrGuideDetails.languageKnown
//                    self.lblLocation.text = self.marrGuideDetails.address
//                    self.lblImportantPlace.text = self.marrGuideDetails.placesKnown
//
//                    let date1 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate12(aDate: self.marrGuideDetails.dob), month: ConstantFunction.sharedInstance.changeDateFormate13(aDate: self.marrGuideDetails.dob), day: ConstantFunction.sharedInstance.changeDateFormate14(aDate: self.marrGuideDetails.dob), hour: 5, minute: 9).date!
//                    
//                    let date2 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate4(), month: ConstantFunction.sharedInstance.changeDateFormate5(), day: ConstantFunction.sharedInstance.changeDateFormate6(), hour: 5, minute: 9).date!
//
//                    let years = date2.years(from: date1)
                    
//                    self.lblAge.text = "\(years) Years"
//                    self.lblAboutus.text = self.marrGuideDetails.descriptions
 
                }
            }
            else{
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrGuideDetailModel.error)
            }
             
        }) { (errorObj) in
        }
    }
}

