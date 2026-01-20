//
//  TouristEditProfileVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 01/12/22.
//

import UIKit
import SwiftyJSON

import GoogleMaps

import GooglePlaces

class TouristEditProfileVC:UIViewController,UIImagePickerControllerDelegate,GMSMapViewDelegate{
    
    //MARK: - Outlet
    
    @IBOutlet weak var viewChangePhoto: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgStreetAddress: UIImageView!
    @IBOutlet weak var imgCity: UIImageView!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var imgPostalCode: UIImageView!
    
    @IBOutlet weak var lblEnergencyNo: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtEmergencyNo: UITextField!
    @IBOutlet weak var txtStreetAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtShortDesc: KMPlaceholderTextView!
    
    //MARK: - Variable
    var viewType = ""
    
    var latitude = ""
    var logitude = ""
    var userID = UserDefaults.standard.string(forKey: KU_USERID) ?? ""
    var email = ""
    
    var imagePicker: ImagePicker!
    
    var countryCode = "1"
    var countryCode2 = "1"
    
    var countryShortName = "US"
    
    var countriesViewController = CountriesViewController()
    
    var isEmergencyNo = false
    
    var marrLoginModel : LoginModel!
    var marrDetails : Details!
    
    var marrGuideDetailModel : GuideDashboardModel!
    var marrGuideDashboardModel : GuideDashboardModel!
    var marrDetail : Detail!
    var marrBankInfo : BankInfo!
    var marrPersonalInfo : PersonalInfo!
    
    var countryModel1: CountryModel!
    var countryModel2: CountryModel!

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.marrLoginModel)

        setTheme()

        txtEmail.text = self.marrDetails.email ?? ""
        txtEmail.isUserInteractionEnabled = false
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
                            self.navigationController?.popViewController(animated: true)
                           // ConstantFunction.sharedInstance.touristProfile()
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
    
    
    func callUserInfoAPI(){
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
                
                self.latitude = self.marrDetails.latitude ?? "0.0"
                self.logitude = self.marrDetails.longitude ?? "0.0"
                 
                UserDefaults.standard.set(self.latitude, forKey: KU_LOGINLATITUDE)
                UserDefaults.standard.set(self.logitude, forKey: KU_LOGINLOGITUDE)
                
                self.callGetDetailAPI()
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }

    
    func setText(){
        let urlNew:String = (self.marrDetails.profilePic).replacingOccurrences(of: " ", with: "%20")
        self.imgPhoto.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        
        let countryFlag =   UserDefaults.standard.string(forKey: "countryFlag") ?? ""
        let countryShortName =  UserDefaults.standard.string(forKey: "countryShortName") ?? ""
        let countryCodee =  UserDefaults.standard.string(forKey: "countryCode") ?? ""
        
        self.lblContactNo.text = "\(countryFlag) (\(countryShortName)) \(countryCodee)"
        //self.lblCountryCode.text = "\(countryFlag) (\(countryShortName))"
        
        let lengthOfCountryCode = countryCodee.count + 2
        
        let mob = marrDetails?.mobile ?? ""
        var mbile = String(mob.dropFirst(lengthOfCountryCode))
        //mob.dropFirst(3)
        self.txtContactNo.text = mbile
        
        
        let countryFlag1 =   UserDefaults.standard.string(forKey: "countryFlag1") ?? ""
        let countryShortName1 =  UserDefaults.standard.string(forKey: "countryShortName1") ?? ""
        let countryCodee1 =  UserDefaults.standard.string(forKey: "countryCode1") ?? ""
        
        self.lblEnergencyNo.text = "\(countryFlag1) (\(countryShortName1)) \(countryCodee1)"
        //self.lblCountryCode.text = "\(countryFlag) (\(countryShortName))"
        
        let lengthOfCountryCode1 = countryCodee1.count + 1
        let mob1 =   UserDefaults.standard.string(forKey: KU_EMERGENCYNUMBER) ?? ""
        var mbile1 = String(mob1.dropFirst(lengthOfCountryCode1))
        //mob.dropFirst(3)
        self.txtEmergencyNo.text = mbile1

        txtEmail.text = marrDetails.email
       // txtStreetAddress.text = marrDetails.address
        
       
        txtLocation.text = marrDetails.address
        
        txtShortDesc.text = UserDefaults.standard.string(forKey: KU_DESCRIPTION)
        self.latitude = marrDetails.latitude
        self.logitude = marrDetails.longitude
        
        txtFullName.text = marrDetails.fullName
        
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
        callGetDetailAPI()
        callUserInfoAPI()
        self.setText()

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
           // self.setText()

            if(self.marrGuideDashboardModel.status.equalIgnoreCase("1")){
                if(self.marrGuideDashboardModel.detail != nil){
                    self.marrDetail = self.marrGuideDashboardModel.detail
                    
                    UserDefaults.standard.set(self.marrDetail.address, forKey: KU_ADDRESS)
                    UserDefaults.standard.set(self.marrDetail.latitude, forKey: KU_LOGINLATITUDE)
                    UserDefaults.standard.set(self.marrDetail.longitude, forKey: KU_LOGINLOGITUDE)
                    
                    self.txtCity.text = self.marrGuideDashboardModel.detail?.city ?? ""
                    self.txtCountry.text = self.marrGuideDashboardModel.detail?.country ?? ""
                    self.txtState.text = self.marrGuideDashboardModel.detail?.state ?? ""
                    self.txtPostalCode.text = self.marrGuideDashboardModel.detail?.pincode ?? ""
                    self.txtStreetAddress.text = self.marrGuideDashboardModel.detail?.permanentAddress ?? ""
                    
                    if (self.marrDetail.totalUnreadMsgCount == 0) {
                        touristMainVC.hideUnRead()
                    } else {
                        touristMainVC.setUnread(number: "\(self.marrDetail.totalUnreadMsgCount)")
                    }
                }
            } else {
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrGuideDashboardModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }   
    
    //MARK :- Our Function
    func setTheme() {
        setupCountryPicker()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        viewChangePhoto.clipsToBounds = false
        viewChangePhoto.layer.cornerRadius = CGFloat(8)
        imgPhoto.clipsToBounds = false
        imgPhoto.layer.cornerRadius = CGFloat(8)
        
        imgPhoto.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewChangePhoto.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imgEmail.changePngColorTo(color: colorAccent)
        
        imgStreetAddress.changePngColorTo(color: colorAccent)
        imgCity.changePngColorTo(color: colorAccent)
        imgState.changePngColorTo(color: colorAccent)
        imgCountry.changePngColorTo(color: colorAccent)
        imgPostalCode.changePngColorTo(color: colorAccent)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            // Take the user to Settings app to possibly change permission.
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alert.addAction(settingsAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setupCountryPicker(){
        self.countriesViewController = CountriesViewController()
        self.countriesViewController.delegate = self
        self.countriesViewController.allowMultipleSelection = false
        if let info = self.getCountryAndName() {
            self.countryCode = info.countryCode!
            self.countryCode2 = info.countryCode!
            self.countryShortName = info.countryShortName!
            self.lblContactNo.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(info.countryCode!)"
            self.lblEnergencyNo.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(info.countryCode!)"
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
                    countryCode = locale.regionCode
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
    
    //MARK: - DataSource & Deleget
    @IBAction func txtAddress(_ sender: UITextField) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.primaryTextColor = blackDark
        acController.secondaryTextColor = blackDark
        acController.tableCellBackgroundColor = white
        acController.tableCellSeparatorColor = black
        acController.primaryTextHighlightColor = black
        
        self.present(acController, animated: true, completion: nil)
    }
    
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        txtLocation.text = nil
    }
    
    @IBAction func btnCoverImage(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.openCamera()){
            self.imagePicker.present(from: sender)
        }
        else{
            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        }
    }
    
    
    @IBAction func btnContactNo(_ sender: UIButton) {
        isEmergencyNo = false
        CountriesViewController.show(countriesViewController: self.countriesViewController, toVar: self, stripe_status: false)
    }
    
    @IBAction func btnEmergencyContactNo(_ sender: UIButton) {
        isEmergencyNo = true
        CountriesViewController.show(countriesViewController: self.countriesViewController, toVar: self, stripe_status: false)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtFullName.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter fullname")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtShortDesc.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter short description")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtLocation.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter location")
        }
        else if(!ConstantFunction.sharedInstance.isEmailValid(email: txtEmail.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter email")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtContactNo.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter contact number")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtEmergencyNo.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter emergency contact number")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtStreetAddress.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter street address")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtCity.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter city")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtState.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter state")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtCountry.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter country")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtPostalCode.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter postcode")
        }
        else{
            if(viewType == "Guide"){
                callSaveDataAPI(type: 2)
            }
            else{
                callSaveDataAPI(type: 1)
            }
        }
       // callSaveDataAPI123()
        
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
    
    
    func callSaveDataAPI123(){
        IJProgressView.shared.showProgressView()
        
        let dict = ["userId":userID]
        
        APIhandler.SharedInstance.Api_withImageAndParameters(aWebServiceName: API_Profile, aDictParam: dict,image: self.imgPhoto.image!,imageKey: "profilePic", completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()
            
            let apiResponce = JSON(responseObj)
           // self.callUserInfoAPI()
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
            
        }
    }
    
    //MARK: - Api Call
    func callSaveDataAPI(type: Int){
        IJProgressView.shared.showProgressView()
//        let dict = ["userId":userID,"fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":"+\(countryCode)\(txtContactNo.text!)","countryNameCodeEmg":countryShortName,"emergencyNumber":"+\(countryCode2)\(txtEmergencyNo.text!)","descriptions":txtShortDesc.text!,"permanentAddress":"\(txtStreetAddress.text!) \(txtCity.text!) \(txtState.text!) \(txtCountry.text!) \(txtPostalCode.text!)","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostalCode.text!]
        
//        print (txtContactNo.text!)
//        var mobile = ""
//        if(txtContactNo.text!.contains(countryCode)) {
//            mobile = txtContactNo.text!
//        } else {
//            mobile = countryCode + "" + txtContactNo.text!
//        }
//        print(mobile)
        
        
//        let dict = ["userId":userID,"fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":"\(txtContactNo.text!)","countryNameCodeEmg":countryShortName,"emergencyNumber":"\(txtEmergencyNo.text!)","descriptions":txtShortDesc.text!,"permanentAddress":"\(txtStreetAddress.text!) \(txtCity.text!) \(txtState.text!) \(txtCountry.text!) \(txtPostalCode.text!)","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostalCode.text!]
        
        
        
        print (txtContactNo.text!)
        var mobile = txtContactNo.text!
        countryCode = UserDefaults.standard.string(forKey: "countryCode") ?? ""
        print(countryCode)
        mobile = "+" + countryCode + " " + txtContactNo.text!
        print(mobile)
        UserDefaults.standard.set(mobile, forKey: KU_MOBILENO)

       
        print(txtEmergencyNo.text!)
        var mobile1 = txtEmergencyNo.text!
        countryCode2 = UserDefaults.standard.string(forKey: "countryCode1") ?? ""
        print(countryCode2)
        mobile1 = "+" + countryCode2 + " " + txtEmergencyNo.text!
        print(mobile1)
        
        UserDefaults.standard.set(mobile1, forKey: KU_EMERGENCYNUMBER)
        
//        UserDefaults.standard.set(self.txtStreetAddress.text ?? "", forKey: KU_STREETADDRESS)
//        UserDefaults.standard.set(self.txtCity.text ?? "", forKey: KU_CITY)
//        UserDefaults.standard.set(self.txtState.text ?? "", forKey: KU_STATE)
//        UserDefaults.standard.set(self.txtCountry.text ?? "", forKey: KU_COUNTRY)
//        UserDefaults.standard.set(self.txtPostalCode.text ?? "", forKey: POSTALCODE)
        
      //  var str = "+11234567890"
//        let dict = ["userId":userID,"fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":mobile
//            ,"countryNameCodeEmg":countryShortName
//            ,"emergencyNumber":mobile1,
//            "descriptions":txtShortDesc.text!,"permanentAddress":"\(txtStreetAddress.text!) \(txtCity.text!) \(txtState.text!) \(txtCountry.text!) \(txtPostalCode.text!)","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostalCode.text!]
        
        let dict = ["userId":userID,"fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":mobile
            ,"countryNameCodeEmg":countryShortName
            ,"emergencyNumber":mobile1,
            "descriptions":txtShortDesc.text!,"permanentAddress":"\(txtStreetAddress.text!)","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostalCode.text!]
        
        
        APIhandler.SharedInstance.Api_withImageAndParameters(aWebServiceName: API_UpdateTravellerProfile, aDictParam: dict,image: self.imgPhoto.image!,imageKey: "profilePic", completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()
            
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
          //  self.saveJSON(json: JSON(apiResponce), key: KU_USERRESPONCE)
            self.callLoginAPI(type: 1)

            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                UserDefaults.standard.set(self.countryModel2.countryFlag ?? "" , forKey: "countryFlag1") //setObject
                UserDefaults.standard.set(self.countryModel2.countryShortName ?? "" , forKey: "countryShortName1") //setObject
                UserDefaults.standard.set(self.countryModel2.countryCode ?? "", forKey: "countryCode1") //setObject
               
                UserDefaults.standard.set(self.countryModel1.countryFlag ?? "" , forKey: "countryFlag1") //setObject
                UserDefaults.standard.set(self.countryModel1.countryShortName ?? "" , forKey: "countryShortName1") //setObject
                UserDefaults.standard.set(self.countryModel1.countryCode ?? "", forKey: "countryCode1") //setObject
                
                UserDefaults.standard.synchronize()
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

extension TouristEditProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, name: String) {
        if(image != nil){
            self.imgPhoto.image = nil
            self.imgPhoto.image = image
        }
    }
}

extension TouristEditProfileVC: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        print("Place name: \(String(describing: place.name))")
        print("Place address: \(place.formattedAddress ?? "null")")
        self.txtLocation.text = place.name
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

extension TouristEditProfileVC: CountriesViewControllerDelegate {
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country]) {
         
    }
    
    func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) {
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        if let info = self.getCountryAndName(country.countryCode) {
            self.countryCode = info.countryCode!
            if(isEmergencyNo){
                self.countryModel2 = info
                
                print(countryCode)
                self.countryShortName = info.countryShortName ?? ""
                
             
                
                //self.lblCountryCode.text = "\(info.countryFlag!) (\(info.countryShortName ?? ""))"
                self.lblEnergencyNo.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(countryCode ?? "")"
                
//                self.countryCode2 = info.countryCode!
//               // self.countryShortName = info.countryShortName ?? ""
//                self.lblEnergencyNo.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(info.countryCode!)"
            }
            else{
                self.countryModel1 = info

                print(countryCode)
                self.countryShortName = info.countryShortName ?? ""
                
              //  UserDefaults.standard.set(info.countryFlag ?? "" , forKey: "countryFlag") //setObject
              //  UserDefaults.standard.set(info.countryShortName ?? "" , forKey: "countryShortName") //setObject
              //  UserDefaults.standard.set(info.countryCode ?? "", forKey: "countryCode") //setObject
                
                //self.lblCountryCode.text = "\(info.countryFlag!) (\(info.countryShortName ?? ""))"
                self.lblContactNo.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(countryCode ?? "")"
                 
//                self.countryShortName = info.countryShortName ?? ""
//                self.lblContactNo.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(info.countryCode!)"
            }
        }
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country) {
    }
}
