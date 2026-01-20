//
//  BookingDetailVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 25/11/22.
//

import UIKit
import Cosmos
import SwiftyJSON
import Alamofire

class BookingDetailVC: UIViewController  {
    //MARK: - Outlet
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblServiceId: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    
    @IBOutlet weak var imgGuide: UIImageView!
    @IBOutlet weak var lblGuideName: UILabel!
    @IBOutlet weak var lblGuideLanguage: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    @IBOutlet weak var lblGuideAddress: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDayorMonth: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblFinalTime : UILabel!
    @IBOutlet weak var lblFinalDay: UILabel!
    @IBOutlet weak var lblRatePerDay: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    
    @IBOutlet weak var viewTransactionID: UIView!
    @IBOutlet weak var viewTransactionDate: UIView!
    @IBOutlet weak var viewStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewPaid: UIView!
    @IBOutlet weak var viewMessageYourGuide: UIView!
    
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var lblPriceCreditCart: UILabel!
    
    @IBOutlet weak var viewSpecial: UIView!
    @IBOutlet weak var viewDay: UIView!
    
    
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblCurrncy1: UILabel!
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var lblDayMonth1: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    
    @IBOutlet weak var lblPlaceOfCover1: UILabel!
    @IBOutlet weak var lblEstimatedTime1: UILabel!
    @IBOutlet weak var lblStartTime1: UILabel!
     
    @IBOutlet weak var viewPostReviewTop: NSLayoutConstraint!
    @IBOutlet weak var viewPostReviewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPostReview: UIView!
    @IBOutlet weak var imgIcon: UIImageView!

    @IBOutlet weak var viewSos: UIView!
    
    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var orderId = ""
    let lat = ""
    var long = ""
    
    var longi = ""
    var latti = ""
    var touristName = ""
    var guideName = ""
    var touristEmergencyNumber = ""
    var marrOrderDetailModel : OrderDetailModel!
    var marrOrderDetails : OrderDetails!
    var isPendingOrder = false
    var isOnGoing = false
    var curLocation = ""
   // let locationManager = CLLocationManager()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
        
        if(UserDefaults.standard.string(forKey: KU_USERID) ?? "" == "") {
            viewPaid.isHidden = true
        } else {
            viewPaid.isHidden = false
        }
        
        setTheme()
        imgBack.changePngColorTo(color: white)
        callDetailAPI()
        imgPin.changePngColorTo(color: colorPrimary)
        
        if(isOnGoing) {
            viewSos.isHidden = false
            lblStatus.text = "TOUR IN PROGRESS"
            lblStatus.textColor = colorGreen
            imgIcon.image = UIImage(named: "ic_inprogress")
            imgIcon.changePngColorTo(color: colorGreen)
            
            self.viewTransactionID.isHidden = true
            self.viewTransactionDate.isHidden = true
            self.viewStackViewHeight.constant = 26.33
        } else {
            if(isPendingOrder) {
                imgIcon.image = UIImage(named: "done")
                lblStatus.text = "BOOKING SUCCESSFULL"
                self.viewTransactionID.isHidden = true
                self.viewTransactionDate.isHidden = true
                self.viewStackViewHeight.constant = 26.33
            } else {
                imgIcon.image = UIImage(named: "done")
                lblStatus.text = "COMPLETED"
                self.viewTransactionID.isHidden = false
                self.viewTransactionDate.isHidden = false
                self.viewStackViewHeight.constant = 80
            }
            viewSos.isHidden = true
        }
        viewPostReviewTop.constant = 0
        viewPostReviewHeight.constant = 0
        viewPostReview.isHidden = true
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//       // lat =
//    }
    
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
        statusBar.backgroundColor = colorAccent
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    func setTheme(){
        
    }
    
    //MARK: - DataSource & Deleget
    
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPaid(_ sender: UIButton) {
        
    }
    
    @IBAction func btnMessageYourRequest(_ sender: UIButton) {
        if(marrOrderDetails != nil){
            touristMainVC.hideMenu()
            let vc : ChatConversationVC = (touristStoryBoard.instantiateViewController(withIdentifier: "ChatConversationVC") as! ChatConversationVC)
            vc.profile = self.marrOrderDetails.guidePic
            vc.userid = self.marrOrderDetails.guideId
            vc.username = self.marrOrderDetails.guidefullName
            vc.orderID = self.marrOrderDetails.orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnPostReview(_ sender: UIButton) {
        if(marrOrderDetails != nil){
            let vc:PostAReviewVC = touristStoryBoard.instantiateViewController(withIdentifier: "PostAReviewVC") as! PostAReviewVC
            vc.marrOrderDetails = marrOrderDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSos(_ sender: UIButton) {
        callSOSAPI()
    }
//    +18627559888
//    "Tourist name has sent an sos message to you for an emergency \n  current location : , \n guide name : "
   // tourist k emergency no pr msg
 
//    let dateFormatter = DateFormatter()
//    let tempLocale = dateFormatter.locale // save locale temporarily
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    let date = dateFormatter.date(from: self.tripDate)!
//    dateFormatter.dateFormat = "MM-dd-yy"
//    dateFormatter.locale = tempLocale // reset the locale
//    self.tripDate = dateFormatter.string(from: date)
//    print("EXACT_DATE : \(self.tripDate)")
    
    
    func sosAPI() {
        IJProgressView.shared.showProgressView()
      //  let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
//        latti =  UserDefaults.standard.string(forKey: "Lets") ?? ""
//        longi =  UserDefaults.standard.string(forKey: "Lets") ?? ""
       
        var param: [String: AnyObject] = [:]
        let body = "Tourist \(self.touristName) has sent an sos Message to you for an emergency \n Current Lattitude and Longitude are : \(self.latti), \(self.longi)\n Guide Name : \(self.guideName)"
       // "SOS message has sent"
        let to : String =   "+18627559888"
        let from : String = "+19033205901"
        
        param["Body"] = body as AnyObject
        param["From"] = from as AnyObject
        param["To"] = to as AnyObject
        
        print(param)
        let baseUrl : String = "https://api.twilio.com/2010-04-01/Accounts/AC0f0efb446e981a99200b769a4135d5cb/Messages.json"
        let username = "AC0f0efb446e981a99200b769a4135d5cb";
        let password = "b8860542756575a335f364b2c54f7838";
        let credentials = (username + ":" + password);
        let str = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
        
//        Account SID: AC0f0efb446e981a99200b769a4135d5cb
//        Auth Token: b8860542756575a335f364b2c54f7838
//        My Twilio phone number: +19033205901
    
    
        let auth = "Basic " + str

        let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key" : KU_AUTHTOKEN]

        APIhandler.SharedInstance.API_WithParameters(aurl: baseUrl, parameter: param, completeBlock: { (responseObj) in
           
            print (responseObj)
            if(showLog){
                print("\(param)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
           
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func sosAPIEmergency() {
        IJProgressView.shared.showProgressView()
      //  let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
//        latti =  UserDefaults.standard.string(forKey: "Lets") ?? ""
//        longi =  UserDefaults.standard.string(forKey: "Lets") ?? ""
       
        var param: [String: AnyObject] = [:]
        let body = "Tourist \(self.touristName) has sent an sos Message to you for an emergency \n Current Lattitude and Longitude are : \(self.latti), \(self.longi)\n Guide Name : \(self.guideName)"
       // "SOS message has sent"
        print(self.touristEmergencyNumber)
        let to : String =   "\(self.touristEmergencyNumber)"
        let from : String = "+19033205901"
        
        param["Body"] = body as AnyObject
        param["From"] = from as AnyObject
        param["To"] = to as AnyObject
        
        print(param)
        let baseUrl : String = "https://api.twilio.com/2010-04-01/Accounts/AC0f0efb446e981a99200b769a4135d5cb/Messages.json"
        let username = "AC0f0efb446e981a99200b769a4135d5cb";
        let password = "b8860542756575a335f364b2c54f7838";
        let credentials = (username + ":" + password);
        let str = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
        
//        Account SID: AC0f0efb446e981a99200b769a4135d5cb
//        Auth Token: b8860542756575a335f364b2c54f7838
//        My Twilio phone number: +19033205901
    
    
        let auth = "Basic " + str

        let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key" : KU_AUTHTOKEN]

        APIhandler.SharedInstance.API_WithParameters(aurl: baseUrl, parameter: param, completeBlock: { (responseObj) in
           
            print (responseObj)
            if(showLog){
                print("\(param)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
           
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    
    
    
//    func sosApi() {
//
//            let touristName = self.marrOrderDetails.travellerfullName
//            let guidename = self.marrOrderDetails.guidefullName
////            let currentLocation = self.marrOrderDetails
////            let emergencyNumber = self.marrOrderDetails.
//            var param: [String: AnyObject] = [:]
//            let body =  "SOS message has sent"
//            let to : String =  "+18627559888"
//            let from : String = "+19033205901"
//
//            param["Body"] = body as AnyObject
//            param["From"] = from as AnyObject
//            param["To"] = to as AnyObject
//
//            print(param)
//            let baseUrl : String = "https://api.twilio.com/2010-04-01/Accounts/AC0f0efb446e981a99200b769a4135d5cb/Messages.json"
//            let username = "AC0f0efb446e981a99200b769a4135d5cb";
//            let password = "b8860542756575a335f364b2c54f7838";
//            let credentials = (username + ":" + password);
//            let str = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
//
////        Account SID: AC0f0efb446e981a99200b769a4135d5cb
////        Auth Token: b8860542756575a335f364b2c54f7838
////        My Twilio phone number: +19033205901
//
//
//            let auth = "Basic " + str
//
//
//
//            let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key":KU_AUTHTOKEN]
//
//            Alamofire.request(baseUrl, method : .post, parameters: param, encoding: JSONEncoding.default as ParameterEncoding, headers: HEADER_CONTENT_TYPE).responseJSON
//            { response in
//                print(response)
//            //    MBProgressHUD.hide(for: self.view, animated: true)
//                if(response.response?.statusCode == 200)
//                {
//                    guard  let responseDict = response.value as? NSDictionary else { return }
//                    print(responseDict)
//
//                    let data = responseDict.object(forKey: "Data") as? NSDictionary
//                    let token = data?["Token"] ?? ""
//
//                    print(token)
//
//                    let email = data?["Username"] ?? ""
//                    let message = responseDict.object(forKey: "Message") as? String ?? ""
//
//                //    UserDefaults.standard.set(self.txtChangeLanguage.text ?? "" , forKey: "Language")
//                    var language = UserDefaults.standard.object(forKey: "Language")
//
//                } else {
//                    guard  let responseDict = response.value as? NSDictionary else { return }
//                    let message = responseDict.object(forKey: "Message") as? String ?? ""
//                    if message != "" {
//                       // self.view.makeToast(message: message) toast dikhana h
//                    }
//                }
//            }
//    }
    
    
    // sid check
    //MARK: - Api Call
    func callSOSAPI(){
//        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":UserDefaults.standard.string(forKey: KU_ISTURISTSTARTTOUR) ?? "","curLocation":"RAJKOT","lat":UserDefaults.standard.string(forKey: "A") ?? "","lon":UserDefaults.standard.string(forKey: "B") ?? ""]
        
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":UserDefaults.standard.string(forKey: KU_ISTURISTSTARTTOUR) ?? "","curLocation": self.curLocation ,"lat": latti ,"lon":longi]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_SOSREQUEST, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            self.sosAPI()
            self.sosAPIEmergency()

            print(JSON(responseObj))
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callDetailAPI(){
        IJProgressView.shared.showProgressView()
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":orderId]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_OrderDetail, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrOrderDetailModel = OrderDetailModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if(self.marrOrderDetailModel.status.equalIgnoreCase("1")){
                if(self.marrOrderDetailModel.details != nil){
                    self.marrOrderDetails = self.marrOrderDetailModel.details!
                    
                    self.lblServiceId.text = self.marrOrderDetails.orderNumber
                    
                    self.latti = self.marrOrderDetails.lat
                    self.longi = self.marrOrderDetails.lon

                    self.touristName = self.marrOrderDetails.travellerfullName
                    self.guideName = self.marrOrderDetails.guidefullName
                    self.touristEmergencyNumber = self.marrOrderDetails.emergencyNumber

                    self.lblTransactionID.text = self.marrOrderDetails.txnId
                    self.lblTransactionDate.text = ConstantFunction.sharedInstance.changeDateFormate19(aDate: self.marrOrderDetails.paymentDate)
                    
                    let urlNew:String = (self.marrOrderDetails.guidePic).replacingOccurrences(of: " ", with: "%20")
                    
                    self.imgGuide.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
                    
                    self.lblGuideName.text = self.marrOrderDetails.guidefullName
                    self.lblGuideLanguage.text = self.marrOrderDetails.languageKnown
                    self.viewRating.rating = Double(self.marrOrderDetails.avgRating) ?? 0.0
                    
                    self.lblTitle.text = self.marrOrderDetails.packageName
                    self.lblSymbol.text = self.marrOrderDetails.currencySymbol
                    self.lblPrice.text = "\(self.marrOrderDetails.packagePrice)/"
                    self.lblDayorMonth.text = self.marrOrderDetails.packageType
                    self.lblDesc.attributedText = self.marrOrderDetails.packageDescription.attributedHtmlString
                    self.lblDesc.text = self.lblDesc.text?.stripOutHtml()
                    self.lblDesc.textColor = white
                    self.lblDesc.textAlignment = .center
                    
                    self.lblDesc.setRegularFontWithSize(size: 13)
                    self.lblTime.text = self.marrOrderDetails.duration
                    self.lblDesc.textColor = white
                    self.lblDesc.textAlignment = .center
                    
                    self.lblStartDate.text = ConstantFunction.sharedInstance.changeDateFormate15(aDate: self.marrOrderDetails.guideStartDate)
                    self.lblFinalTime.text = ConstantFunction.sharedInstance.changeDateFormate16(aDate: self.marrOrderDetails.hireStartTime)
                    self.lblFinalDay.text = "1 Day"
                    self.lblRatePerDay.text = "\(self.marrOrderDetails.currencySymbol)\(self.marrOrderDetails.packagePrice)"
                    self.lblTotal.text = "\(self.marrOrderDetails.currencySymbol)\(self.marrOrderDetails.packagePrice)"
                    
                    self.lblPriceCreditCart.text = "Paid \(self.marrOrderDetails.currencySymbol)\(self.marrOrderDetails.packagePrice) (via Credit Card)"
                    
                    self.lblGuideAddress.text = self.marrOrderDetails.tripLocation
                    self.curLocation = self.marrOrderDetails.tripLocation
                    
                    self.lblTitle1.text = self.marrOrderDetails.packageName
                    self.lblCurrncy1.text = self.marrOrderDetails.currencySymbol
                    self.lblPrice1.text = "\(self.marrOrderDetails.packagePrice)/"
                    self.lblDayMonth1.text = self.marrOrderDetails.packageType
                    
                    self.lblAddress1.text = self.marrOrderDetails.location
                    self.lblPlaceOfCover1.text = self.marrOrderDetails.placesCovered
                    self.lblEstimatedTime1.text = self.marrOrderDetails.estimatedTime
                    self.lblStartTime1.text = self.marrOrderDetails.startTime
                     
                    if(self.marrOrderDetails.orderStatus == "Completed"){
                        self.viewMessageYourGuide.isHidden = true
                        self.viewPostReviewTop.constant = 12
                        self.viewPostReviewHeight.constant = 30
                        self.viewPostReview.isHidden = false
                        
                    }
                    else{
                        self.viewMessageYourGuide.isHidden = false
                        self.viewPostReviewTop.constant = 0
                        self.viewPostReviewHeight.constant = 0
                        self.viewPostReview.isHidden = true
                    }
                    
                    
                    if(self.marrOrderDetails.packageType == "day"){
                        self.viewSpecial.isHidden = true
                        self.viewDay.isHidden = false
                    }
                    else{
                        self.viewSpecial.isHidden = false
                        self.viewDay.isHidden = true
                    }
                    
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrOrderDetailModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
