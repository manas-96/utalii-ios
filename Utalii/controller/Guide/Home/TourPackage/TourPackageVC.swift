//
//  TourPackageVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 22/11/22.
//

import UIKit
import SwiftyJSON

class TourPackageVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var collectionDefaultTour: UICollectionView!
    @IBOutlet weak var tblSpecialToure: UITableView!
     
    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var marrLoginModel : LoginModel!
    
    var marrDefaultPackageModel : DefaultPackageModel!
    var marrPackages = [Packages]()
    
    var marrSpacialPackage : DefaultPackageModel!
    var marrSpacialPackages = [Packages]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        self.collectionDefaultTour.register(UINib(nibName: "DefaultTourCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DefaultTourCollectionCell")
        
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
        navigationController?.navigationBar.isHidden = true
        let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
        statusBar.backgroundColor = colorBlue
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    func setTheme(){
        imgBack.changePngColorTo(color: white)
    }
    
    //MARK: - DataSource & Deleget
    
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNew(_ sender: UIButton) {
        let vc:AddNewTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "AddNewTourVC") as! AddNewTourVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnEdit(_ sender: UIButton) {
        let vc:AddNewTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "AddNewTourVC") as! AddNewTourVC
        vc.delegate = self
        vc.isUpdate = true
        vc.marrSpacialPackages = self.marrSpacialPackages[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnDelete(_ sender: UIButton) {
        deletePackage(id: self.marrSpacialPackages[sender.tag].packageId)
    }
    
    //MARK: - Api Call
    func deletePackage(id: String){
        IJProgressView.shared.showProgressView()
        let dict = ["package_id":id] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_DeleteSpcialPackage, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.callSpacialPackageAPI() 
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
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
                //ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrSpacialPackage.error)
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Server Unreachable")

            }
            self.collectionDefaultTour.reloadData()
        }) { (errorObj) in
            self.callSpacialPackageAPI()
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callSpacialPackageAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["user_id":UserDefaults.standard.string(forKey: KU_USERID) ?? "","tourStartTime":"10:00:00"]
        
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
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrDefaultPackageModel.error)
            }
            self.tblSpecialToure.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}

extension TourPackageVC:ReloadDataDelegate{
    func didChange() {
        callDefaultPackageAPI()
    }
}

extension TourPackageVC:UICollectionViewDelegate,UICollectionViewDataSource{
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
        let vc:ViewDefaultPackageVC = guideStoryBoard.instantiateViewController(withIdentifier: "ViewDefaultPackageVC") as! ViewDefaultPackageVC
        vc.marrPackages = self.marrPackages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
     
}

extension TourPackageVC:UITableViewDelegate,UITableViewDataSource{
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
        
        cell.lblTitle.text = data.packageName
        cell.lblCurrncy.text = data.currencySymbol
        cell.lblPrice.text = "\(data.packagePrice)/"
        cell.lblDayMonth.text = data.packageType
        
        cell.lblAddress.text = data.location
        cell.lblPlaceOfCover.text = data.placesCovered
        cell.lblEstimatedTime.text = data.estimatedTime
        
        
        let dateAsString = data.startTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = data.startTime//dateFormatter.string(from: date!)
       
//        let dateAsString = data.startTime
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm:ss"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // fixes nil if device time in 24 hour format
//        let date = dateFormatter.date(from: dateAsString)
//
//        dateFormatter.dateFormat = "hh:mm a"
//        let date24 = dateFormatter.string(from: date!)
        cell.lblStartTime.text = Date12
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(self.btnEdit), for: .touchUpInside)

        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc:AddNewTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "AddNewTourVC") as! AddNewTourVC
        vc.isShow = true
        vc.marrSpacialPackages = self.marrSpacialPackages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
