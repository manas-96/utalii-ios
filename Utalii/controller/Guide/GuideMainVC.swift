//
//  GuideMainVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import CoreLocation
import SwiftyJSON

class GuideMainVC: UIViewController,CLLocationManagerDelegate{
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
    var addressForTracking = ""
    
    
    //MARK: - Variable
    var isShowMsg = false
    private var locationManager:CLLocationManager?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        viewUnReadMsg.isHidden = true
        //UserDefaults.standard.set("FIRST", forKey: "isFirstLogin")

        if(UserDefaults.standard.string(forKey: "isFirstLogin") == "FIRST"){
            print("Dont HaveDont Have ConnectStripe")
            UserDefaults.standard.synchronize()
            
            let vc = storyBoard.instantiateViewController(withIdentifier: "Guide_Update_navigation") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }else{
            
            print("Have ConnectStripe")

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
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorPrimaryDark
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK :- Our Function
    func setTheme(){
        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
        guideMainVC = self
        let vc : GuideHomeVC = (guideStoryBoard.instantiateViewController(withIdentifier: "GuideHomeVC") as! GuideHomeVC)
        setViewController(vc: vc)
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
    
    func showVC(){
        viewMain.isHidden = false
        viewMainHeight.constant = 60
        if(isShowMsg){
            viewUnReadMsg.isHidden = false
        }
        else{
            hideUnRead()
        }
    }
    
    func hideVC(){
        viewMain.isHidden = true
        viewMainHeight.constant = 0
        hideUnRead()
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnHome(_ sender: UIButton) {
        guideMainVC = self
        setBottomMenu(img: imgHome, txt: "Home", lbl: lblHome)
        let vc : GuideHomeVC = (guideStoryBoard.instantiateViewController(withIdentifier: "GuideHomeVC") as! GuideHomeVC)
        setViewController(vc: vc)
    }
    
    @IBAction func btnVideo(_ sender: UIButton) {
        guideMainVC = self
        setBottomMenu(img: imgTv, txt: "Videos", lbl: lblTv)
        let vc : ShortVideosVC = (guideStoryBoard.instantiateViewController(withIdentifier: "ShortVideosVC") as! ShortVideosVC)
        setViewController(vc: vc)
        
    }
    
    @IBAction func btnCalender(_ sender: UIButton) {
        guideMainVC = self
        setBottomMenu(img: imgCalander, txt: "History", lbl: lblCalander)
        let vc : GuideBookingHistoryVC = (guideStoryBoard.instantiateViewController(withIdentifier: "GuideBookingHistoryVC") as! GuideBookingHistoryVC)
        setViewController(vc: vc)
    }
    
    @IBAction func btnMessage(_ sender: UIButton) {
        guideMainVC = self
        setBottomMenu(img: imgMessage, txt: "Messages", lbl: lblMessage)
        let vc : GuideMessageVC = (guideStoryBoard.instantiateViewController(withIdentifier: "GuideMessageVC") as! GuideMessageVC)
        setViewController(vc: vc)
    }
    
    @IBAction func btnProfile(_ sender: UIButton) {
        guideMainVC = self
        setBottomMenu(img: imgProfile, txt: "Profile", lbl: lblProfile)
        let vc : GuideProfileVC = (guideStoryBoard.instantiateViewController(withIdentifier: "GuideProfileVC") as! GuideProfileVC)
        setViewController(vc: vc)
    }
    
    func getUserLocation(){
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
            
            print (UserDefaults.standard.bool(forKey: KU_ISGUIDESTARTTOUR))
            if(UserDefaults.standard.bool(forKey: KU_ISGUIDESTARTTOUR)){
                // ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "LOCATION CHANGE ::: Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
                
                weak var timer: Timer?
                
                // timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
                timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
                    // do something here
                    
                  //   self?.callChangeLocationAPI(latitude: "\(location.coordinate.latitude)", logitude: "\(location.coordinate.longitude)")
                    
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
                
            }
            
            print("LOCATION CHANGE ::: Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)")
        }
        
        
    }
    
    //MARK: - Api Call
    func callChangeLocationAPI(latitude: String,logitude: String){

        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","orderId":UserDefaults.standard.string(forKey: KU_GUIDEORDERID) ?? "","curLocation": self.addressForTracking,"lat":latitude,"lon":logitude]

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
