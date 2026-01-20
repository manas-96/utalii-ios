//
//  TourRequestVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 14/12/22.
//

import UIKit
import SwiftyJSON

class TourRequestVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblTour: UITableView!
    @IBOutlet weak var imgBack: UIImageView!
    
    //MARK: - Variable
    var viewType = 1
    var marrMyTourModel : MyTourModel!
    var marrMyTourModelList = [MyTourModelList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tour Request called")
        setTheme()
        tblTour.register(UINib(nibName: "BookingHistoryTableCell", bundle: nil), forCellReuseIdentifier: "BookingHistoryTableCell")
        imgBack.changePngColorTo(color: white)
        setdelegates()
        callDetailAPI()
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
        viewMain.clipsToBounds = false
        viewMain.layer.cornerRadius = CGFloat(8)
        viewMain.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    //MARK: - Api Call
    func callDetailAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_ServiceRequestList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrMyTourModel = MyTourModel(apiResponce)
            
            if(self.marrMyTourModel.status.equalIgnoreCase("1")){
                if(self.marrMyTourModel.list != nil){
                    self.marrMyTourModelList = self.marrMyTourModel.list!
                    print("the fetch list is \(self.marrMyTourModelList) and count is \(self.marrMyTourModelList.count)")
                    
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrMyTourModel.error)
            }
            self.tblTour.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}

extension TourRequestVC: UITableViewDelegate,UITableViewDataSource{
    func setdelegates(){
        self.tblTour.delegate = self
        self.tblTour.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrMyTourModelList.count > 0){
            print("The mammamama table is \(marrMyTourModelList.count)")
            return marrMyTourModelList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BookingHistoryTableCell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableCell", for: indexPath) as! BookingHistoryTableCell
        let data = marrMyTourModelList[indexPath.row]
        
        let urlNew:String = (data.travellerPic).replacingOccurrences(of: " ", with: "%20")
        cell.imgBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        
        cell.lblGuideName.text = data.travellerfullName
        cell.lblServiceId.text = data.orderNumber
        
        cell.lblFromDate.text = ConstantFunction.sharedInstance.changeDateFormate15(aDate: data.guideStartDate)
        cell.lblFromTime.text = ConstantFunction.sharedInstance.changeDateFormate16(aDate: data.startTime)
        
        cell.lblOnDate.text = ConstantFunction.sharedInstance.changeDateFormate17(aDate: data.created)
        cell.lblOnTime.text = ConstantFunction.sharedInstance.changeDateFormate18(aDate: data.created)
        cell.lblAddress.text = data.tripLocation
       
        
        cell.lblStatus.text = data.orderStatus
        if(data.orderStatus == "New" || data.orderStatus == "Accepted"){
            cell.viewNew.isHidden = false
        }
        else{
            cell.viewNew.isHidden = true
        }
        cell.setBorder(isGuide: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guideMainVC.hideVC()
         
            let vc:GuideOpenTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "GuideOpenTourVC") as! GuideOpenTourVC
            vc.orderId = marrMyTourModelList[indexPath.row].orderId
            self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = marrMyTourModelList[indexPath.row]
        let startData = ConstantFunction.sharedInstance.convertStringToDate7(aDate: data.guideStartDate)
        
        let cuTime = ConstantFunction.sharedInstance.changeDateFormate10(date: Date())
        let aTime = ConstantFunction.sharedInstance.convertStringToDate77(aDate: data.guideStartTime)
        
        if((data.orderStatus == "New" || data.orderStatus == "Accepted") && Date() <= startData){
            return 199
        }
        else{
            return 0
        }
    }
     
}
