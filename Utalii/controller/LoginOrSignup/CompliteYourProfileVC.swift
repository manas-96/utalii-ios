//
//  CompliteYourProfileVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 27/09/22.
//

import UIKit
import SwiftyJSON
import NBBottomSheet
import SwiftyJSON
import GooglePlaces
import GoogleMaps


class CompliteYourProfileVC: UIViewController,UIImagePickerControllerDelegate,changeDataDeleget,GMSMapViewDelegate,stripe_Details{
   
    
 
    //MARK: - Outlet
    @IBOutlet weak var viewCoverImage: UIView!
    @IBOutlet weak var imgCover: UIImageView!
   
    @IBOutlet weak var viewChangePhoto: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
   
    @IBOutlet weak var viewUploadDocument: UIView!
    @IBOutlet weak var imgDocument: UIImageView!
   
    @IBOutlet weak var tblImportantPlace: UITableView!
    @IBOutlet weak var tblImportPlaceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgStreetAddress: UIImageView!
    @IBOutlet weak var imgCity: UIImageView!
    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var imgPostalCode: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtShortDesc: KMPlaceholderTextView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtPlace: UITextField!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblIntrest: UILabel!
    @IBOutlet weak var txtBdate: UITextField!
    @IBOutlet weak var txtGuidAge: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtStreetAddtess: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtMinimumBooking: UITextField!
    
    @IBOutlet weak var lblDateOn: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var StripeConnectButtion: UIButton!
    
    //MARK: - Variable
    var viewType = ""
    var userID = ""
     
    var latitude = "0.0"
    var logitude = "0.0"
    
    var email = ""
    
    var isProfile = false
    var isDocument = false
    var isCover = false
    
    var isProfileSelected = false
    var isDocumentSelected = false
    var isCoverSelected = false
    
    var imagePicker: ImagePicker!
    
    var countryCode : String? = "1"
    var countryShortName : String? = "US"
    var countriesViewController = CountriesViewController()
    var dob = ""
    
    var yearsTillNow : [String]!
    
    var arrImportantplaces = [String]()
    
    var arrSelectedItem = [String]()
    var arrSelectedItemID = [String]()
    
    var arrSelectedLanguage = [String]()
    var arrSelectedLanguageID = [String]()
    
    var marrUserIntrestModel : UserIntrestModel!
    var marrInterestList = [InterestList]()
 
    var marrLoginModel : LoginModel!
    var Stripeconnectdetails : StripeDetailModel!
    var stripeConnected:Bool = false

 //MARK: - STRIPE CONNECT
    func StripeDetails_Receive(StripeID: String, StripeSuccess: Bool) {
        if(StripeSuccess){
            UserDefaults.standard.set(StripeID, forKey: KU_STRIPECONNECTSTATUS)
            self.StripeConnectButtion.setTitle("Stripe Connected", for: .normal)
            stripeConnected = true
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Stripe Account Connected")

        }
        else{
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Stripe Account Creation Failed")
            stripeConnected = false
        }
    }
    
    @IBAction func Stripe_Connect_Action(_ sender: Any) {
        getStripeURL()
    }
    func getStripeURL(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":self.userID]
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
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
        
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        txtEmail.text = email
        txtEmail.isUserInteractionEnabled = false
        
        var years = [String]()
        for i in (1970..<ConstantFunction.sharedInstance.changeDateFormate4()).reversed() {
            years.append("\(i)")
        }
        yearsTillNow = years
        
        tblImportantPlace.register(UINib(nibName: "ImportantPlaceTableCell", bundle: nil), forCellReuseIdentifier: "ImportantPlaceTableCell")
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
        setupCountryPicker()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        imgCover.clipsToBounds = false
        imgCover.layer.cornerRadius = CGFloat(8)
        viewCoverImage.clipsToBounds = false
        viewCoverImage.layer.cornerRadius = CGFloat(8)
        viewChangePhoto.clipsToBounds = false
        viewChangePhoto.layer.cornerRadius = CGFloat(8)
        imgPhoto.clipsToBounds = false
        imgPhoto.layer.cornerRadius = CGFloat(8)
        
        viewUploadDocument.clipsToBounds = false
        viewUploadDocument.layer.cornerRadius = CGFloat(8)
        imgDocument.clipsToBounds = false
        imgDocument.layer.cornerRadius = CGFloat(8)
        
        imgCover.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewCoverImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imgPhoto.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewChangePhoto.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
         
        imgDocument.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewUploadDocument.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        imgStreetAddress.changePngColorTo(color: colorBlue)
        imgCity.changePngColorTo(color: colorBlue)
        imgState.changePngColorTo(color: colorBlue)
        imgCountry.changePngColorTo(color: colorBlue)
        imgPostalCode.changePngColorTo(color: colorBlue)
        
        let countryShortName = "US"
      //  let countryCode = "1"
        let countryFlag = "🇺🇸"
        self.lblCountryCode.text = "\(countryFlag) (\(countryShortName)) +\(countryCode ?? "")"

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
            countryCode = info.countryCode ?? ""
            self.countryShortName = info.countryShortName ?? ""
           // self.lblCountryCode.text = "\(info.countryFlag ?? "") (\(info.countryShortName ?? "")) \(info.countryCode ?? "")"
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
    
    func yearsBetweenDate(startDate: Date, endDate: Date) -> Int {

        let calendar = Calendar.current

        let components = calendar.dateComponents([.year], from: startDate, to: endDate)

        return components.year!
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
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCoverImage(_ sender: UIButton) {
        isProfile = false
        isDocument = false
        isCover = true
        if(ConstantFunction.sharedInstance.openCamera()){
            self.imagePicker.present(from: sender)
        }
        else{
            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        }
    }
    
    @IBAction func btnChangeDocument(_ sender: UIButton) {
        isProfile = false
        isDocument = true
        isCover = false
        if(ConstantFunction.sharedInstance.openCamera()){
            self.imagePicker.present(from: sender)
        }
        else{
            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        }
    }
    
    @IBAction func btnProfileImage(_ sender: UIButton) {
        isProfile = true
        isDocument = false
        isCover = false
        if(ConstantFunction.sharedInstance.openCamera()){
            self.imagePicker.present(from: sender)
        }
        else{
            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        }
    }
     
    @IBAction func btnAddPlace(_ sender: UIButton) {
        if(!ConstantFunction.sharedInstance.isEmpty(txt: txtPlace.text ?? "")){
            arrImportantplaces.append(txtPlace.text ?? "")
            tblImportPlaceHeight.constant = CGFloat(arrImportantplaces.count * 39)
            txtPlace.text = nil
            tblImportantPlace.reloadData()
        }
    }
    
    @IBAction func btnLanguage(_ sender: UIButton) {
        callLanguageAPI()
    }
    
    @IBAction func btnInterests(_ sender: UIButton) {
        callInterestListAPI()
    }
    
    @IBAction func btnDob(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Date", didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self?.dob = ConstantFunction.sharedInstance.changeDateFormate8(date: selectedDate)
            self?.txtBdate.text = "\(self?.yearsBetweenDate(startDate: selectedDate, endDate: Date()) ?? 0) years"
        })
        lblDateOn.text = ConstantFunction.sharedInstance.changeDateFormate3()
    }
    
    @IBAction func btnGuidAge(_ sender: UIButton) {
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: yearsTillNow, selectedIndex: 2) {[weak self] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            self?.txtGuidAge.text = selctedText
        }
    }
    
    @IBAction func btnStartTime(_ sender: UIButton) {
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [weak self](selectedDate) in
               // TODO: Your implementation for date
            self?.txtStartTime.text = ConstantFunction.sharedInstance.changeDateFormate7(date: selectedDate)
           })
    }
    
    @IBAction func btnCounrtyCode(_ sender: UIButton) {
        CountriesViewController.show(countriesViewController: self.countriesViewController, toVar: self, stripe_status: true)
    }
     
    @objc func btnRemove(_ sender: UIButton) {
        arrImportantplaces.remove(at: sender.tag)
        tblImportPlaceHeight.constant = CGFloat(arrImportantplaces.count * 39)
        txtPlace.text = nil
        tblImportantPlace.reloadData()
    }
    
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
        else if(arrImportantplaces.count == 0){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter Important places")
        }
        else if(arrSelectedLanguage.count == 0){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select languages")
        }
        else if(arrSelectedItem.count == 0){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select interest")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtBdate.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter date of birth")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtGuidAge.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter guide since")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtStartTime.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter tour start time")
        }
        else if(!ConstantFunction.sharedInstance.isEmailValid(email: txtEmail.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter email")
        }
//        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPhone.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter contact number")
//        }
//        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtCity.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter city")
//        }
//        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtState.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter state")
//        }
//        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtCountry.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter country")
//        }
//        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtPostCode.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter postcode")
//        }
        else if(isCoverSelected == false){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select cover image")
        }
        else if(isProfileSelected == false){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select profile image")
        }
        else if(isDocumentSelected == false){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select document image")
        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtMinimumBooking.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter minimumCharge")
        }
        else if(self.stripeConnected == false){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Create a Stripe Account")
        }
        else{
            if(viewType == "Guide"){
                callSaveDataAPI(type: 2)
            }
            else{
                callSaveDataAPI(type: 1)
            }
        }
    }
      
    
    //MARK: - Api Call
    func callSaveDataAPI(type: Int){
        IJProgressView.shared.showProgressView()
        
       // var mobileNo = "+\(countryCode ?? "")\(txtPhone.text ?? "")"
        
        print (txtPhone.text ?? "")
        var mobile = txtPhone.text ?? ""
        print(countryCode)
        mobile = "+" + (countryCode ?? "") + " " + (txtPhone.text ?? "")

        print(mobile)
        
//        let dict = ["guideId":userID,"fullName":txtFullName.text!,"address":txtLocation.text!,
//                    "latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName ?? "",
//                    "mobile":mobileNo,"descriptions":txtShortDesc.text!,
//                    "languageKnown":"\(arrSelectedLanguage.map{String($0)}.joined(separator: ","))",
//                    "placesKnown":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))",
//                    "interest":"\(arrSelectedItemID.map{String($0)}.joined(separator: ","))",
//                    "dob":self.dob,"since":txtGuidAge.text!,"minimumCharge":txtMinimumBooking.text!,
//                    "tourStartTime":txtStartTime.text!,
//            "permanentAddress":"\(txtStreetAddtess.text ?? "") \(txtCity.text ?? "") \(txtState.text ?? "") \(txtCountry.text ?? "") \(txtPostCode.text ?? "")",
//                    "city":txtCity.text ?? "","state":txtState.text ?? "","country":txtCountry.text ?? "",
//                    "pincode":txtPostCode.text ?? "","currencyType":"USD"] as [String : Any]
        
        let dict = ["guideId":userID,"fullName":txtFullName.text!,"address":txtLocation.text!,
                    "latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName ?? "",
                    "mobile":mobile,"descriptions":txtShortDesc.text!,
                    "languageKnown":"\(arrSelectedLanguage.map{String($0)}.joined(separator: ","))",
                    "placesKnown":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))",
                    "interest":"\(arrSelectedItemID.map{String($0)}.joined(separator: ","))",
                    "dob":self.dob,"since":txtGuidAge.text!,"minimumCharge":txtMinimumBooking.text!,
                    "tourStartTime":txtStartTime.text!,
            "permanentAddress":"\(txtStreetAddtess.text ?? "") \(txtCity.text ?? "") \(txtState.text ?? "") \(txtCountry.text ?? "") \(txtPostCode.text ?? "")",
                    "city":txtCity.text ?? "","state":txtState.text ?? "","country":txtCountry.text ?? "",
                    "pincode":txtPostCode.text ?? "","currencyType":"USD"] as [String : Any]
        print(dict)
            APIhandler.SharedInstance.Api_withImageAndParameters(aWebServiceName: API_UpdateGuideProfile, aDictParam: dict,aImag: self.imgCover.image!,aImag2: imgPhoto.image!,aImag3: imgDocument.image!,imgParameter: "profilePic", imgParameter2: "profilePic", imgParameter3: "license" , completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                 self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
            
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()

        }
    }
    
    func callInterestListAPI(){
        self.marrInterestList.removeAll()
        IJProgressView.shared.showProgressView()
        let dict = ["title":""]
        
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
                    viewController.userID = self.userID
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
extension CompliteYourProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, name: String) {
        if(image != nil){
            if(isProfile){
                self.isProfileSelected = true
                self.imgPhoto.image = nil
                self.imgPhoto.image = image
            }
            else if(isDocument){
                self.isDocumentSelected = true
                self.imgDocument.image = nil
                self.imgDocument.image = image
            }
            else if(isCover){
                self.isCoverSelected = true
                self.imgCover.image = nil
                self.imgCover.image = image
            }
        }
    }
}

extension CompliteYourProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrImportantplaces.count > 0){
            return arrImportantplaces.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ImportantPlaceTableCell = tableView.dequeueReusableCell(withIdentifier: "ImportantPlaceTableCell", for: indexPath) as! ImportantPlaceTableCell

        cell.lblTitle.text = arrImportantplaces[indexPath.row]
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(self.btnRemove), for: .touchUpInside)
        return cell
    }
}

extension CompliteYourProfileVC: GMSAutocompleteViewControllerDelegate {

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

extension CompliteYourProfileVC: CountriesViewControllerDelegate {
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country]) {
         
    }
    
    func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) {
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        if let info = self.getCountryAndName(country.countryCode) {
            countryCode = info.countryCode ?? ""
 
            self.countryShortName = info.countryShortName ?? ""
            self.lblCountryCode.text = "\(info.countryFlag ?? "") (\(info.countryShortName ?? "")) \(info.countryCode ?? "")"
            self.dismiss(animated: true)
        }
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country) {
    }
}
