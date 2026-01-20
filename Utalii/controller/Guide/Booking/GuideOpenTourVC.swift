//
//  GuideOpenTourVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 07/12/22.
//

import UIKit
import SwiftyJSON
import Cosmos
import SDWebImage
import Alamofire

class GuideOpenTourVC: UIViewController{
    //MARK: - Outlet
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTourStartDate: UILabel!
    @IBOutlet weak var lblTourEndDate: UILabel!

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblServiceId: UILabel!
    @IBOutlet weak var lblServiceDate: UILabel!
    @IBOutlet weak var lblServiceTime: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    
    @IBOutlet weak var lblPackageTitle: UILabel!
    @IBOutlet weak var lblCurrncy: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDayMonth: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPlaceCover: UILabel!
    @IBOutlet weak var lblEstimetTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    
    @IBOutlet weak var lblPackageTitle1: UILabel!
    @IBOutlet weak var lblCurrncy1: UILabel!
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var lblDayMonth1: UILabel!
    @IBOutlet weak var lblDesc1: UILabel!
    @IBOutlet weak var lblPackageTime: UILabel!
    
    @IBOutlet weak var lblTourStartDate1: UILabel!
    @IBOutlet weak var lblTourStartTime: UILabel!
    @IBOutlet weak var lblNOD: UILabel!
    @IBOutlet weak var lblRPD: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblPriceCreditCart: UILabel!

    @IBOutlet weak var viewSpecial: UIView!
    @IBOutlet weak var viewDay: UIView!
    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var btnEndTour: UIButton!
    @IBOutlet weak var btnStartTour: UIButton!
    @IBOutlet weak var viewMsg: UIView!
    
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var lblUserReview: CosmosView!
    @IBOutlet weak var lblReviewText: UILabel!
    
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var viewStartHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewComplited: UIView!
    @IBOutlet weak var viewComplitedHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewPaid: UIView!

    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var marrOrderDetailModel : OrderDetailModel!
    var marrOrderDetails : OrderDetails!
    var orderId = ""
    var marrLoginModel : LoginModel!
    var isComplited = false
    var orderNumber = ""
    var guideName = ""
    var tripLocation = ""
    var tripTime = ""
    var tripDate = ""
    var touristName = ""
    var touristMobile = ""
    var guideMobile = ""
    var touristID = ""
    var guideID = ""

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        if(UserDefaults.standard.string(forKey: KU_USERID) ?? "" == ""){
            viewPaid.isHidden = true
        }
        else{
            viewPaid.isHidden = false
        }
        
        callDetailAPI()
        if(isComplited){
            viewStart.isHidden = true
            viewStartHeight.constant = 0
            
            viewComplited.isHidden = true
            viewComplitedHeight.constant = 0
        }
        else{
            
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
        imgBack.changePngColorTo(color: white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorBlue
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    func setTheme(){
        
    }
    
    @IBAction func ShowRating(_ sender: Any) {
        
        
        print("the user details are \(marrOrderDetails)")
        
        
        if(marrOrderDetails != nil){
            let vc:postReviewGuide = guideStoryBoard.instantiateViewController(withIdentifier: "postReviewGuide") as! postReviewGuide
            vc.marrOrderDetails = marrOrderDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
        
    }
    
    
    
    
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMsg(_ sender: UIButton) {
        if(marrOrderDetails != nil){
            guideMainVC.hideVC()
            let vc : ChatConversationVC = (touristStoryBoard.instantiateViewController(withIdentifier: "ChatConversationVC") as! ChatConversationVC)
            vc.profile = self.marrOrderDetails.travellerPic
            vc.userid = self.marrOrderDetails.travellerUserId
            vc.username = self.marrOrderDetails.travellerfullName
            vc.orderID = self.marrOrderDetails.orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnStartTour(_ sender: UIButton) {
        let alert = UIAlertController(title: "Start", message: "Are you sure you want to start tour?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
               // self.srartEndTourAPI(keyword: "start")
                
                let vc : OTP_Screen = (guideStoryBoard.instantiateViewController(withIdentifier: "OTP_Screen") as! OTP_Screen)
                vc.otp_data.order_id = self.orderId
                vc.otp_data.tourist_id = self.touristID
                vc.otp_data.otp_type = "start_tour_otp"
                vc.delegate = self

                self.navigationController?.pushViewController(vc, animated: true)
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnEnd(_ sender: UIButton) {
        if(lblTourStartDate.text == "Tour Start at 00:00"){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please click start tour button")
        }
        else{
            let alert = UIAlertController(title: "End", message: "Are you sure you want to end the ongoing tour?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    //self.srartEndTourAPI(keyword: "end")
                    let vc : OTP_Screen = (guideStoryBoard.instantiateViewController(withIdentifier: "OTP_Screen") as! OTP_Screen)
                    vc.otp_data.order_id = self.orderId
                    vc.otp_data.tourist_id = self.touristID
                    vc.otp_data.otp_type = "end_tour_otp"
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Api Call
    func callDetailAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":orderId]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_OrderDetail, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrOrderDetailModel = OrderDetailModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            
            self.touristName = self.marrOrderDetailModel.details?.travellerfullName ?? ""
            self.orderNumber = self.marrOrderDetailModel.details?.orderNumber ?? ""
            self.guideName = self.marrOrderDetailModel.details?.guidefullName ?? ""
            self.tripLocation = self.marrOrderDetailModel.details?.tripLocation ?? ""
            self.tripTime = self.marrOrderDetailModel.details?.guideStartTime ?? ""
            self.tripDate = self.marrOrderDetailModel.details?.guideStartDate ?? ""
            self.touristID = self.marrOrderDetailModel.details?.travellerUserId ?? ""
            self.guideID = self.marrOrderDetailModel.details?.guideId ?? ""
            print("The Tourist id is \(self.touristID)")
            
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: self.tripDate)!
            dateFormatter.dateFormat = "MM-dd-yy"
            dateFormatter.locale = tempLocale // reset the locale
            self.tripDate = dateFormatter.string(from: date)
            print("EXACT_DATE : \(self.tripDate)")
            
            self.touristMobile = self.marrOrderDetailModel.details?.travellerMobile ?? ""
            self.guideMobile = self.marrOrderDetailModel.details?.guideMobile ?? ""
            
            if(self.marrOrderDetailModel.status.equalIgnoreCase("1")){
                if(self.marrOrderDetailModel.details != nil){
                    self.marrOrderDetails = self.marrOrderDetailModel.details!
                    
                    if(!ConstantFunction.sharedInstance.isEmpty(txt: self.marrOrderDetails.startTime)){
                        self.lblTourStartDate.text = "Tour Start at \(ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrOrderDetails.startTime))"
                    }
                    if(!ConstantFunction.sharedInstance.isEmpty(txt: self.marrOrderDetails.hireEndTime)){
                        self.lblTourStartDate.text = "Tour Start at \(ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrOrderDetails.hireEndTime))"
                    }
                    
                    let urlNew:String = (self.marrOrderDetails.travellerPic).replacingOccurrences(of: " ", with: "%20")
                    
                    self.imgUser.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))

                     
                    self.lblUserName.text = self.marrOrderDetails.travellerfullName
                    self.lblServiceId.text = self.marrOrderDetails.orderNumber
                    self.lblServiceDate.text = ConstantFunction.sharedInstance.changeDateFormate15(aDate: self.marrOrderDetails.guideStartDate)
                    self.lblServiceTime.text = ConstantFunction.sharedInstance.changeDateFormate16(aDate: self.marrOrderDetails.guideStartTime)
                    self.lblUserAddress.text = self.marrOrderDetails.location
                    
                    self.lblPackageTitle.text = self.marrOrderDetails.packageName
                    self.lblCurrncy.text = self.marrOrderDetails.currencySymbol
                    self.lblPrice.text = "\(self.marrOrderDetails.packagePrice)/"
                    self.lblDayMonth.text = self.marrOrderDetails.packageType
                    self.lblAddress.text = self.marrOrderDetails.location
                    self.lblPlaceCover.text = self.marrOrderDetails.placesCovered
                    self.lblEstimetTime.text = self.marrOrderDetails.estimatedTime
                    self.lblStartTime.text = self.marrOrderDetails.startTime
                    
                    self.lblPackageTitle1.text = self.marrOrderDetails.packageName
                    self.lblCurrncy1.text = self.marrOrderDetails.currencySymbol
                    self.lblPrice1.text = "\(self.marrOrderDetails.packagePrice)/"
                    self.lblDayMonth1.text = self.marrOrderDetails.packageType
                    
                    self.lblDesc1.attributedText = self.marrOrderDetails.packageDescription.attributedHtmlString
                    self.lblDesc1.text = self.lblDesc1.text?.stripOutHtml()
                    self.lblDesc1.setRegularFontWithSize(size: 13)
                    self.lblPackageTime.text = self.marrOrderDetails.duration
                    self.lblDesc1.textColor = white
                    self.lblDesc1.textAlignment = .center
                    self.lblTourStartDate1.text = ConstantFunction.sharedInstance.changeDateFormate22(aDate: self.marrOrderDetails.startTime)
                    self.lblTourStartTime.text = ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrOrderDetails.defaultPackageStartTime)
                    self.lblNOD.text = "1 Day"
                    self.lblRPD.text = "\(self.marrOrderDetails.currencySymbol)\(self.marrOrderDetails.packagePrice)"
                    self.lblTotal.text = "\(self.marrOrderDetails.currencySymbol)\(self.marrOrderDetails.packagePrice)"
                    
                    self.lblPriceCreditCart.text = "Paid \(self.marrOrderDetails.currencySymbol)\(self.marrOrderDetails.packagePrice) (via Credit Card)"

                    self.lblTourStartDate.text = "Tour Start at \(ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrOrderDetails.guideStartTime))"
                    self.lblTourEndDate.text = "Tour Start end at \(ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrOrderDetails.hireEndTime))"
                    
                    if(ConstantFunction.sharedInstance.isEmpty(txt: self.marrOrderDetails.guideStartTime)){
                        self.btnStartTour.backgroundColor = colorAccent
                        self.btnEndTour.isUserInteractionEnabled = false
                        self.viewMsg.isHidden = false
                    }
                    else{
                        self.btnStartTour.backgroundColor = purple_200

                        self.btnStartTour.isUserInteractionEnabled = false
                        self.btnEndTour.isUserInteractionEnabled = true
                        self.btnStatus.backgroundColor = .clear
                        self.btnStatus.borderColor = colorGreen
                        self.btnStatus.borderWidth = 2
                        self.btnStatus.cornerRadius = 8
                        self.btnEndTour.backgroundColor = colorBlue
                        self.btnStatus.setTitle("In Progress", for: .normal)
                        self.btnStatus.setTitleColor(colorBlue, for: .normal)
                        self.viewMsg.isHidden = false
                        
                        self.uDefault.set(self.orderId, forKey: KU_GUIDEORDERID)
                        self.uDefault.set(true, forKey: KU_ISGUIDESTARTTOUR)
                        guideMainVC.getUserLocation()
                    }
                    
                    if(self.marrOrderDetails.packageType == "day"){
                        self.viewSpecial.isHidden = true
                        self.viewDay.isHidden = false
                    }
                    else{
                        self.viewSpecial.isHidden = false
                        self.viewDay.isHidden = true
                    }
                    
                    if((!(ConstantFunction.sharedInstance.isEmpty(txt: self.marrOrderDetails.guideStartTime))) && (!(ConstantFunction.sharedInstance.isEmpty(txt: self.marrOrderDetails.hireEndTime))) && self.marrOrderDetails.guideStartTime != "00:00" && self.marrOrderDetails.hireEndTime != "00:00"){
                        self.btnStartTour.isUserInteractionEnabled = false
                        self.btnEndTour.isUserInteractionEnabled = false
                        self.btnStartTour.backgroundColor = purple_200
                        self.btnStatus.borderColor = colorGreen
                        self.btnStatus.backgroundColor = white
                        self.btnStatus.borderWidth = 2
                        self.btnStatus.cornerRadius = 8
                        self.btnStatus.setTitle("Completed", for: .normal)
                        self.btnEndTour.backgroundColor = colorBluetr
                        self.btnStatus.setTitleColor(colorGreen, for: .normal)
                        self.btnStatus.backgroundColor = .clear

                        self.viewMsg.isHidden = true
                        
                        self.uDefault.set("", forKey: KU_GUIDEORDERID)
                        self.uDefault.set(false, forKey: KU_ISGUIDESTARTTOUR)
                        guideMainVC.getUserLocation()
                    }
                    if(self.isComplited){
                        self.viewRating.isHidden = false
                        self.lblUserReview.rating = Double(self.marrOrderDetails.totalReviews) ?? 0.00
                        //lblReviewText.text = marrOrderDetails.re
                        
                    }
                    else{
                        self.viewRating.isHidden = true
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
    
    func convertBase64(string: String) -> String{
          if let data = (string).data(using: String.Encoding.utf8) {
              let base64 = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
           //   print(base64)// dGVzdDEyMw==\n
              return base64
          }
          return ""
      }
    
    func sosTouristAPI(OPTtosend:String) {
        IJProgressView.shared.showProgressView()
      
        var param: [String: AnyObject] = [:]
        let body = "Your Tour Booking ID: \(self.orderNumber) with \(self.guideName) for \(self.tripLocation) has been started on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam()).Your OTP is \(OPTtosend) for End tour confirmation"
       // "SOS message has sent"
        let to : String =   self.touristMobile
        let from : String = "+19033205901"
        
        param["Body"] = body as AnyObject
        param["From"] = from as AnyObject
        param["To"] = to as AnyObject
        
        print(param)
        let username = "AC0f0efb446e981a99200b769a4135d5cb";
        let password = "b8860542756575a335f364b2c54f7838";
        let credentials = (username + ":" + password);
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(username)/Messages"
        let parameters = ["From": "\(from)", "To": "\(to)", "Body": "\(body)"]
        AF.request(url,
                   method: .post,
                   parameters: parameters)
            .authenticate(username: username, password: password)
            .responseJSON { response in
                debugPrint(response)
            }
        
    }
    
    func sosGuideAPI(StartEnd:String) {
        IJProgressView.shared.showProgressView()
     
        var param: [String: AnyObject] = [:]
        var body = ""
        if(StartEnd == "start"){
            body = "Your Tour Booking ID: \(self.orderNumber) with \(self.touristName) for \(self.tripLocation) has been started on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        }
        else{
            body = "Your Tour Booking ID: \(self.orderNumber) with \(self.touristName) for \(self.tripLocation) has ended on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        }
        // "SOS message has sent"
        let to : String =   self.guideMobile
        let from : String = "+19033205901"
        
        param["Body"] = body as AnyObject
        param["From"] = from as AnyObject
        param["To"] = to as AnyObject
        
        print(param)
        let username = "AC0f0efb446e981a99200b769a4135d5cb";
        let password = "b8860542756575a335f364b2c54f7838";
        let credentials = (username + ":" + password);
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(username)/Messages"
        let parameters = ["From": "\(from)", "To": "\(to)", "Body": "\(body)"]
        AF.request(url,
                   method: .post,
                   parameters: parameters)
            .authenticate(username: username, password: password)
            .responseJSON { response in
                debugPrint(response)
            }
    }
    
    //    smsForTourist = "Your Tour Booking ID: "+orderNumber+" with "+guidefullName+" for "+tripLocation+" has been started on "+formattedTourStartDateForUI+" at "+formattedTourStartEndTimeforUIN;
    //
    //    smsForGuide = "Your Tour Booking ID: "+orderNumber+" with "+travellerfullName+" for "+tripLocation+" has been started on "+formattedTourStartDateForUI+" at "+formattedTourStartEndTimeforUIN;
    //
    //    smsForAdmin = "Tour Booking ID: "+orderNumber+" by "+travellerfullName+" with "+guidefullName+" for "+tripLocation+" has been started on "+formattedTourStartDateForUI+" at "+formattedTourStartEndTimeforUIN;
   
    func sosAdminAPI(StartEnd:String) {
        IJProgressView.shared.showProgressView()
       
        var param: [String: AnyObject] = [:]
        var body = ""
        if(StartEnd == "start"){
            body = "Your Tour Booking ID: \(self.orderNumber) with \(self.touristName) for \(self.tripLocation) has been started on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        }
        else{
            body = "Your Tour Booking ID: \(self.orderNumber) with \(self.touristName) for \(self.tripLocation) has ended on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        }
       // "SOS message has sent"
        let to : String =   "+18627559888"
        let from : String = "+19033205901"
        
        param["Body"] = body as AnyObject
        param["From"] = from as AnyObject
        param["To"] = to as AnyObject
        print(param)
        let username = "AC0f0efb446e981a99200b769a4135d5cb";
        let password = "b8860542756575a335f364b2c54f7838";
        let credentials = (username + ":" + password);
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(username)/Messages"
        let parameters = ["From": "\(from)", "To": "\(to)", "Body": "\(body)"]
        AF.request(url,
                   method: .post,
                   parameters: parameters)
            .authenticate(username: username, password: password)
            .responseJSON { response in
                debugPrint(response)
            }
    }
    

    
    func callSendPushOnTourStartToGuideAPI() {

        IJProgressView.shared.showProgressView()
        
        let message =  "Your Tour Booking ID: \(self.orderNumber) with \(self.touristName) for \(self.tripLocation) has been started on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        let dict = ["userId" : UserDefaults.standard.string(forKey: KU_USERID) ?? "",
                    "message" : message ]
        print("Start guide MESSAGE SENT IS \(message)")
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendPushMsgFCM, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
        
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callSendPushOnTourStartToTouristAPI(OPTtosend:String,touristid :String) {

        IJProgressView.shared.showProgressView()
        
        let message =  "Your Tour Booking ID: \(self.orderNumber) with \(self.guideName) for \(self.tripLocation) on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam()) EndTourOTP is \(OPTtosend)"
        let dict = ["userId" : touristid,
                    "message" : message ]
        print("PUSH tourist MESSAGE SENT IS \(message)")

        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendPushMsgFCM, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
        
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callSendPushOnTourEndToGuideAPI() {

        IJProgressView.shared.showProgressView()
        
        let message =  "Your Tour Booking ID: \(self.orderNumber) with \(self.touristName) for \(self.tripLocation) has been ended on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        let dict = ["userId" : UserDefaults.standard.string(forKey: KU_USERID) ?? "",
                    "message" : message ]
        print("End guide MESSAGE SENT IS \(message)")

        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendPushMsgFCM, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
        
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callSendPushOnTourEndToTouristAPI(touristid:String) {

        IJProgressView.shared.showProgressView()
        
        let message =  "Your Tour Booking ID: \(self.orderNumber) with \(self.guideName) for \(self.tripLocation) has been ended on \(self.tripDate) at \(ConstantFunction.sharedInstance.changeDateFormateaam())"
        let dict = ["userId" : touristid,
                    "message" : message ]
        print("end tourist MESSAGE SENT IS \(message)")

        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendPushMsgFCM, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
        
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func srartEndTourAPI(keyword: String){
//        calltwilioAPI(msg: "SMS has been send to \(marrOrderDetails.travellerMobile)", phone: "\(marrOrderDetails.travellerMobile)")
        
       
        IJProgressView.shared.showProgressView()
        let dict = ["guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":orderId,"date":ConstantFunction.sharedInstance.changeDateFormate111(),"time":ConstantFunction.sharedInstance.changeDateFormate112(),"keyword":keyword]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_StartEndTour, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            self.sosGuideAPI(StartEnd: keyword)
            self.sosAdminAPI(StartEnd: keyword)
//  sid
         
             
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if keyword == "start" {
                DispatchQueue.main.async {
                    self.sosTouristAPI(OPTtosend: self.marrLoginModel.endTourOTP)
                    self.callSendPushOnTourStartToGuideAPI()
                    self.callSendPushOnTourStartToTouristAPI(OPTtosend: self.marrLoginModel.endTourOTP,touristid: self.touristID)
                }
    
            } else {
                self.callSendPushOnTourEndToGuideAPI()
                self.callSendPushOnTourEndToTouristAPI(touristid: self.touristID)
            }
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                guideMainVC.getUserLocation()
                self.callDetailAPI()
                
                if(keyword == "end"){
                    self.uDefault.set(false, forKey: KU_ISGUIDESTARTTOUR)
                    guideMainVC.getUserLocation()
                }
                else{
                    self.uDefault.set(self.orderId, forKey: KU_GUIDEORDERID)
                    self.uDefault.set(true, forKey: KU_ISGUIDESTARTTOUR)
                    guideMainVC.getUserLocation()
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


////////////////////////////////////////////////////////////////////////////////////////////?ADDED NEW PARTS ?????///////////////////////////////////////////////////////////////////////
struct start_end_codable: Codable {
    let status: String?
    let message: String?
    let error:String?
    let keyword:String?
    let time:String?
    let endTourOTP:String?
    let orderId:String?
    let date:String?
}



extension GuideOpenTourVC:Otp_Verification{
    func otpVerified(otp_type: String) {
     
        print("delegate Otp Received is \(otp_type)")
        if(otp_type == "start_tour_otp"){
            print("START")
           // StartStopAction(Action_Type: "start")
            self.srartEndTourAPI(keyword: "start")
        }
        else if(otp_type == "end_tour_otp")
        {
           // StartStopAction(Action_Type: "end")
            self.srartEndTourAPI(keyword: "end")
            print("END")
        }else
        {
            print("Found No type")
        }
        
    }
    
    
    
    func StartStopAction(Action_Type:String){
        
        
        print("API CALLED")
        IJProgressView.shared.showProgressView()
        let apiUrl = URL(string: "https://utaliiworld.com/restapi/api/startEndTour")!
        // Create the request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        // Set the headers
        request.setValue("dffabc2b086faf74c8512d408c021a4f", forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Create the POST parameters as a dictionary
        let parameters: [String: Any] = [
            "guideId": self.guideID,
            "order_id": self.orderId,
            "time": ConstantFunction.sharedInstance.changeDateFormate112(),
            "keyword":Action_Type,
            "date":ConstantFunction.sharedInstance.changeDateFormate111()
        ]
        print("Sent PArameteres are \(parameters)")
        do {
            // Serialize the parameters as JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            // Attach the JSON data to the request
            request.httpBody = jsonData
            // Create a URLSession task for the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    IJProgressView.shared.hideProgressView()

                } else if let data = data {
                    IJProgressView.shared.hideProgressView()
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let rec_response = try decoder.decode(start_end_codable.self, from: data)
                        print("API CALLED 2")

                        if rec_response.status == "1" {
                            
                            
                           
                        } else {
                           
                            

                        }
                    } catch {
                        print("Error decoding API response: \(error)")
                    }
                    // You can handle the response data here
                }
            }
            // Start the URLSession task
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
            IJProgressView.shared.hideProgressView()

        }
        
        
        
        
    }
    
    
}




extension GuideOpenTourVC{
    
    
    
    
    
    
    
}
