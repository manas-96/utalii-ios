//
//  SelectATourVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 24/11/22.
//

import UIKit
import SwiftyJSON
import Cosmos

class SelectATourVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var collectionDefaultTour: UICollectionView!
    @IBOutlet weak var tblSpecialToure: UITableView!
    @IBOutlet weak var tblSpecialTour: NSLayoutConstraint!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblAvilableFrom: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblGuideSpecial: UILabel!

    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var marrDefaultPackageModel : DefaultPackageModel!
    var marrPackages = [Packages]()
    
    var marrSpacialPackage : DefaultPackageModel!
    var marrSpacialPackages = [Packages]()
    
    var marrGuideDetails : GuideDetails!
    var marrLoginModel : LoginModel!
    
    var startTime = ""
    var date = ""
    
    var isSpacialSelected = false
    var selectedIndeex = -1
    var packageName = ""
    var packageID = ""
    var orderId = ""
    var guideID = ""
    var location = ""
    var latitude = ""
    var logitude = ""
    var selectedPackageCurrncy = ""
    var selectedPackagePrice = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        imgBack.changePngColorTo(color: white)
        self.collectionDefaultTour.register(UINib(nibName: "DefaultTourCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DefaultTourCollectionCell")
        imgLocation.changePngColorTo(color: colorPrimary)
        
        tblSpecialToure .register(UINib(nibName: "SpacialPackageTableCell", bundle: nil), forCellReuseIdentifier: "SpacialPackageTableCell")
        
        ConstantFunction.sharedInstance.setCollectionviewDefaultPackage(aCollectiionView: collectionDefaultTour)
        
        callDefaultPackageAPI()
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
        IJProgressView.shared.hideProgressView()
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorPrimaryDark
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    func setTheme(){
        let urlNew:String = (self.marrGuideDetails.profilePic).replacingOccurrences(of: " ", with: "%20")
         self.imgProfile.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        
        if(ConstantFunction.sharedInstance.isEmpty(txt: self.marrGuideDetails.avgRating)){
            self.viewRating.rating = 0.00
        }
        else{
            self.viewRating.rating = Double(self.marrGuideDetails.avgRating) ?? 0.00
        }
        self.lblUserName.text = self.marrGuideDetails.fullName
        self.lblLanguage.text = self.marrGuideDetails.languageKnown
        self.lblAvilableFrom.text = ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrGuideDetails.tourStartTime)
        self.lblAddress.text = self.marrGuideDetails.address
    }
  
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBook(_ sender: UIButton) {
        if((ConstantFunction.sharedInstance.isEmpty(txt: packageName))){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select package")
        }
        else{
            
                callAddOrderAPI()
        }
    }
    
    @IBAction func btnChangeDate(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Api Call
    func callAddOrderAPI(){
        IJProgressView.shared.showProgressView()
        
        let dateAsString = startTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dates = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm"
        let Date24 = dateFormatter.string(from: dates!)
       
        
        
        let dict = ["guideId":guideID,"userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","hireStartDate":date,"hireEndDate":date,"startTime":Date24,"tripLocation":location,"lat":latitude,"lon":logitude,"packageId":packageID,"type":packageName]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_AddOrder, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                self.orderId = self.marrLoginModel.orderId
                 
                self.callGenrateStripeTocken(orderId: self.orderId, packageType: self.packageName,total: self.selectedPackagePrice,currncy: self.selectedPackageCurrncy)
                
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callGenrateStripeTocken(orderId: String,packageType: String,total: String,currncy: String){
        IJProgressView.shared.hideProgressView()
        
        if(UserDefaults.standard.string(forKey: KU_USERID) ?? "" == "0000"){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Your booking has been confirmed")
            touristMainVC.viewHome()
        }
        else {
            let vc:PayNowVC = touristStoryBoard.instantiateViewController(withIdentifier: "PayNowVC") as! PayNowVC
            vc.weburl = "https://www.utaliiworld.com/stripe-payment?orderId=\(orderId)&packageType=\(packageType)&total=\(total)&currency=\(currncy)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func callDefaultPackageAPI(){
        IJProgressView.shared.showProgressView()
        APIhandler.SharedInstance.API_WithoutParameters(aurl: API_DefaultPackage, completeBlock: { (responseObj) in
            if(showLog){
                print("\(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrDefaultPackageModel = DefaultPackageModel(apiResponce)
            if(self.marrDefaultPackageModel.status.equalIgnoreCase("1")){
                if(self.marrDefaultPackageModel.packages != nil){
                    self.marrPackages = self.marrDefaultPackageModel.packages!
                    self.callSpacialPackageAPI()
                }
            }
            else{
                self.callSpacialPackageAPI()
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrDefaultPackageModel.error)
            }
            self.collectionDefaultTour.reloadData()
        }) { (errorObj) in
            self.callSpacialPackageAPI()
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callSpacialPackageAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["user_id":self.marrGuideDetails.userId,"tourStartTime":ConstantFunction.sharedInstance.changeDateFormate10(aDate: startTime)]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_SpecialPackage, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrSpacialPackage = DefaultPackageModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if(self.marrSpacialPackage.status.equalIgnoreCase("1")){
                if(self.marrSpacialPackage.packages != nil){
                    self.marrSpacialPackages = self.marrSpacialPackage.packages!
                    if(self.marrSpacialPackages.count > 0){
                        self.tblSpecialTour.constant = CGFloat(self.marrSpacialPackages.count * 145)
                    }
                    else{
                        self.tblSpecialTour.constant = 1
                    }
                }
                else{
                    self.tblSpecialTour.constant = 1
                }
            }
            else{
                self.lblGuideSpecial.isHidden = true
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Guide special package are not available")
            }
            self.tblSpecialToure.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension SelectATourVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(marrPackages.count > 0){
            return marrPackages.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DefaultTourCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultTourCollectionCell", for: indexPath) as! DefaultTourCollectionCell
        let data = marrPackages[indexPath.row]
        cell.viewMain.layer.borderWidth = 2
        cell.viewMain.layer.borderColor = background1.cgColor
        
        if(isSpacialSelected){
            if(selectedIndeex == indexPath.row){
                cell.viewMain.layer.borderWidth = 2
                cell.viewMain.layer.borderColor = colorBlue.cgColor
            }
            else{
                cell.viewMain.layer.borderWidth = 2
                cell.viewMain.layer.borderColor = background1.cgColor
            }
        }
        
        cell.lblTitle.text = data.packageName
        cell.lblSymbol.text = data.currencySymbol
        cell.lblPrice.text = "\(data.packagePrice)/"
        cell.lblDayorMonth.text = data.packageType
        
        cell.lblDEsc.attributedText = data.packageDescription.attributedHtmlString
        
        cell.lblDEsc.text = cell.lblDEsc.text?.stripOutHtml()
        cell.lblDEsc.setRegularFontWithSize(size: 13)
        cell.lblDEsc.textAlignment = .center
        cell.lblDEsc.textColor = white
        cell.lblTime.text = data.duration
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSpacialSelected = true
        selectedIndeex = indexPath.row
        collectionDefaultTour.reloadData()
        tblSpecialToure.reloadData()
        packageName = "default"
        selectedPackagePrice = "\(marrPackages[indexPath.row].packagePrice)"
        selectedPackageCurrncy = marrPackages[indexPath.row].currency
        packageID = "\(marrPackages[indexPath.row].packageId)"
    }
     
}

extension SelectATourVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrSpacialPackages.count > 0){
            return marrSpacialPackages.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpacialPackageTableCell", for: indexPath) as! SpacialPackageTableCell

        let data = marrSpacialPackages[indexPath.row]
        
        cell.viewMain.layer.borderWidth = 2
        cell.viewMain.layer.borderColor = background1.cgColor
        
        if(isSpacialSelected == false){
            if(selectedIndeex == indexPath.row){
                cell.viewMain.layer.borderWidth = 2
                cell.viewMain.layer.borderColor = colorBlue.cgColor
            }
            else{
                cell.viewMain.layer.borderWidth = 2
                cell.viewMain.layer.borderColor = background1.cgColor
            }
        }
        cell.lblTitle.text = data.packageName
        cell.lblCurrncy.text = data.currencySymbol
        cell.lblPrice.text = "\(data.packagePrice)/"
        cell.lblDayMonth.text = data.packageType
        
        cell.lblAddress.text = data.location
        cell.lblPlaceOfCover.text = data.placesCovered
        cell.lblEstimatedTime.text = data.estimatedTime
        print("The Time received is \(ConstantFunction.sharedInstance.changeDateFormate10(aDate: data.startTime))")
        cell.lblStartTime.text = ConstantFunction.sharedInstance.changeDateFormate100(aDate: data.startTime)
        
        cell.lblEdit.isHidden = true
        cell.btnDelete.isHidden = true
        cell.btnEdit.isHidden = true
        cell.imgDelete.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSpacialSelected = false
        selectedIndeex = indexPath.row
        tblSpecialToure.reloadData()
        collectionDefaultTour.reloadData()
        packageName = "special"
        selectedPackagePrice = "\(marrSpacialPackages[indexPath.row].packagePrice)"
        selectedPackageCurrncy = marrSpacialPackages[indexPath.row].currency
        packageID = "\(marrSpacialPackages[indexPath.row].packageId)"
    }
    
}
