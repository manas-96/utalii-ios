//
//  GuideNotificationVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON

class GuideNotificationVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgBack: UIImageView!

    //MARK: - Variable
    var marrNotificationListModel : NotificationListModel!
    var marrNotiList = [NotiList]()
    var marrLoginModel : LoginModel!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        callGetNotificationAPI()
        
        tblNotification.register(UINib(nibName: "NotificationTableCell", bundle: nil), forCellReuseIdentifier: "NotificationTableCell")
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

    }
     
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func btnDelete(_ sender: UIButton) {
        callDeleteNotification(id: marrNotiList[sender.tag].notiId,pos: sender.tag)
    }
    
    //MARK: - Api Call
    func callGetNotificationAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_NOTIFICATIONLIST, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            
            self.marrNotificationListModel = NotificationListModel(apiResponce)
            
            if(self.marrNotificationListModel.status.equalIgnoreCase("1")){
                if(self.marrNotificationListModel.notiList?.count ?? 0 > 0){
                    self.marrNotiList = self.marrNotificationListModel.notiList!
                    self.callMarkAsAAllRead()
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrNotificationListModel.error)
            }
            self.tblNotification.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callMarkAsAAllRead(){
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_MARKASALLREAD, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
 
             
        }) { (errorObj) in
        }
    }
    
    func callDeleteNotification(id: String,pos: Int){
        IJProgressView.shared.showProgressView()
        let dict = ["notiId":id,"userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""] as [String : Any]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_DELETENOTIFICATION, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
 
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                self.marrNotiList.remove(at: pos)
                self.tblNotification.reloadData()
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
extension GuideNotificationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrNotiList.count > 0){
            return marrNotiList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationTableCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableCell
        let data = marrNotiList[indexPath.row]
        
        cell.lblTitle.text = data.message
        cell.lblDate.text = ConstantFunction.sharedInstance.changeDateFormate23(aDate: data.created)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete), for: .touchUpInside)

        return cell
    }
}

