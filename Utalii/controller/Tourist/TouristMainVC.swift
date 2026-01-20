//
//  TouristHomeVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Alamofire
import Foundation

var newVCName = ""
var newIsFrom = ""

class TouristMainVC: UIViewController,CLLocationManagerDelegate {
  
    //MARK: - Outlet
    
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var imgTv: UIImageView!
    @IBOutlet weak var imgCalander: UIImageView!
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblTv: UILabel!
    @IBOutlet weak var lblCalander: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var containerMain: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewMainHeight: NSLayoutConstraint!
    @IBOutlet weak var viewUnReadMsg: UIView!
    @IBOutlet weak var lblUnReadMsg: UILabel!
    
    //MARK: - Variable
   
    var marrLoginModel : LoginModel!
    var marrGuideDashboardModel : GuideDashboardModel!
    var marrDetail : Detail!
    var marrInProgress : InProgress!
    var isShowMsg = false
    private var locationManager:CLLocationManager?
    weak var timer: Timer?
    var vcName = ""
    var addressForTracking = ""

    //MARK: - Lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
       // sosApi()
        //callGetNotificationAPI()
    }
    
    //MARK: - Api Call

    func callGetNotificationAPI() {
        IJProgressView.shared.showProgressView()
      //  let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        var param: [String: AnyObject] = [:]
        let body = "siddd"
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
    }
    
    
    
//    func sosApi() {
//            var param: [String: AnyObject] = [:]
//            let body = "siddd"
//            let to : String =   "+18627559888"
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
//            let HEADER_CONTENT_TYPE = ["Authorization" : auth, "x-api-key" : KU_AUTHTOKEN]
//
//            Alamofire.request(baseUrl, method : .post, parameters: param, encoding: JSONEncoding.default as ParameterEncoding, headers: HEADER_CONTENT_TYPE).responseJSON
//            { response in
//                print(response)
//            //    MBProgressHUD.hide(for: self.view, animated: true)
//                if(response.response?.statusCode == 201)
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
        statusBar.backgroundColor = colorPrimaryDark
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    func setTheme() {
//        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
//        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
        touristMainVC = self
        
        if newIsFrom == "TouristCompliteProfileVC" {
            if newVCName == "TouristVideoVC" {
                setBottomMenu(img: imgTv, txt: "Videos", lbl: lblTv)

                let vc : TouristVideoVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristVideoVC") as! TouristVideoVC)
                setViewController(vc: vc)

            } else if newVCName == "BookingHistoryVC" {
                setBottomMenu(img: imgCalander, txt: "History", lbl: lblCalander)

                let vc : BookingHistoryVC = (touristStoryBoard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC)
                setViewController(vc: vc)

                
            } else if newVCName == "TouristMessageVC" {
                setBottomMenu(img: imgMessage, txt: "Messages", lbl: lblMessage)

                let vc : TouristMessageVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristMessageVC") as! TouristMessageVC)
                setViewController(vc: vc)

                
            } else if newVCName == "TouristProfileVC" {
                setBottomMenu(img: imgProfile, txt: "Profile", lbl: lblProfile)

                let vc : TouristProfileVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristProfileVC") as! TouristProfileVC)
                setViewController(vc: vc)
            }
//            else if newVCName == "AvilableGuideListVC" {
//               // setBottomMenu(img: imgProfile, txt: "Profile", lbl: lblProfile)
//
//                let vc : AvilableGuideListVC = (touristStoryBoard.instantiateViewController(withIdentifier: "AvilableGuideListVC") as! AvilableGuideListVC)
//                setViewController(vc: vc)
//            }
            else {
                setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
                let vc : TouristHomeVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeVC") as! TouristHomeVC)
                setViewController(vc: vc)
            }
            
        } else {
            setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)

            let vc : TouristHomeVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeVC") as! TouristHomeVC)
            setViewController(vc: vc)
        }
//        let vc : TouristHomeVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeVC") as! TouristHomeVC)
//        setViewController(vc: vc)
    }
    
    func setViewController(vc : UIViewController){
        let navigationController = UINavigationController(rootViewController: vc)
        self.addChild(navigationController)
        navigationController.view.frame = containerMain.bounds
        containerMain.addSubview(navigationController.view)
    }
    
    func setBottomMenu(img: UIImageView,txt: String,lbl: UILabel){
        imgHome.changePngColorTo(color: blackDark)
        imgTv.changePngColorTo(color: blackDark)
        imgCalander.changePngColorTo(color: blackDark)
        imgMessage.changePngColorTo(color: blackDark)
        imgProfile.changePngColorTo(color: blackDark)
        
        lblHome.text = nil
        lblTv.text = nil
        lblCalander.text = nil
        lblMessage.text = nil
        lblProfile.text = nil
         
        img.changePngColorTo(color: colorAccent)
        lbl.text = txt
    }
    
    func showMenu() {
        viewMain.isHidden = false
        viewMainHeight.constant = 60
        if(isShowMsg) {
            viewUnReadMsg.isHidden = false
        }
        else{
            hideUnRead()
        }
    }
    
    func setUnread(number: String){
        lblUnReadMsg.text = number
        viewUnReadMsg.isHidden = false
        isShowMsg = true
    }
    
    func hideUnRead(){
        viewUnReadMsg.isHidden = true
        isShowMsg = false
    }
    
    func hideMenu(){
        viewMain.isHidden = true
        viewMainHeight.constant = 0
    }
    
    func viewBooking(){
        touristMainVC = self
        setBottomMenu(img: imgCalander, txt: "History", lbl: lblCalander)
        let vc : BookingHistoryVC = (touristStoryBoard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC)
        setViewController(vc: vc)
    }
    
    func viewHome(){
        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
        let vc : TouristHomeVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeVC") as! TouristHomeVC)
        setViewController(vc: vc)
    }
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnHome(_ sender: UIButton) {
        touristMainVC = self
        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
        let vc : TouristHomeVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeVC") as! TouristHomeVC)
        setViewController(vc: vc)
    }
    
    @IBAction func btnVideo(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.viewType = "Tourust"
            newVCName = "TouristVideoVC"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            touristMainVC = self
            setBottomMenu(img: imgTv, txt: "Videos", lbl: lblTv)
            let vc : TouristVideoVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristVideoVC") as! TouristVideoVC)
            setViewController(vc: vc)
        }
    }
    
    @IBAction func btnCalender(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            UserDefaults.standard.removeObject(forKey: "Guest")

            let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.viewType = "Tourust"
            newVCName = "BookingHistoryVC"

            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            touristMainVC = self
            setBottomMenu(img: imgCalander, txt: "History", lbl: lblCalander)
            let vc : BookingHistoryVC = (touristStoryBoard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC)
            setViewController(vc: vc)
        }
    }
    
    @IBAction func btnMessage(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            UserDefaults.standard.removeObject(forKey: "Guest")

            let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.viewType = "Tourust"
            newVCName = "TouristMessageVC"

            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            touristMainVC = self
            setBottomMenu(img: imgMessage, txt: "Messages", lbl: lblMessage)
            let vc : TouristMessageVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristMessageVC") as! TouristMessageVC)
            setViewController(vc: vc)
        }
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            UserDefaults.standard.removeObject(forKey: "Guest")

            let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.viewType = "Tourust"
            newVCName = "TouristProfileVC"

            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            touristMainVC = self
            setBottomMenu(img: imgProfile, txt: "Profile", lbl: lblProfile)
            let vc : TouristProfileVC = (touristStoryBoard.instantiateViewController(withIdentifier: "TouristProfileVC") as! TouristProfileVC)
            setViewController(vc: vc)
        }
    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    func getAddressFromLatLong(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                // Construct the address using placemark properties
                let address = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            UserDefaults.standard.removeObject(forKey: "Lets")
            UserDefaults.standard.removeObject(forKey: "Longs")

            
            print (UserDefaults.standard.bool(forKey: KU_TURISTORDERID))
            
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "Lets") //setObject
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "Longs") //setObject

            
            if(UserDefaults.standard.bool(forKey: KU_TURISTORDERID)) {
                // ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "LOCATION CHANGE ::: Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
                
                
                
                weak var timer: Timer?
                
                   // timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
                    timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                        // do something here
                        
                        self?.getAddressFromLatLong(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { address in
                            if let address = address {
                                self?.addressForTracking = address
                                print("Address: \(address)")
                                // Do something with the address
                            } else {
                                print("Unable to get address.")
                            }
                        }
                        
                        self?.callChangeLocationAPI(latitude: "\(location.coordinate.latitude)", logitude: "\(location.coordinate.longitude)")
                    }
                    
                    //                var updateTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self,
                    //                selector: #selector(callChangeLocationAPI(latitude: "\(location.coordinate.latitude)", logitude: "\(location.coordinate.longitude)")) , userInfo: nil, repeats: true)
                    
                    
                    // callChangeLocationAPI(latitude: "\(location.coordinate.latitude)", logitude: "\(location.coordinate.longitude)")
                    
                    UserDefaults.standard.set("\(location.coordinate.latitude)", forKey: "A")
                    UserDefaults.standard.set("\(location.coordinate.longitude)", forKey: "B")
                }
                
                print("LOCATION CHANGE ::: Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
            }
        }
   
    // sid
    //MARK: - Api Call
   func callChangeLocationAPI(latitude: String,logitude: String){
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":UserDefaults.standard.string(forKey: KU_ISTURISTSTARTTOUR) ?? "","curLocation":addressForTracking,"lat":latitude,"lon":logitude]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_AddEditLocation, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            
            print(JSON(responseObj))
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
