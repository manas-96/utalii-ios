//
//  GuideBookingHistoryVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class GuideBookingHistoryVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblOpenTour: UILabel!
    @IBOutlet weak var lblCloseTour: UILabel!
    @IBOutlet weak var tblTour: UITableView!
    @IBOutlet weak var viewPayment: UIView!

    //MARK: - Variable
    var viewType = 1
    var marrMyTourModel : MyTourModel!
    var marrMyTourModelList = [MyTourModelList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
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
        
        guideMainVC.showVC()
        
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
        
        guideMainVC.hideVC()
        let vc:PaymentHistoryVC = guideStoryBoard.instantiateViewController(withIdentifier: "PaymentHistoryVC") as! PaymentHistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }  
         
    //MARK: - Api Call
    func callDetailAPI() {
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_MyOrderList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrMyTourModel = MyTourModel(apiResponce)
            
            if(self.marrMyTourModel.status.equalIgnoreCase("1")) {
                if(self.marrMyTourModel.list != nil) {
                    self.marrMyTourModelList = self.marrMyTourModel.list!
                }
            } else {
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrMyTourModel.error)
            }
            self.tblTour.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }     
}

extension GuideBookingHistoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrMyTourModelList.count > 0) {
            return marrMyTourModelList.count
        } else {
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
        /*
        if(data.orderStatus == "New") {
            cell.viewNew.isHidden = false
        } else {
            cell.viewNew.isHidden = true
          
        }
         */
        if(data.orderStatus == "Expired"){
            cell.viewNew.backgroundColor = UIColor.systemRed
        }
        else{
            cell.viewNew.backgroundColor = UIColor.init(named: "colorGreen")

        }
        cell.setBorder(isGuide: true)
        cell.lblStatus.text = data.orderStatus      
        cell.viewNew.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guideMainVC.hideVC()
        if(viewType == 2) {
            let vc:GuideOpenTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "GuideOpenTourVC") as! GuideOpenTourVC
            vc.orderId = marrMyTourModelList[indexPath.row].orderId
            vc.isComplited = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc:GuideOpenTourVC = guideStoryBoard.instantiateViewController(withIdentifier: "GuideOpenTourVC") as! GuideOpenTourVC
            vc.orderId = marrMyTourModelList[indexPath.row].orderId
            vc.isComplited = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = marrMyTourModelList[indexPath.row]
        if(viewType == 1) {
            if(data.orderStatus == "Completed"||data.orderStatus == "Expired") {
                return 0
            } else {
                return 199
            }
        } else {
            if(data.orderStatus == "Completed") {
                return 199
            } else if(data.orderStatus == "Expired"){
                return 199
            }
            else{
                return 0
            }
        }
    }
}

