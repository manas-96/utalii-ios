 //
//  TouristMessageVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 30/09/22.
//

import UIKit
import SwiftyJSON

class TouristMessageVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    
    //MARK: - Variable
    var marrChatUserModel : ChatUserModel!
    var marrChatUserList = [ChatUserList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        tblMessage.register(UINib(nibName: "TouristMessageTableCell", bundle: nil), forCellReuseIdentifier: "TouristMessageTableCell")
        callGetUserList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        touristMainVC.showMenu()
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
    @objc func btnDetail(_ sender: UIButton) {
        touristMainVC.hideMenu()
        let vc:BookingDetailVC = touristStoryBoard.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        vc.orderId = marrChatUserList[sender.tag].orderInfo?.orderId ?? "0"
        vc.isPendingOrder = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnMsg(_ sender: UIButton) {
        touristMainVC.hideMenu()
        let vc : ChatConversationVC = (touristStoryBoard.instantiateViewController(withIdentifier: "ChatConversationVC") as! ChatConversationVC)
        vc.profile = self.marrChatUserList[sender.tag].pic
        vc.userid = self.marrChatUserList[sender.tag].userId
        vc.username = self.marrChatUserList[sender.tag].fullName
        vc.orderID = self.marrChatUserList[sender.tag].orderInfo?.orderId ?? "0"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Api Call
    func callGetUserList(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_ChatUserList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            
            self.marrChatUserModel = ChatUserModel(apiResponce)
            
            if(self.marrChatUserModel.status.equalIgnoreCase("1")){
                if(self.marrChatUserModel.list?.count ?? 0 > 0){
                    self.marrChatUserList = self.marrChatUserModel.list!
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrChatUserModel.error)
            }
            self.tblMessage.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension TouristMessageVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrChatUserList.count > 0){
            return marrChatUserList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TouristMessageTableCell = tableView.dequeueReusableCell(withIdentifier: "TouristMessageTableCell", for: indexPath) as! TouristMessageTableCell
        let data = marrChatUserList[indexPath.row]
        
        let urlNew:String = (data.pic).replacingOccurrences(of: " ", with: "%20")
        cell.imgUser.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        
        cell.lblUserName.text = data.fullName
        cell.lblServiceID.text = data.orderInfo?.orderNumber
        cell.lblLastMsg.text = data.lastMsg
        cell.lblDate.text = ConstantFunction.sharedInstance.changeDateFormate20(aDate: data.lastMsgDateTime)
        cell.lblTime.text = ConstantFunction.sharedInstance.changeDateFormate21(aDate: data.lastMsgDateTime)
        
        cell.btnDetail.tag = indexPath.row
        cell.btnDetail.addTarget(self, action: #selector(self.btnDetail), for: .touchUpInside)

        cell.btnMsg.tag = indexPath.row
        cell.btnMsg.addTarget(self, action: #selector(self.btnMsg), for: .touchUpInside)

        if(data.unreadMsgCount == 0){
            cell.viewUnRead.isHidden = true
            cell.lblUnReadCounter.text = "0"
        }
        else{
            cell.viewUnRead.isHidden = false
            cell.lblUnReadCounter.text = "\(data.unreadMsgCount ?? 0)"
        }
        
        return cell
    }
     
}
