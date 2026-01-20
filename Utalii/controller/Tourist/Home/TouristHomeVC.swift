//
//  TouristHomeVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit
import NBBottomSheet
import SwiftyJSON

import GooglePlaces
import GoogleMaps


class TouristHomeVC: UIViewController,changeDataDeleget,GMSMapViewDelegate{
    
    //MARK: - Outlet
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    
    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblIntrest: UILabel!
    
    @IBOutlet weak var viewOngoing: UIView!

    
    //MARK: - Variable
    var marrUserIntrestModel : UserIntrestModel!
    var marrInterestList = [InterestList]()
    
    var arrSelectedItem = [String]()
    var arrSelectedItemID = [String]()
    
    var arrSelectedLanguage = [String]()
    var arrSelectedLanguageID = [String]()
    
    var marrLoginModel : LoginModel!
    var marrDetails : Details!
    
    var latitude = ""
    var logitude = ""
    var date1 = "" 
    var marrGuideDashboardModel : GuideDashboardModel!
    var marrDetail : Detail!
    var marrInProgress : InProgress!
    var isShowMsg = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            
        } else {
            callUserInfoAPI()
        }

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
        statusBar.backgroundColor = white
        UIApplication.shared.keyWindow?.addSubview(statusBar)
       // self.callSendPushMSGAPI()

    }
    
    //MARK :- Our Function
    func setTheme(){
        imgTime.changePngColorTo(color: colorBlue)
        imgArrow1.changePngColorTo(color: colorBlue)
        imgArrow2.changePngColorTo(color: colorBlue)
        lblWelcome.text = "Welcome \(UserDefaults.standard.string(forKey: KU_FULLNAME) ?? "")"
        
        txtDate.text = ConstantFunction.sharedInstance.changeDateFormate9(date: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date())
        date1 = ConstantFunction.sharedInstance.changeDateFormate8(date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        txtTime.text = ConstantFunction.sharedInstance.changeDateFormate10(date: Date())
    }
    
    //MARK: - DataSource & Deleget
    func didChangeData(selectedItem: [String], selectedID: [String], isIntrest: Bool) {
        if(isIntrest){
            lblIntrest.text = (selectedItem.map{String($0)}.joined(separator: ","))
            self.arrSelectedItem = selectedItem
            self.arrSelectedItemID = selectedID
        }
        else{
            lblLanguage.text = (selectedItem.map{String($0)}.joined(separator: ","))
            self.arrSelectedLanguage = selectedItem
            self.arrSelectedLanguageID = selectedID
        }
    }
    
    //MARK: - Click Action
    @IBAction func btnDate(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date",minDate: Date(), didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.txtDate.text = ConstantFunction.sharedInstance.changeDateFormate9(date: selectedDate)
            self?.date1 = ConstantFunction.sharedInstance.changeDateFormate8(date: selectedDate)
        })
    }
    
    @IBAction func btnTime(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
            // TODO: Your implementation for date
            self?.txtTime.text = ConstantFunction.sharedInstance.changeDateFormate10(date: selectedDate)
        })
    }
    
    @IBAction func btnOngoing(_ sender: UIButton) {
        
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            
        } else {
            touristMainVC.hideMenu()
            let vc:BookingDetailVC = touristStoryBoard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
            vc.orderId = marrInProgress.orderId
            vc.isOnGoing = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnLanguage(_ sender: UIButton) {
        callLanguageAPI()
    }
    
    @IBAction func btnIntrest(_ sender: UIButton) {
        callInterestListAPI()
    }
    
    @IBAction func btnCheckPush(_ sender: Any) {
       // self.callSendPushMSGAPI()
    }
    
//    func callSendPushMSGAPI(){
//        let randomString = NSUUID().uuidString
//
//        IJProgressView.shared.showProgressView()
//        let dict = ["userId" : UserDefaults.standard.string(forKey: KU_USERID) ?? "",
//                    "message" : "This is a test message from Utalli Admin." + " " + randomString]
//
//        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendPushMsgFCM, parameter: dict, completeBlock: { (responseObj) in
//            if(showLog){
//                print("\(dict)  -- \(responseObj)")
//            }
//            IJProgressView.shared.hideProgressView()
//
//        }) { (errorObj) in
//            IJProgressView.shared.hideProgressView()
//        }
//    }
    
    @IBAction func btnFindTour(_ sender: UIButton) {
        touristMainVC.hideMenu()
        let vc:AvilableGuideListVC = touristStoryBoard.instantiateViewController(withIdentifier: "AvilableGuideListVC") as! AvilableGuideListVC
        vc.location = txtAddress.text ?? ""
        vc.latitude = latitude
        vc.logitude = logitude
        vc.startTime = txtTime.text ?? ""
        vc.date = date1
        if((lblLanguage.text ?? "").isEqual("Select Language")){
            vc.language = ""
        }
        else{
            vc.language = lblLanguage.text ?? ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLocation(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.primaryTextColor = blackDark
        acController.secondaryTextColor = blackDark
        acController.tableCellBackgroundColor = white
        acController.tableCellSeparatorColor = black
        acController.primaryTextHighlightColor = black
        
        self.present(acController, animated: true, completion: nil)
    }
    
    //MARK: - Api Call
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
                    UserDefaults.standard.set(self.marrDetail.descriptions, forKey: KU_DESCRIPTION)

                    if(self.marrDetail.totalUnreadMsgCount == 0){
                        touristMainVC.hideUnRead()
                    }
                    else{
                        touristMainVC.setUnread(number: "\(self.marrDetail.totalUnreadMsgCount)")
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
    
    func callUserInfoAPI(){
        self.marrInterestList.removeAll()
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_UserInfo, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.details != nil){
                self.marrDetails = self.marrLoginModel.details!
                self.txtAddress.text = self.marrDetails.address
                
                self.latitude = self.marrDetails.latitude ?? "0.0"
                self.logitude = self.marrDetails.longitude ?? "0.0"
                 
                UserDefaults.standard.set(self.txtAddress.text ?? "", forKey: KU_ADDRESS)
                UserDefaults.standard.set(self.latitude, forKey: KU_LOGINLATITUDE)
                UserDefaults.standard.set(self.logitude, forKey: KU_LOGINLOGITUDE)
                
                if(self.marrDetails.inProgress != nil && self.marrDetails.inProgress?.orderId != ""){
                    self.marrInProgress = self.marrDetails.inProgress
                    if(self.marrInProgress == nil){
                        UserDefaults.standard.set(false, forKey: KU_TURISTORDERID)
                        self.viewOngoing.isHidden = true
                     }
                    else{
                        UserDefaults.standard.set(self.marrInProgress.orderId, forKey: KU_ISTURISTSTARTTOUR)
                        UserDefaults.standard.set(true, forKey: KU_TURISTORDERID)
                        touristMainVC.getUserLocation()
                        self.viewOngoing.isHidden = false
                     }
                }
                else{
                    IJProgressView.shared.hideProgressView()
                    UserDefaults.standard.set(false, forKey: KU_TURISTORDERID)
                    self.viewOngoing.isHidden = true
                 }
                self.callGetDetailAPI()
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callInterestListAPI(){
        self.marrInterestList.removeAll()
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_IntrestList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrUserIntrestModel = UserIntrestModel(apiResponce)
            
            if(self.marrUserIntrestModel.status.equalIgnoreCase("1")){
                if(self.marrUserIntrestModel.interestList?.count ?? 0 > 0){
                    self.marrInterestList = self.marrUserIntrestModel.interestList!
                    
                    var configuration: NBBottomSheetConfiguration
                    var bottomSheetController = NBBottomSheetController()
                    configuration = NBBottomSheetConfiguration(sheetSize: .fixed(self.view.frame.height))
                    let viewController = SelectionVC()
                    viewController.isIntrest = true
                    viewController.arrSelectedItem = self.arrSelectedItem
                    viewController.arrSelectedItemID = self.arrSelectedItemID
                    viewController.marrInterestList = self.marrInterestList
                    viewController.delegate = self
                    viewController.navigationController?.hidesBottomBarWhenPushed = true
                    bottomSheetController = NBBottomSheetController(configuration: configuration)
                    bottomSheetController.present(viewController, on: self)
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrUserIntrestModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callLanguageAPI(){
        self.marrInterestList.removeAll()
        IJProgressView.shared.showProgressView()
        let dict = ["language":""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_Languages, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrUserIntrestModel = UserIntrestModel(apiResponce)
            
            if(self.marrUserIntrestModel.status.equalIgnoreCase("1")){
                if(self.marrUserIntrestModel.interestList?.count ?? 0 > 0){
                    self.marrInterestList = self.marrUserIntrestModel.interestList!
                    
                    var configuration: NBBottomSheetConfiguration
                    var bottomSheetController = NBBottomSheetController()
                    configuration = NBBottomSheetConfiguration(sheetSize: .fixed(self.view.frame.height))
                    let viewController = SelectionVC()
                    viewController.isIntrest = false
                    viewController.language = ""
                    viewController.delegate = self
                    viewController.marrInterestList = self.marrInterestList
                    viewController.arrSelectedLanguage = self.arrSelectedItem
                    viewController.arrSelectedLanguageID = self.arrSelectedItemID
                    viewController.navigationController?.hidesBottomBarWhenPushed = true
                    bottomSheetController = NBBottomSheetController(configuration: configuration)
                    bottomSheetController.present(viewController, on: self)
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrUserIntrestModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension TouristHomeVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(place.formattedAddress ?? "")")
        self.txtAddress.text = "\(place.formattedAddress ?? place.name ?? "")"
        print("Place attributions: \(String(describing: place.attributions))")
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                
                
                self.latitude = "\(place.coordinate.latitude)"
                self.logitude = "\(place.coordinate.longitude)"
                
                
                self.dismiss(animated: true)
                
            }
            
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}
