import UIKit
import SwiftyJSON
import NBBottomSheet
import SwiftyJSON
import Photos
import MobileCoreServices
import GooglePlaces
import GoogleMaps

import SDWebImage
import Alamofire




class Guide_Update_Stripes: UIViewController,UIImagePickerControllerDelegate,changeDataDeleget,GMSMapViewDelegate, UINavigationControllerDelegate,stripe_Details {
    
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
    @IBOutlet weak var stripelabel: UILabel!
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
    var countryCode = "1"
    var countryShortName = "US"
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
    var marrGuideDetailModel : GuideDetailModel!
    var marrGuideDetails : GuideDetails!
    var marrGuideDashboardModel : GuideDashboardModel!
    var marrDetail : Detail!
    var marrInProgress : InProgress!
    var marrLoginModel : LoginModel!
    var data = marrGuideDetails1
    var fileName : String = ""
    var imageName : Data?
    var imagData: Data?
    var checkImage = ""
    var myDate = 0
    
    //sent is After Removing extra charecters jsonstring: ["placesKnown": "sodepur,sass,victoria", "tourStartTime": "09:50 AM", "permanentAddress": "Kolkata Kolkata West Bengal India 700052              ", "interest": "7,8,14,5,4", "country": "India", "state": "West Bengal", "address": "Kolkata", "longitude": "88.36389500000001", "guideId": "375", "mobile": "+852 9002281841", "minimumCharge": "200.00", "dob": "1985-04-11", "city": "Kolkata", "latitude": "22.572646", "languageKnown": "Bengali/Bangla,Hindi,English", "since": "2024", "descriptions": "Hello there", "pincode": "700052", "fullName": "Arijit Das", "currencyType": "USD", "countryNameCode": "HK"]
    
    
    var Stripeconnectdetails : StripeDetailModel!
    var stripeConnected:Bool = false
    var bankAcc:Bool = false
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // txtEmail.text = email
        txtEmail.isUserInteractionEnabled = false
        
        var years = [String]()
        for i in (1970..<ConstantFunction.sharedInstance.changeDateFormate4()).reversed() {
            years.append("\(i)")
        }
        yearsTillNow = years
        
        tblImportantPlace.register(UINib(nibName: "ImportantPlaceTableCell", bundle: nil), forCellReuseIdentifier: "ImportantPlaceTableCell")
       // UserDefaults.standard.set("BANK", forKey: "ISSTRIPEORBANK")
       // UserDefaults.standard.set("1", forKey: KU_STRIPECONNECTSTATUS)

      
        
        if(UserDefaults.standard.string(forKey: "ISSTRIPEORBANK") == "BANK" ){
            bankAcc = true
            self.StripeConnectButtion.isHidden = true
            self.stripelabel.isHidden = true
            self.StripeConnectButtion.removeFromSuperview()
        }else{
            if(UserDefaults.standard.string(forKey: KU_STRIPECONNECTSTATUS) == "1" ){
                self.StripeConnectButtion.setTitle("Stripe Connected", for: .normal)
                stripeConnected = true
            }
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

    }
    
        //MARK: - STRIPE
    
    
    func StripeDetails_Receive(StripeID: String, StripeSuccess: Bool) {
        if(StripeSuccess){
            UserDefaults.standard.set(StripeID, forKey: KU_STRIPEACCOUNTID)
            UserDefaults.standard.set("1", forKey: KU_STRIPECONNECTSTATUS)

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
       /*
        if(UserDefaults.standard.string(forKey: KU_STRIPECONNECTSTATUS) == "1" ){
            let vc:Stripe_detaills_new = storyBoard.instantiateViewController(withIdentifier: "Stripe_detaills_new") as! Stripe_detaills_new
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            getStripeURL()
            
        }
        */
        
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
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
        
    }
    
    
    
    
    
    
    
    
        //MARK: - VIEWFLOW
        override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorBlue
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        callGuideDetail()
        callGetDetailAPI()

    }
    
    //MARK :- Our Function
    func setTheme(){
        
        setupCountryPicker()
     //   self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
        
        let urlNew:String = (marrGuideDetails?.coverpic ?? "").replacingOccurrences(of: " ", with: "%20")
        let urlNew1:String = (marrGuideDetails?.profilePic ?? "").replacingOccurrences(of: " ", with: "%20")
        let license =  UserDefaults.standard.string(forKey: "license")

        let urlNew2:String = (marrGuideDetails?.license ?? "").replacingOccurrences(of: " ", with: "%20")
        
        self.imgCover.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))

        self.imgPhoto.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "loding.png"))
        self.imgDocument.sd_setImage(with: URL(string: urlNew2), placeholderImage: UIImage(named: "loding.png"))
        print("The Full phone is \(data?.mobile)")
        txtFullName.text = data?.fullName
        txtShortDesc.text = data?.descriptions
        txtLocation.text = data?.address
        latitude = data?.latitude ?? ""
        logitude = data?.longitude ?? ""
        arrImportantplaces = data?.placesKnown.components(separatedBy: ",") ?? [""]
        arrSelectedLanguage = data?.languageKnown.components(separatedBy: ",") ?? ["String"]
        arrSelectedItem = data?.interestList ?? [""]
        var dates = data?.dob ?? "2000-09-25"
        //var  dates = "2000-09-25"

//        let dateFormater = DateFormatter()
//            dateFormater.dateFormat = "yyyy/mm/dd"
//        var birthdayDate = dateFormater.date(from: dates)
//        if birthdayDate == nil {
//
//        } else {
//            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
//                let now: NSDate! = NSDate()
//            let calcAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
//                let age = calcAge.year
//        }

        // sid
          let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-mm-dd"
           let date = dateFormatter.date(from:dates)

        if let date_check = date{
            let now = NSDate()
            let calendar : NSCalendar = NSCalendar.current as NSCalendar
            let ageComponents = calendar.components(.year, from: date!, to: now as Date, options: [])
            let age = ageComponents.year!
            myDate = age
            dates = String(age)

        
        txtBdate.text = dates + " years"

        }else{
          
        
    // sid
        
        txtBdate.text = ""

            
        }
        
        txtPlace.text = data?.placesKnown
       // lblIntrest.text = data?.interestList?[0]
        lblLanguage.text = data?.languageKnown
        var intrest_text = ""
        data?.interestList?.forEach({ item in
            print("the Intrest list is \(item)")
            intrest_text.append("\(item) ")
        })
        lblIntrest.text = intrest_text
        lblLanguage.text = data?.languageKnown
        
        let date1 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate12(aDate: marrGuideDetails1.since), month: ConstantFunction.sharedInstance.changeDateFormate13(aDate: marrGuideDetails1.since), day: ConstantFunction.sharedInstance.changeDateFormate14(aDate: marrGuideDetails1.since), hour: 5, minute: 9).date!
        
        let date2 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate4(), month: ConstantFunction.sharedInstance.changeDateFormate5(), day: ConstantFunction.sharedInstance.changeDateFormate6(), hour: 5, minute: 9).date!

        let years = date2.years(from: date1)
        txtGuidAge.text = "\(years)"
        txtEmail.text = data?.email
        txtStartTime.text = ConstantFunction.sharedInstance.changeDateFormate100(aDate: data?.tourStartTime ?? "")
        
        let countryFlag =   UserDefaults.standard.string(forKey: "countryFlag") ?? ""
        let countryShortName =  UserDefaults.standard.string(forKey: "countryShortName") ?? ""
        let countryCodee =  UserDefaults.standard.string(forKey: "countryCode") ?? ""
        
        self.lblCountryCode.text = "\(countryFlag) (\(countryShortName)) \(countryCodee)"
        print("The country code is \(self.lblCountryCode.text)")
        //self.lblCountryCode.text = "\(countryFlag) (\(countryShortName))"
        
        let lengthOfCountryCode = countryCodee.count + 1
        let mob = marrGuideDetails?.mobile ?? ""
        var mbile = String(mob.dropFirst(lengthOfCountryCode))
        //mob.dropFirst(3)

        txtPhone.text = mbile
        txtMinimumBooking.text = data?.minimumCharge
        
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
                    self.data = marrGuideDetails1
                    self.setTheme()
                }
            }
            else{
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrGuideDetailModel.error)
            }
             
        }) { (errorObj) in
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
                    
                    self.txtCity.text = self.marrGuideDashboardModel.detail?.city ?? ""
                    self.txtCountry.text = self.marrGuideDashboardModel.detail?.country ?? ""
                    self.txtState.text = self.marrGuideDashboardModel.detail?.state ?? ""
                    self.txtPostCode.text = self.marrGuideDashboardModel.detail?.pincode ?? ""
                    self.txtStreetAddtess.text = self.marrGuideDashboardModel.detail?.permanentAddress ?? ""
                  
                    //  self.lblGuideName.text = self.marrDetail.fullName
                    
//                    if(self.marrDetail.totalUnreadMsgCount == 0){
//                        guideMainVC.hideUnRead()
//                    }
//                    else{
//                        guideMainVC.setUnread(number: "\(self.marrDetail.totalUnreadMsgCount)")
//                    }
                    
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
            countryCode = info.countryCode!
            self.countryShortName = info.countryShortName!
           
           // self.lblCountryCode.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) \(info.countryCode!)"
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
        print(lblIntrest.text)
    }
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
       
            self.dismiss(animated: true)
       
    }
    
    @IBAction func btnCoverImage(_ sender: UIButton) {
        getGallery()
        isProfile = false
        isDocument = false
        isCover = true
//        if(ConstantFunction.sharedInstance.openCamera()){
//            self.imagePicker.present(from: sender)
//        }
//        else{
//            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
//        }
        checkImage = "Cover"
        
    }
    
    @IBAction func btnChangeDocument(_ sender: UIButton) {
        getGallery()
        isProfile = false
        isDocument = true
        isCover = false
//        if(ConstantFunction.sharedInstance.openCamera()){
//            self.imagePicker.present(from: sender)
//        }
//        else{
//            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
//        }
        checkImage = "Document"

    }
    
    @IBAction func btnProfileImage(_ sender: UIButton) {
        getGallery()
        isProfile = true
        isDocument = false
        isCover = false
//        if(ConstantFunction.sharedInstance.openCamera()){
//            self.imagePicker.present(from: sender)
//        }
//        else{
//            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
//        }
        checkImage = "Profile"

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
            
            self?.myDate = Int(self?.yearsBetweenDate(startDate: selectedDate, endDate: Date()) ?? 0)
          
            if self?.myDate ?? 0 < 18 {
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Age must be 18 years or greater")
            }
            
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
        CountriesViewController.show(countriesViewController: self.countriesViewController, toVar: self, stripe_status: false)
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
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPhone.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter contact number")
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
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtPostCode.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter postcode")
        }
//        else if(isCoverSelected == false){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select cover image")
//        }
//        else if(isProfileSelected == false){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select profile image")
//        }
//        else if(isDocumentSelected == false){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select document image")
//        }
        else if(ConstantFunction.sharedInstance.isEmailValid(email: txtMinimumBooking.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter minimumCharge")
        }
        else if myDate < 18 {
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Age must be 18 years or greater")
        }
        else if(!bankAcc){

            if(self.stripeConnected == false){
               ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Create a Stripe Account")
            }else{
                callSaveDataAPI(type: 2)

            }

        }
        
        //else if(self.stripeConnected == false){
          //  ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please Create a Stripe Account")
        //}
        else{
            //if(viewType == "Guide"){
        //imageUpload()
                callSaveDataAPI(type: 2)
            
           // myImageUploadRequest()
//            }
//            else{
//                callSaveDataAPI(type: 1)
//            }
        }
    }
      
    
//    func imageUpload() {
//        IJProgressView.shared.showProgressView()
//        print (txtPhone.text!)
//        var mobile = txtPhone.text!
//        print(countryCode)
//        if(txtPhone.text!.contains(countryCode)) {
//            let fullNameArr = mobile.components(separatedBy: " ")
//            var firstName: String = fullNameArr[0]
//            var lastName: String = fullNameArr[1]
//            if lastName == "" {
//                lastName = fullNameArr[2]
//            }
//            mobile = "+" + countryCode + " " + lastName
//        } else {
//            let fullNameArr = mobile.components(separatedBy: " ")
//            var firstName: String = fullNameArr[0]
//            var lastName: String = fullNameArr[1]
//            if lastName == "" {
//                lastName = fullNameArr[2]
//            }
//            mobile = "+" + countryCode + " " + lastName
//        }
//        print(mobile)
//      //  "mobile":"+\(countryCode)\(txtPhone.text!)"
//        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":mobile,"descriptions":txtShortDesc.text!,"languageKnown":"\(arrSelectedLanguage.map{String($0)}.joined(separator: ","))","placesKnown":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))","interest":"\(arrSelectedItemID.map{String($0)}.joined(separator: ","))","dob":self.dob,"since":txtGuidAge.text!,"minimumCharge":txtMinimumBooking.text!,"tourStartTime":txtStartTime.text!,"permanentAddress":"\(txtStreetAddtess.text!) \(txtCity.text!) \(txtState.text!) \(txtCountry.text!) \(txtPostCode.text!)","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostCode.text!,"currencyType":"USD"] as [String : Any]
//        print(self.imgCover.image!)
//        print(self.imgPhoto.image!)
//        print(self.imgDocument.image!)
//        print(dict)
//
//        requestWith(endUrl: API_UpdateGuideProfile, imagedata: imgCover.image!.jpegData(compressionQuality: 1.0) , imagedata2: imgPhoto.image!.jpegData(compressionQuality: 1.0) , imagedata3: imgDocument.image!.jpegData(compressionQuality: 1.0), parameters: dict, onCompletion: { (json) in
//            print(json)
////            let apiResponce = JSON(json)
////            self.marrGuideDetails = GuideDetails(apiResponce)
////            print(self.marrLoginModel)
//
//        }) { (error) in
//            print(error)
//
//        }
//    }
//
//    func requestWith(endUrl: String, imagedata: Data? , imagedata2: Data?, imagedata3: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
//
//        let url = endUrl
//
//        let headers: HTTPHeaders? = ["x-api-key":KU_AUTHTOKEN]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//
//            if let data = imagedata{
//                multipartFormData.append(data, withName: "coverPic", fileName: "fileName.png", mimeType: "image/jpeg")
//            }
//
//            if let data = imagedata2{
//                multipartFormData.append(data, withName: "profilePic", fileName: "fileName.png", mimeType: "image/jpeg")
//            }
//
//            if let data = imagedata3{
//                multipartFormData.append(data, withName: "license", fileName: "fileName.png", mimeType: "image/jpeg")
//            }
//
//
//        }, to:url,headers: headers)
//        { (result) in
//            IJProgressView.shared.hideProgressView()
//
//            switch result {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    let json : JSON = JSON(response.result.value)
//                    print(json)
//                    // let message = response["message"].stringValue
//                  //  let apiResponce = JSON(json)
//                    self.marrLoginModel = LoginModel(json)
//                    print(self.marrLoginModel)
////                    let apiResponce = JSON(responseObj)
////                    self.marrLoginModel = LoginModel(apiResponce)
//                    print("Post Successfully Posted and file successfully uploaded")
//                   // self.removeFilledData()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    //  self.navigationController?.popViewController(animated: true)
//
//                    if let err = response.error {
//                        onError?(err)
//                        return
//                    }
//                    onCompletion?(json)
//                }
//            case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                onError?(error)
//            }
//        }
//    }
//
//
//
//
//
//    func myImageUploadRequest() {
//
//            var imgKey: String?
//            let myUrl = NSURL(string: API_UpdateGuideProfile)
//            let request = NSMutableURLRequest(url:myUrl! as URL);
//            request.httpMethod = "POST"
//    //UserDefaults.standard.string(forKey: "id") ?? ""
//
//        IJProgressView.shared.showProgressView()
//        print (txtPhone.text!)
//        var mobile = txtPhone.text!
//        print(countryCode)
//        if(txtPhone.text!.contains(countryCode)) {
//            let fullNameArr = mobile.components(separatedBy: " ")
//            var firstName: String = fullNameArr[0]
//            var lastName: String = fullNameArr[1]
//            if lastName == "" {
//                lastName = fullNameArr[2]
//            }
//            mobile = "+" + countryCode + " " + lastName
//        } else {
//            let fullNameArr = mobile.components(separatedBy: " ")
//            var firstName: String = fullNameArr[0]
//            var lastName: String = fullNameArr[1]
//            if lastName == "" {
//                lastName = fullNameArr[2]
//            }
//            mobile = "+" + countryCode + " " + lastName
//        }
//        print(mobile)
//      //  "mobile":"+\(countryCode)\(txtPhone.text!)"
//        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":mobile,"descriptions":txtShortDesc.text!,"languageKnown":"\(arrSelectedLanguage.map{String($0)}.joined(separator: ","))","placesKnown":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))","interest":"\(arrSelectedItemID.map{String($0)}.joined(separator: ","))","dob":self.dob,"since":txtGuidAge.text!,"minimumCharge":txtMinimumBooking.text!,"tourStartTime":txtStartTime.text!,"permanentAddress":"\(txtStreetAddtess.text!) \(txtCity.text!) \(txtState.text!) \(txtCountry.text!) \(txtPostCode.text!)","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostCode.text!,"currencyType":"USD", "coverPic" : self.imgCover.image ?? UIImage(named: "") as Any ,"profilePic" : self.imgPhoto.image ?? UIImage(named: "") as Any, "license" : self.imgDocument.image ?? UIImage(named: "") as Any] as [String : Any]
//        print(dict)
//        print(self.imgCover.image!)
//        print(self.imgPhoto.image!)
//        print(self.imgDocument.image!)
//
////            var param:[String:Any] = ["id":"121",
////                                    "name":fullNametfd.text ?? "","address":addresstfd.text ?? "","city":citytfd.text ?? "","state":statetfd.text ?? "",
////    "country":countrytfd.text ?? "","zip":ziptfd.text ?? "","image": picImgview.image ?? UIImage(named: "") as Any ]
//
//            let HEADER_CONTENT_TYPE = ["x-api-key":KU_AUTHTOKEN]
//
//            let boundary = generateBoundaryString()
//            request.setValue("multipart/form-data; boundary=\(KU_AUTHTOKEN)", forHTTPHeaderField: "x-api-key")
//
//
//        let imageData = self.imgCover.image?.jpegData(compressionQuality: 1)
//            if imageData == nil  {
//                return
//            }
////        let imageData2 = self.imgPhoto.image?.jpegData(compressionQuality: 1)
////            if imageData2 == nil  {
////                return
////            }
////        let imageData3 = self.imgDocument.image?.jpegData(compressionQuality: 1)
////            if imageData3 == nil  {
////                return
////            }
//
//            request.httpBody = createBodyWithParameters(parameters: dict, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary, imgKey: imgKey ?? "") as Data
//
//            let task = URLSession.shared.dataTask(with: request as URLRequest) {
//                data, response, error in
//
//                    if error != nil {
//                        print("error=\(error!)")
//                        return
//                    }
//
//                    //print response
//                    print("the image response = \(response!)")
//
//                    // print reponse body
//    //                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//    //                print("response data = \(responseString!)")
//
//                let responseJSON = try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])
//                if let responsepfJSON = responseJSON as? [String: Any] {
//                    print("the response of json updateprofile \(responsepfJSON)") //Code after Successfull POST Request
//                    let phoneNumber = responsepfJSON["mobile"] as? String
//                    UserDefaults.standard.set(phoneNumber, forKey: "phone")
//                    _ = responsepfJSON["id"] as? String
//                    UserDefaults.standard.string(forKey: "id")
//
//                    let status = responsepfJSON["status"] as? String ?? ""
//                    if status == "1"{
////                        DispatchQueue.main.async {
////                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashViewController") as? DashViewController else{
////                                return
////                            }
////                                    vc.modalPresentationStyle = .fullScreen
////                                    self.present(vc,animated: true)
////                        }
//                    }else{
//
//                    }
//                }
//
//                }
//
//                task.resume()
//            }
//
//
//
//
//        func createBodyWithParameters(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String, imgKey: String) -> NSData {
//                let body = NSMutableData();
//
//                if parameters != nil {
//                    for (key, value) in parameters! {
//                        body.appendString(string: "--\(boundary)\r\n")
//                        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                        body.appendString(string: "\(value)\r\n")
//                    }
//                }
//
//                let filename = "\(imgKey).png"
//                let mimetype = "image/png"
//
//                body.appendString(string: "--\(boundary)\r\n")
//                body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//                body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
//                body.append(imageDataKey as Data)
//                body.appendString(string: "\r\n")
//                body.appendString(string: "--\(boundary)--\r\n")
//
//                return body
//            }
//
//            func generateBoundaryString() -> String {
//                return "Boundary-\(NSUUID().uuidString)"
//            }
//
//
//
//
//
//
//
    
    
    
    
    //MARK: - Api Call
    func callSaveDataAPI(type: Int){
        IJProgressView.shared.showProgressView()
        print (txtPhone.text!)
        var mobile = txtPhone.text!
        print(countryCode)
        mobile = "+" + countryCode + " " + txtPhone.text!

        print(mobile)
        
//        if(txtPhone.text!.contains(countryCode)) {
//            let fullNameArr = mobile.components(separatedBy: " ")
//            var firstName: String = fullNameArr[0]
//            var lastName: String = fullNameArr[1]
//            if lastName == "" {
//                lastName = fullNameArr[2]
//            }
//            mobile = "+" + countryCode + " " + lastName
//        } else {
//            let fullNameArr = mobile.components(separatedBy: " ")
//            var firstName: String = fullNameArr[0]
//            var lastName: String = fullNameArr[1]
//            if lastName == "" {
//                lastName = fullNameArr[2]
//            }
//            mobile = "+" + countryCode + " " + lastName
//        }
       
      //  "mobile":"+\(countryCode)\(txtPhone.text!)"
        if self.dob == "" {
            self.dob = data?.dob ?? ""
        }
        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","fullName":txtFullName.text!,"address":txtLocation.text!,"latitude":latitude,"longitude":logitude,"countryNameCode":countryShortName,"mobile":mobile,
                    "descriptions":txtShortDesc.text!,"languageKnown":"\(arrSelectedLanguage.map{String($0)}.joined(separator: ","))","placesKnown":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))","interest":"\(arrSelectedItemID.map{String($0)}.joined(separator: ","))","dob":self.dob,"since":txtGuidAge.text!,"minimumCharge":txtMinimumBooking.text!,"tourStartTime":txtStartTime.text!,"permanentAddress":"\(txtStreetAddtess.text!)  ","city":txtCity.text!,"state":txtState.text!,"country":txtCountry.text!,"pincode":txtPostCode.text!,"currencyType":"USD"] as [String : Any]
        
        print(dict)
        print(self.imgCover.image!)
        print(self.imgPhoto.image!)
        print(self.imgDocument.image!)

            APIhandler.SharedInstance.Api_withImageAndParameters(aWebServiceName: API_UpdateGuideProfile, aDictParam: dict,aImag: self.imgCover.image!,aImag2: imgDocument.image!,aImag3:imgPhoto.image! ,imgParameter: "coverPic" ,imgParameter2: "license" ,imgParameter3: "profilePic" , completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            self.marrGuideDetailModel = GuideDetailModel(apiResponce)
                
                let license = self.marrLoginModel.personalInfo?.license
            UserDefaults.standard.set(license, forKey: "license") //setObject
            let license1 =  UserDefaults.standard.string(forKey: "license")


            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                 self.dismiss(animated: true)
                 UserDefaults.standard.set("LAST", forKey: "isFirstLogin")
            }
            else {
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
    
    //MARK: - This function is used to show info in alert
    func showInfo(_ viewController: UIViewController,message: String, Title: String = "Alert") {
        let alertController = UIAlertController(title: Title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func getGallery() {
        DispatchQueue.main.async {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.navigationBar.barTintColor = UIColor.black
            imagePickerController.navigationBar.tintColor = UIColor.white
            imagePickerController.allowsEditing = true
            imagePickerController.navigationBar.titleTextAttributes = [
                kCTForegroundColorAttributeName : UIColor.white
            ] as [NSAttributedString.Key : Any]
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Choose Media", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                self.tabBarController?.tabBar.isHidden = false
            }
            let savedPhotoAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
                self.tabBarController?.tabBar.isHidden = true
                imagePickerController.sourceType = .savedPhotosAlbum
                imagePickerController.delegate = self
                imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                imagePickerController.videoQuality = UIImagePickerController.QualityType.typeMedium
                imagePickerController.mediaTypes = [kUTTypeImage as String]
                
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized {                       //check user can access photo gallary or not
                        DispatchQueue.main.async {
                            self.tabBarController?.tabBar.isHidden = true
                            self.present(imagePickerController, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showInfo(self, message: "You have not allowed access to your photo gallery. Kindly allow from setting option of your device.")
                        }
                    }
                })
            }
            let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take a photo", style: .default) { action -> Void in
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                imagePickerController.videoMaximumDuration = 30
                imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                imagePickerController.videoQuality = UIImagePickerController.QualityType.typeMedium
                imagePickerController.mediaTypes = [kUTTypeImage as String]
                self.tabBarController?.tabBar.isHidden = true
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                    if granted {                                     //check user can access camera or not
                        DispatchQueue.main.async {
                            self.tabBarController?.tabBar.isHidden = true
                            self.present(imagePickerController, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showInfo(self, message: "You have not allowed access to your camera. Kindly allow from setting option of your device.")
                        }
                    }
                })
            }
            actionSheetController.addAction(cancelAction)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                actionSheetController.addAction(takePhotoAction)
                actionSheetController.addAction(savedPhotoAction)
            } else {
                print("source type not found")
                actionSheetController.addAction(savedPhotoAction)
            }
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
}
                     
extension Guide_Update_Stripes {
    //MARK: - Delegates UIImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.tabBarController?.tabBar.isHidden = false
        // self.blankImageArr[0] = true
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            fileName = url.lastPathComponent
            let   fileType = url.pathExtension
        }
        
        if let image = info[.editedImage] as? UIImage {
            
            if checkImage == "Cover" {
                self.isCoverSelected = true
             //   self.imgCover.image = nil
                self.imgCover.image = image.resizedTo2MB()
                imageName = image.pngData()
                guard let imagData = imageName else { return }
                self.imagData = imagData
            }
           else if checkImage == "Profile" {
                self.isProfileSelected = true
              //  self.imgPhoto.image = nil
                self.imgPhoto.image = image.resizedTo2MB()
                imageName = image.pngData()
                guard let imagData = imageName else { return }
                self.imagData = imagData
            } else if checkImage == "Document" {
                self.isDocumentSelected = true
               // self.imgDocument.image = nil
                self.imgDocument.image = image.resizedTo2MB()
                imageName = image.pngData()
                guard let imagData = imageName else { return }
                self.imagData = imagData
            }
            else {
                
            }
            
            //  guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
            
            // self.txtUploadID.text = fileUrl.lastPathComponent
            
            
            //  self.txtUploadID.text = randomString + ".jpeg"
        } else {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if checkImage == "Cover" {
                    self.isCoverSelected = true
                    self.imgCover.image = nil
                    self.imgCover.image = image.resizedTo2MB()
                    imageName = image.pngData()
                    guard let imagData = imageName else { return }
                    self.imagData = imagData
                }
                  else if checkImage == "Profile" {
                      self.isProfileSelected = true
                      self.imgPhoto.image = nil
                      self.imgPhoto.image = image
                    self.imgPhoto.image = image.resizedTo2MB()
                    imageName = image.pngData()
                    guard let imagData = imageName else { return }
                    self.imagData = imagData
                } else if checkImage == "Document" {
                    self.isDocumentSelected = true
                    self.imgDocument.image = nil
                    self.imgDocument.image = image.resizedTo2MB()
                    imageName = image.pngData()
                    guard let imagData = imageName else { return }
                    self.imagData = imagData
                }
                else {
                    
                }
                   
                //   guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
                //     self.txtUploadID.text =   randomString + ".jpeg"
                
                //  self.txtUploadID.text = fileUrl.lastPathComponent
            }
        }
        picker.dismiss(animated:true, completion: nil)
        // self.tabBarController?.tabBar.isHidden = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
       // self.tabBarController?.tabBar.isHidden = false
    }
}


//extension EditGuideDetailVC: ImagePickerDelegate {
//    func didSelect(image: UIImage?, name: String) {
//        if(image != nil){
//            if(isProfile){
//                self.isProfileSelected = true
//                self.imgPhoto.image = nil
//                self.imgPhoto.image = image
//            }
//            else if(isDocument){
//                self.isDocumentSelected = true
//                self.imgDocument.image = nil
//                self.imgDocument.image = image
//            }
//            else if(isCover){
//                self.isCoverSelected = true
//                self.imgCover.image = nil
//                self.imgCover.image = image
//            }
//        }
//    }
//}
 
extension Guide_Update_Stripes: UITableViewDelegate,UITableViewDataSource{
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

extension Guide_Update_Stripes: GMSAutocompleteViewControllerDelegate {

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

extension Guide_Update_Stripes: CountriesViewControllerDelegate {
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country]) {
         
    }
    
    func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) {
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        if let info = self.getCountryAndName(country.countryCode) {
            countryCode = info.countryCode!
 
            
            print (txtPhone.text!)
            var mobile = txtPhone.text!
//            if(txtPhone.text!.contains(countryCode)) {
//                let fullNameArr = mobile.components(separatedBy: " ")
//                var firstName: String = fullNameArr[0]
//                var lastName: String = fullNameArr[1]
//                if lastName == "" {
//                    lastName = fullNameArr[2]
//                }
//                mobile = "+" + countryCode + " " + lastName
//            } else {
//                let fullNameArr = mobile.components(separatedBy: " ")
//                var firstName: String = fullNameArr[0]
//                var lastName: String = fullNameArr[1]
//                if lastName == "" {
//                    lastName = fullNameArr[2]
//                }
//                mobile = "+" + countryCode + " " + lastName
//            }
            
            mobile = "+" + countryCode + " " + txtPhone.text!

            print(mobile)
          //  self.txtPhone.text = mobile
            
            print(countryCode)
            self.countryShortName = info.countryShortName ?? ""
            
            UserDefaults.standard.set(info.countryFlag ?? "" , forKey: "countryFlag") //setObject
            UserDefaults.standard.set(info.countryShortName ?? "" , forKey: "countryShortName") //setObject
            UserDefaults.standard.set(info.countryCode ?? "", forKey: "countryCode") //setObject
            
            //self.lblCountryCode.text = "\(info.countryFlag!) (\(info.countryShortName ?? ""))"
            self.lblCountryCode.text = "\(info.countryFlag!) (\(info.countryShortName ?? "")) +\(countryCode ?? "")"

            
            self.dismiss(animated: true)
        }
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country) {
    }
}




