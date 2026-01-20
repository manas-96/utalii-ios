//
//  AvilableGuideListVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 23/11/22.
//

import UIKit
import SwiftyJSON
import SDWebImage

class AvilableGuideListVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
 
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var tblGuideList: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    //MARK: - Variable
    var location = ""
    var latitude = ""
    var logitude = ""
    var startTime = ""
    var date = ""
    var language = ""
    
    var marrGuideListModel : GuideListModel!
    var marrGuideList = [GuideList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        imgCalender.changePngColorTo(color: colorPrimary)
        imgLocation.changePngColorTo(color: colorPrimary)
        lblLocation.text = location
        lblTime.text = startTime
        lblDate.text = date
        tblGuideList.register(UINib(nibName: "AvilableGuideListTableCell", bundle: nil), forCellReuseIdentifier: "AvilableGuideListTableCell")
        callAvilableGuidList()
        imgBack.changePngColorTo(color: white)
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
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Api Call
    func callAvilableGuidList(){
        IJProgressView.shared.showProgressView()
        let dict = ["latitude":latitude,"longitude":logitude,"fromDate":date,"language":language,"startTime":ConstantFunction.sharedInstance.changeDateFormate10(aDate: startTime)]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_GuideList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            
            self.marrGuideListModel = GuideListModel(apiResponce)

            if(self.marrGuideListModel.status.equalIgnoreCase("1")){
                if(self.marrGuideListModel.list?.count ?? 0 > 0){
                    self.marrGuideList = self.marrGuideListModel.list!
                }
                
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "No Guide found")
            }
            self.tblGuideList.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension AvilableGuideListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrGuideList.count > 0){
            return marrGuideList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AvilableGuideListTableCell = tableView.dequeueReusableCell(withIdentifier: "AvilableGuideListTableCell", for: indexPath) as! AvilableGuideListTableCell

        let data = marrGuideList[indexPath.row]
        
        let urlNew:String = (data.images).replacingOccurrences(of: " ", with: "%20")
        cell.imgGuide.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))

        cell.lblTitle.text = data.name
        cell.lblLocation.text = data.address
        cell.lblLanguage.text = data.languageKnown
        cell.lblAvilableFrom.text = ConstantFunction.sharedInstance.changeDateFormate11(aDate: data.tourStartTime)
        cell.viewRating.rating = Double(data.avgRating) ?? 0.0
      //  let formattedArray = data.interestList.joined(separator: ", ")
        var intrestList = ""
        for x in 0..<(data.interestList?.count ?? 0){
            let d = data.interestList?[x]
            if(x == 0){
                intrestList = "\(d?.title ?? "")"
            }
            else{
                intrestList = "\(intrestList),\(d?.title ?? "")"
            }
        }

        cell.lblIntrests.text = intrestList
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.string(forKey: "Guest") == "Guest" {
            UserDefaults.standard.removeObject(forKey: "Guest")

            let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.viewType = "Tourust"

            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc:TourGuideProfileVC = touristStoryBoard.instantiateViewController(withIdentifier: "TourGuideProfileVC") as! TourGuideProfileVC
            vc.guideID = self.marrGuideList[indexPath.row].userId
            vc.startTime = self.startTime
            vc.date = self.date
            vc.location = self.location
            vc.latitude = self.latitude
            vc.logitude = self.logitude
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
}
