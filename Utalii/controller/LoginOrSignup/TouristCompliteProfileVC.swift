//
//  TouristCompliteProfileVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

import GoogleMaps

import GooglePlaces

class TouristCompliteProfileVC:UIViewController,UIImagePickerControllerDelegate,GMSMapViewDelegate{
    
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
    var userID = ""
    var email = ""
    var imagePicker: ImagePicker!
    var countryCode : String? = "1"
    var countryCode2 : String? = "1"
    
    var countryShortName : String? = "US"
    var countryShortName2 : String? = "US"

    var countriesViewController = CountriesViewController()
    
    var isEmergencyNo = false
    
    var marrLoginModel : LoginModel!
    var vcName = ""

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        txtEmail.text = email
        txtEmail.isUserInteractionEnabled = false
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
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true

        guard let windowScene = view.window?.windowScene,
              let statusBarFrame = windowScene.statusBarManager?.statusBarFrame
        else { return }

        let statusBar = UIView(frame: statusBarFrame)
        statusBar.backgroundColor = colorBlue
        view.window?.addSubview(statusBar)
    }

    
    //MARK :- Our Function
    func setTheme(){
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
        
        let countryShortName = "US"
      //  let countryCode = "1"
        let countryFlag = "🇺🇸"
        self.lblContactNo.text = "\(countryFlag) (\(countryShortName)) \(countryCode ?? "")"
        
        self.lblEnergencyNo.text = "\(countryFlag) (\(countryShortName)) \(countryCode ?? "")"
        
 
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
            countryCode2 = info.countryCode ?? ""
            self.countryShortName = info.countryShortName ?? ""
            self.lblContactNo.text = "\(info.countryFlag ?? "") (\(info.countryShortName ?? "")) \(info.countryCode ?? "")"
            self.lblEnergencyNo.text = "\(info.countryFlag ?? "") (\(info.countryShortName ?? "")) \(info.countryCode ?? "")"
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
//        if(ConstantFunction.sharedInstance.isEmpty(txt: txtFullName.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter fullname")
//        }
//        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtShortDesc.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter short description")
//        }
//        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtLocation.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter location")
//        }
//        else if(!ConstantFunction.sharedInstance.isEmailValid(email: txtEmail.text ?? "")){
//            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter email")
//        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtContactNo.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter contact number")
////        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtEmergencyNo.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter emergency contact number")
////        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtStreetAddress.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter street address")
////        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtCity.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter city")
////        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtState.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter state")
////        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtCountry.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter country")
////        }
////        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPostalCode.text ?? "")){
////            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter postcode")
////        }
//        else{
            if(viewType == "Guide"){
                callSaveDataAPI(type: 2)
            }
            else{
                callSaveDataAPI(type: 1)
            }
       // }
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
    func callSaveDataAPI(type: Int){
        IJProgressView.shared.showProgressView()
//        var mobileNo = "+\(countryCode ?? "")\(txtContactNo.text ?? "")"
//        var emergencyNo = "+\(countryCode2 ?? "")\(txtEmergencyNo.text ?? "")"
        
        print (txtContactNo.text ?? "")
        var mobile = txtContactNo.text ?? ""
        print(countryCode ?? "1")
        mobile =  (countryCode ?? "") + " " + (txtContactNo.text ?? "")

        print(mobile)
        
        print (txtEmergencyNo.text ?? "")
        var emergencyNo = txtEmergencyNo.text ?? ""
        //print(countryCode)
        emergencyNo =  (countryCode ?? "") + " " + (txtEmergencyNo.text ?? "")

        print(emergencyNo)
        
        
        let permanentAddress =
            "\(txtStreetAddress.text ?? "") " +
            "\(txtCity.text ?? "") " +
            "\(txtState.text ?? "") " +
            "\(txtCountry.text ?? "") " +
            "\(txtPostalCode.text ?? "")"

        let dict: [String: Any] = [
            "userId": userID,
            "fullName": txtFullName.text ?? "",
            "address": txtLocation.text ?? "",
            "latitude": latitude,
            "longitude": logitude,
            "countryNameCode": countryShortName ?? "",
            "mobile": mobile,
            "countryNameCodeEmg": countryShortName ?? "",
            "emergencyNumber": emergencyNo,
            "descriptions": txtShortDesc.text ?? "",
            "permanentAddress": permanentAddress,
            "city": txtCity.text ?? "",
            "state": txtState.text ?? "",
            "country": txtCountry.text ?? "",
            "pincode": txtPostalCode.text ?? ""
        ]

         print(dict)
        APIhandler.SharedInstance.Api_withImageAndParameters(aWebServiceName: API_UpdateProfile, aDictParam: dict,aImag: self.imgPhoto.image!,imgParameter: "profilePic", completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                newIsFrom = "TouristCompliteProfileVC"
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
}

extension TouristCompliteProfileVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, name: String) {
        if(image != nil){
            self.imgPhoto.image = nil
            self.imgPhoto.image = image
        }
    }
}

extension TouristCompliteProfileVC: GMSAutocompleteViewControllerDelegate {

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

extension TouristCompliteProfileVC: CountriesViewControllerDelegate {
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountries countries: [Country]) {
         
    }
    
    func countriesViewControllerDidCancel(_ countriesViewController: CountriesViewController) {
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didSelectCountry country: Country) {
        if let info = self.getCountryAndName(country.countryCode ?? "") {
            countryCode = info.countryCode ?? ""
            if(isEmergencyNo){
                self.countryCode2 = info.countryCode!
               // self.countryShortName = info.countryShortName ?? ""
                self.lblEnergencyNo.text = "\(info.countryFlag ?? "") (\(info.countryShortName ?? "")) \(info.countryCode ?? "")"
            }
            else{
                 
                self.countryShortName = info.countryShortName ?? ""
                self.lblContactNo.text = "\(info.countryFlag ?? "") (\(info.countryShortName ?? "")) \(info.countryCode ?? "")"
            }
        }
    }
    
    func countriesViewController(_ countriesViewController: CountriesViewController, didUnselectCountry country: Country) {
    }
}
