//
//  BookingHistoryVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Alamofire

class BookingHistoryVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var lblOpenTour: UILabel!
    @IBOutlet weak var lblCloseTour: UILabel!
     
    @IBOutlet weak var tblTour: UITableView!
    @IBOutlet weak var viewPayment: UIView!

    //MARK: - Variable
    var marrMyTourModel : MyTourModel!
    var marrMyTourModelList = [MyTourModelList]()
    var viewType = 1
    var orderIDSid  = ""
    var marrOrderDetailModel : OrderDetailModel!
    var marrOrderDetails : OrderDetails!
    var strGuideName = ""
    var strTouristName = ""
    var strGuideNumber = ""
    var strGuideId = ""

    var strTouristNumber = ""
    var strLocation = ""
    var strTime = ""
    var strOrderNumber = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        print("BKKHH")
        print(strCheck)
        tblTour.register(UINib(nibName: "BookingHistoryTableCell", bundle: nil), forCellReuseIdentifier: "BookingHistoryTableCell")
        lblOpenTour.textColor = white
        lblCloseTour.textColor = black
        callDetailAPI()
        
        if(UserDefaults.standard.string(forKey: KU_USERID) ?? "" == ""){
            viewPayment.isHidden = true
        }
        else{
            viewPayment.isHidden = false
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
        statusBar.backgroundColor = colorAccent
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    func setTheme(){
        viewMain.clipsToBounds = false
        viewMain.layer.cornerRadius = CGFloat(8)
        viewMain.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnOpenTour(_ sender: UIButton) {
        lblOpenTour.textColor = white
        lblCloseTour.textColor = black
        viewType = 1
        tblTour.reloadData()
    }
    
    @IBAction func btnCloseTour(_ sender: UIButton) {
        lblOpenTour.textColor = black
        lblCloseTour.textColor = white
        viewType = 2
        tblTour.reloadData()
    }
    
    @IBAction func btnPaymentHistory(_ sender: UIButton) {
        touristMainVC.hideMenu()
        let vc:PaymentVC = touristStoryBoard.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    let dateFormatter = DateFormatter()
//    let tempLocale = dateFormatter.locale // save locale temporarily
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    let date = dateFormatter.date(from: self.tripDate)!
//    dateFormatter.dateFormat = "MM-dd-yy"
//    dateFormatter.locale = tempLocale // reset the locale
//    self.tripDate = dateFormatter.string(from: date)
//    print("EXACT_DATE : \(self.tripDate)")
    
    
    func sosTouristAPI(OPTtosend:String) {
        IJProgressView.shared.showProgressView()
      
        var param: [String: AnyObject] = [:]
        let body = "Your Tour Booking ID: \(self.strOrderNumber) with \(self.strGuideName) on \(self.strTime) for \(self.strLocation) is confirmed.Your OTP is \(OPTtosend) for start tour confirmation"
       // "SOS message has sent"
        let to : String = self.strTouristNumber //"+919674843570"
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
    
        let auth = "Basic " + str

        //let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key" : KU_AUTHTOKEN]
/*
        APIhandler.SharedInstance.API_WithParameterss(aurl: baseUrl, parameter: param, completeBlock: { (responseObj) in
           
            print (responseObj)
            if(showLog){
                print("\(param)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
           
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
 
 */
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(username)/Messages"
        let parameters = ["From": "\(from)", "To": "\(to)", "Body": "\(body)"]
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .authenticate(username: username, password: password)
        .responseJSON { response in
            debugPrint(response)
        }

        
        
        
    }
    
    func sosGuideAPI() {
        IJProgressView.shared.showProgressView()
     
        var param: [String: AnyObject] = [:]
        let body = "Your Tour Booking ID: \(self.strOrderNumber) with \(self.strTouristName) on \(self.strTime) for \(self.strLocation) is confirmed."
        
       // "SOS message has sent"
        let to : String =   self.strGuideNumber
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

        let auth = "Basic " + str

        //let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key" : KU_AUTHTOKEN]

    /*    APIhandler.SharedInstance.API_WithParameterss(aurl: baseUrl, parameter: param, completeBlock: { (responseObj) in
           
            print (responseObj)
            if(showLog){
                print("\(param)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
           
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
     */
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(username)/Messages"
        let parameters = ["From": "\(from)", "To": "\(to)", "Body": "\(body)"]
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .authenticate(username: username, password: password)
        .responseJSON { response in
            debugPrint(response)
        }

    }
    
    func sosAdminAPI() {
        IJProgressView.shared.showProgressView()
       
        var param: [String: AnyObject] = [:]
        let body = "Tour Booking ID: \(self.strOrderNumber) by \(self.strTouristName) with \(self.strGuideName) on \(self.strTime) for \(self.strLocation) is confirmed."
                   
       // "SOS message has sent"
        let to : String =   "+18627559888"
        let from : String = "+19033205901"
        
        param["Body"] = body as AnyObject
        param["From"] = from as AnyObject
        param["To"] = to as AnyObject
        
        //print(param)
        let baseUrl : String = "https://api.twilio.com/2010-04-01/Accounts/AC0f0efb446e981a99200b769a4135d5cb/Messages.json"
        let username = "AC0f0efb446e981a99200b769a4135d5cb";
        let password = "b8860542756575a335f364b2c54f7838";
        let credentials = (username + ":" + password);
        let str = credentials.data(using: .utf8)?.base64EncodedString() ?? ""
        let auth = "Basic " + str

        //let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key" : KU_AUTHTOKEN]

        /*
        APIhandler.SharedInstance.API_WithParameterss(aurl: baseUrl, parameter: param, completeBlock: { (responseObj) in
           
            print (responseObj)
            if(showLog){
                print("\(param)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
           
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
         */
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(username)/Messages"
        let parameters = ["From": "\(from)", "To": "\(to)", "Body": "\(body)"]
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default
        )
        .authenticate(username: username, password: password)
        .responseJSON { response in
            debugPrint(response)
        }

    }
    func convhrstoampm(time:String)->String{
        
        let dateAsString = time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    func callSendPushOnPaymentTouristAPI(OPTtosend:String) {

        IJProgressView.shared.showProgressView()
        
        let message = "Your Tour Booking ID: \(self.strOrderNumber) with \(self.strGuideName) on \(convhrstoampm(time: self.strTime)) for \(self.strLocation) is confirmed.Your OTP is \(OPTtosend) for start tour confirmation"
        let dict = ["userId" : UserDefaults.standard.string(forKey: KU_USERID) ?? "",
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
    
    func callSendPushOnPaymentToGuideAPI() {

        IJProgressView.shared.showProgressView()
        let message =  "Your Tour Booking ID: \(self.strOrderNumber) with \(self.strTouristName) on \(convhrstoampm(time: self.strTime)) for \(self.strLocation) is confirmed."
        let dict = ["userId" : self.strGuideId,
                    "message" : message ]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendPushMsgFCM, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
        
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }

    
    func callDetailAPI1(){
        IJProgressView.shared.showProgressView()
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":orderIDSid]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_OrderDetail, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("order details are \(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrOrderDetailModel = OrderDetailModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if (self.marrOrderDetailModel.status.equalIgnoreCase("1")) {
               
                if (self.marrOrderDetailModel.details != nil) {
                    self.marrOrderDetails = self.marrOrderDetailModel.details!
                    self.strTouristName = self.marrOrderDetails.travellerfullName
                    self.strGuideName = self.marrOrderDetails.guidefullName
                    self.strTime = self.marrOrderDetails.defaultPackageStartTime
                    self.strLocation = self.marrOrderDetails.tripLocation
                    self.strTouristNumber = self.marrOrderDetails.travellerMobile
                    self.strGuideNumber = self.marrOrderDetails.guideMobile
                    self.strOrderNumber = self.marrOrderDetails.orderNumber
                    self.strGuideId = self.marrOrderDetails.guideId
                    //strCheck = "Yes"
                    if strCheck == "Yes" {
                        self.sosTouristAPI(OPTtosend: self.marrOrderDetails.startTourOTP)
                        self.callSendPushOnPaymentTouristAPI(OPTtosend:self.marrOrderDetails.startTourOTP)
                        self.sosGuideAPI()
                       // self.sosAdminAPI()
                        strCheck = ""
                    }
                }
            } else {
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrOrderDetailModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    //MARK: - Api Call
    func callDetailAPI() {
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_MyOrder, parameter: dict, completeBlock: { (responseObj) in
            if(showLog) {
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrMyTourModel = MyTourModel(apiResponce)
            
            if(self.marrMyTourModel.status.equalIgnoreCase("1")){
                if(self.marrMyTourModel.list != nil){
                    self.marrMyTourModelList = self.marrMyTourModel.list!
                    self.orderIDSid = self.marrMyTourModel.list?[0].orderId ?? ""
                    print(self.orderIDSid)
                    self.callDetailAPI1()
                }
            }
            else {
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrMyTourModel.error)
            }
            self.tblTour.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}

extension BookingHistoryVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrMyTourModelList.count > 0){
            return marrMyTourModelList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookingHistoryTableCell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableCell", for: indexPath) as! BookingHistoryTableCell
        let data = marrMyTourModelList[indexPath.row]
        
        let urlNew:String = (data.guidePic).replacingOccurrences(of: " ", with: "%20")
        cell.imgBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        
        cell.lblGuideName.text = data.guidefullName
        cell.lblServiceId.text = data.orderNumber
        
        cell.lblFromDate.text = ConstantFunction.sharedInstance.changeDateFormate15(aDate: data.guideStartDate)
        cell.lblFromTime.text = ConstantFunction.sharedInstance.changeDateFormate16(aDate: data.startTime)
        
        cell.lblOnDate.text = ConstantFunction.sharedInstance.changeDateFormate17(aDate: data.created)
        cell.lblOnTime.text = ConstantFunction.sharedInstance.changeDateFormate18(aDate: data.created)
        cell.lblAddress.text = data.tripLocation
        if(data.orderStatus == "New"){
            cell.viewNew.isHidden = true
        }
        else{
            cell.viewNew.isHidden = true
        }
        if(data.orderStatus == "Expired"){
            cell.viewNew.isHidden = false
            cell.lblStatus.text = data.orderStatus
        }
        
        cell.setBorder(isGuide: false)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        touristMainVC.hideMenu()
        let vc:BookingDetailVC = touristStoryBoard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        vc.orderId = marrMyTourModelList[indexPath.row].orderId
        if(viewType == 1){
            vc.isPendingOrder = true
        }
        else{
            vc.isPendingOrder = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = marrMyTourModelList[indexPath.row]

        if(viewType == 1){
            if(data.orderStatus == "Completed"){
                return 0
            }
            else{
                return 199
            }
        }
        else{
            if(data.orderStatus == "Completed"){
                return 199
            }
            else{
                return 0
            }
        }
    }
}
