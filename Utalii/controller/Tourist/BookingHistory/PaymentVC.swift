//
//  PaymentVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit
import SwiftyJSON

class PaymentVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var tblBooking: UITableView!
    @IBOutlet weak var viewMain: UIView!

    @IBOutlet weak var imgBack: UIImageView!
    
    //MARK: - Variable
    var marrMyTransactionModel : MyTransactionModel!
    var marrMyTransactionList = [MyTransactionList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        tblBooking.register(UINib(nibName: "PaymentHistoryTableCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryTableCell")
        imgBack.changePngColorTo(color: white)
        paymetList()
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
    func paymetList(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_MyTransaction, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            self.marrMyTransactionModel = MyTransactionModel(apiResponce)
            
            if(self.marrMyTransactionModel.status.equalIgnoreCase("1")){
                if(self.marrMyTransactionModel.list != nil){
                    self.marrMyTransactionList = self.marrMyTransactionModel.list!
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrMyTransactionModel.error)
            }
            self.tblBooking.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension PaymentVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrMyTransactionList.count > 0){
            return marrMyTransactionList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentHistoryTableCell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryTableCell", for: indexPath) as! PaymentHistoryTableCell
        let data = marrMyTransactionList[indexPath.row]
        
        if(data.paymentStatus.equalIgnoreCase("succeeded")){
            cell.lblTitle.text = "Booking Successfull"
            cell.lblTitle.textColor = colorGreen
        }
        else{
            cell.lblTitle.text = "Booking Faill"
            cell.lblTitle.textColor = colorRed
        }
        
        cell.lblRecipientName.text = data.guidefullName
        cell.lblPaidAmount.text = "\(data.currencySymbol)\(data.paidAmount)"
        cell.lblAmountMethod.text = "Stripe"
        cell.lblTransactionDate.text = ConstantFunction.sharedInstance.changeDateFormate8(aDate: data.paymentDate)
        cell.lblTransactionID.text = data.txnId
        
        
        return cell
    }
}
