//
//  AddNewTourVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 22/11/22.
//

import UIKit
import iOSDropDown
import DatePickerDialog
import SwiftyJSON

import GooglePlaces
import GoogleMaps


protocol ReloadDataDelegate: class {
    func didChange()
}


class AddNewTourVC: UIViewController,GMSMapViewDelegate{
    //MARK: - Outlet
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var imgAddPlace: UIImageView!
    @IBOutlet weak var btnAddPlace: UIButton!
    
     
    @IBOutlet weak var txtPackagePrice: UITextField!
    @IBOutlet weak var txtEstimetTime: DropDown!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtPackageDesc: UITextField!
    @IBOutlet weak var txtPackageName: UITextField!
    @IBOutlet weak var txtPlace: UITextField!

    @IBOutlet weak var tblImportantPlace: UITableView!
    @IBOutlet weak var tblImportPlaceHeight: NSLayoutConstraint!

    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var arrImportantplaces = [String]()

    var latitude = UserDefaults.standard.string(forKey: KU_LOGINLATITUDE) ?? ""
    var logitude = UserDefaults.standard.string(forKey: KU_LOGINLOGITUDE) ?? ""

    var isUpdate = false
    var marrLoginModel : LoginModel!
    var marrSpacialPackages : Packages!
    var isShow = false
    
    var delegate: ReloadDataDelegate?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        tblImportantPlace.register(UINib(nibName: "ImportantPlaceTableCell", bundle: nil), forCellReuseIdentifier: "ImportantPlaceTableCell")
        txtEstimetTime.optionArray = ["1", "2", "3","4","5","6","7","8","9","10"]
        txtEstimetTime.didSelect{(selectedText , index ,id) in
            self.txtEstimetTime.text = selectedText
        }
        txtLocation.text = UserDefaults.standard.string(forKey: KU_ADDRESS) ?? ""
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
        if(isShow){
            lblTitle.text = "SPECIAL PACKAGE DETAIL"
            txtPackagePrice.isUserInteractionEnabled = false
            txtEstimetTime.isUserInteractionEnabled = false
            txtStartTime.isUserInteractionEnabled = false
            txtLocation.isUserInteractionEnabled = false
            txtPackageDesc.isUserInteractionEnabled = false
            txtPackageName.isUserInteractionEnabled = false
            txtPlace.isUserInteractionEnabled = false
            
            txtPackagePrice.text = marrSpacialPackages.packagePrice
            txtEstimetTime.text = marrSpacialPackages.estimatedTime
            txtStartTime.text = marrSpacialPackages.startTime
            txtLocation.text = marrSpacialPackages.location
            txtPackageDesc.text = marrSpacialPackages.packageDescription
            txtPackageName.text = marrSpacialPackages.packageName
            
            arrImportantplaces = marrSpacialPackages.placesCovered.components(separatedBy: ",")
            tblImportPlaceHeight.constant = CGFloat(arrImportantplaces.count * 39)
            tblImportantPlace.reloadData()
            
            btnAdd.isHidden = true
            viewAdd.isHidden = true
            imgAddPlace.isHidden = true
            btnAddPlace.isHidden = true
        }
        else{
            if(isUpdate){
                lblTitle.text = "EDIT DETAILS"
                txtPackagePrice.text = marrSpacialPackages.packagePrice
                txtEstimetTime.text = marrSpacialPackages.estimatedTime
                txtStartTime.text = marrSpacialPackages.startTime
                txtLocation.text = marrSpacialPackages.location
                txtPackageDesc.text = marrSpacialPackages.packageDescription
                txtPackageName.text = marrSpacialPackages.packageName
                txtPlace.text = nil
                
                arrImportantplaces = marrSpacialPackages.placesCovered.components(separatedBy: ",")
                tblImportPlaceHeight.constant = CGFloat(arrImportantplaces.count * 39)
                tblImportantPlace.reloadData()
                btnAdd.setTitle("SAVE", for: .normal)
                
            }
            else{
                btnAdd.setTitle("SAVE", for: .normal)
                lblTitle.text = "ADD NEW TOUR & PACKAGE"
            }
        }
        imgBack.changePngColorTo(color: white)
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPlace(_ sender: UIButton) {
        if(!ConstantFunction.sharedInstance.isEmpty(txt: txtPlace.text ?? "")){
            arrImportantplaces.append(txtPlace.text ?? "")
            tblImportPlaceHeight.constant = CGFloat(arrImportantplaces.count * 39)
            txtPlace.text = nil
            tblImportantPlace.reloadData()
        }
    }
   
    @IBAction func btnSelectDate(_ sender: UIButton) {
        DatePickerDialog().show("Select time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                self.txtStartTime.text = formatter.string(from: dt)
            }
        }
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
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtEstimetTime.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select estimation time first")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPackageName.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter package name")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPackageDesc.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select a description for the above package")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPackageDesc.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select a description for the above package")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtStartTime.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select start time")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: txtPackagePrice.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter package price")
        }
        else if(arrImportantplaces.count == 0){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select at least one covered places")
        }
        else{
            if(isUpdate){
                callUpdateTourAPI()
            }
            else{
                callAddTourAPI()
            }
        }
    }
    
    @objc func btnRemove(_ sender: UIButton) {
        arrImportantplaces.remove(at: sender.tag)
        tblImportPlaceHeight.constant = CGFloat(arrImportantplaces.count * 39)
        txtPlace.text = nil
        tblImportantPlace.reloadData()
    }
    
    //MARK: - Api Call
    func callUpdateTourAPI(){
        IJProgressView.shared.showProgressView()
        let formatter = DateFormatter()
        print("time format \(txtStartTime.text)")

        let inputTime = txtStartTime.text!
        var convertedtime = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistency

        if let date = dateFormatter.date(from: inputTime) {
            dateFormatter.dateFormat = "HH:mm:ss"
            let twentyFourHourTime = dateFormatter.string(from: date)
            convertedtime = twentyFourHourTime
            print(twentyFourHourTime)
        } else {
            print("Invalid time format")
            convertedtime = "00:00:00"
        }

   
        let dict = ["package_id":marrSpacialPackages.packageId,"user_id":UserDefaults.standard.string(forKey: KU_USERID) ?? "","package_name":txtPackageName.text ?? "","package_description":txtPackageDesc.text ?? "","location":txtLocation.text ?? "","latitude":latitude,"longitude":logitude,"places_covered":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))","start_time":convertedtime,"estimated_time":txtEstimetTime.text ?? "","package_price":txtPackagePrice.text ?? "","package_type":"hour","currency":UserDefaults.standard.string(forKey: KU_CURRENCTTYPE) ?? "USD"] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_UpdatespecialPackage, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.delegate?.didChange()
                self.navigationController?.popViewController(animated: true)
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    
    }
    
    func callAddTourAPI(){
        
        let formatter = DateFormatter()
        print("time format \(txtStartTime.text)")

        let inputTime = txtStartTime.text!
        var convertedtime = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale to ensure consistency

        if let date = dateFormatter.date(from: inputTime) {
            dateFormatter.dateFormat = "HH:mm:ss"
            let twentyFourHourTime = dateFormatter.string(from: date)
            convertedtime = twentyFourHourTime
            print(twentyFourHourTime)
        } else {
            print("Invalid time format")
            convertedtime = "00:00:00"
	
        }
     
        IJProgressView.shared.showProgressView()
        let dict = ["user_id":UserDefaults.standard.string(forKey: KU_USERID) ?? "","package_name":txtPackageName.text ?? "","package_description":txtPackageDesc.text ?? "","location":txtLocation.text ?? "","latitude":latitude,"longitude":logitude,"places_covered":"\(arrImportantplaces.map{String($0)}.joined(separator: ","))","start_time":convertedtime,"estimated_time":txtEstimetTime.text ?? "","package_price":txtPackagePrice.text ?? "","package_type":"Day","currency":UserDefaults.standard.string(forKey: KU_CURRENCTTYPE) ?? "USD"] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_AddSpecialPackage, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.delegate?.didChange()
                self.navigationController?.popViewController(animated: true)
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
extension AddNewTourVC: UITableViewDelegate,UITableViewDataSource{
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
extension AddNewTourVC: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        print("Place name: \(String(describing: place.name))")
        print("Place address: \(place.formattedAddress ?? "")")
        self.txtLocation.text = "\(place.formattedAddress ?? place.name ?? "")"
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
