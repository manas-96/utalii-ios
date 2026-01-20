//
//  PaymentHistoryVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class PaymentHistoryVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var tblBooking: UITableView!
    @IBOutlet weak var viewMain: UIView!

    @IBOutlet weak var imgBack: UIImageView!
    
    //MARK: - Variable
    var marrMyTourModel : MyTourModel!
    var marrMyTourModelList = [MyTourModelList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        paymetList()
        tblBooking.register(UINib(nibName: "GuidePaymentHistoryTableCell", bundle: nil), forCellReuseIdentifier: "GuidePaymentHistoryTableCell")
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
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Api Call
    func paymetList(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","guideId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_MyOrderList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrMyTourModel = MyTourModel(apiResponce)
            
            if(self.marrMyTourModel.status.equalIgnoreCase("1")){
                if(self.marrMyTourModel.list != nil){
                    self.marrMyTourModelList = self.marrMyTourModel.list!
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrMyTourModel.error)
            }
            self.tblBooking.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension PaymentHistoryVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrMyTourModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GuidePaymentHistoryTableCell = tableView.dequeueReusableCell(withIdentifier: "GuidePaymentHistoryTableCell", for: indexPath) as! GuidePaymentHistoryTableCell

        let data = marrMyTourModelList[indexPath.row]
         
            cell.lblTitle.text = "Payment Successfull"
            cell.lblTitle.textColor = colorGreen
     
        cell.lblCustomerName.text = data.travellerfullName
        cell.lblPaidAmount.text = "$ \(data.paidAmount)"
        cell.lblPaymentMethod.text = "Stripe"
        cell.lblTransactionDate.text = ConstantFunction.sharedInstance.changeDateFormate8(aDate: data.paymentDate)
        
        return cell
    }
    
    
}
