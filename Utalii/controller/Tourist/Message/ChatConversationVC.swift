//
//  ChatConversationVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 02/12/22.
//

import UIKit
import SwiftyJSON

class ChatConversationVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var chatHistoryTableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtMsg: UITextField!
    @IBOutlet weak var imgSend: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewMain: UIView!

    
    //MARK:- Variable
    var isLoading = true
    var name = ""
    
    var marrLoginModel : LoginModel!
 
    var profile = ""
    var userid = ""
    var username = ""
    var orderID = ""
    
    var marrChatConversationModel : ChatConversationModel!
    var marrChatList = [ChatList]()
    var isGuide = false
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        imgBack.changePngColorTo(color: white)
        imgProfile.sd_setImage(with: URL(string: profile), placeholderImage: UIImage(named: "loding.png"))
        lblTitle.text = username
       // callReadAllMSG()
      //  chatHistoryTableView.rowHeight = 70
        
        callChatConversationAPI(isShow: true)
        
        if(isGuide){
            viewMain.backgroundColor = colorBlue
        }
        else{
            viewMain.backgroundColor = colorAccent
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            if let viewControllers = window.rootViewController?.children {
                for viewController in viewControllers {
                    dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isLoading = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Our Function
    func  customize(){
        chatHistoryTableView.register(UINib(nibName: "ReciverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReciverTableViewCell")
        chatHistoryTableView.register(UINib(nibName: "SenderTextTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderTextTableViewCell")
        chatHistoryTableView.register(UINib(nibName: "ChatImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatImageTableViewCell")
        chatHistoryTableView.register(UINib(nibName: "ReciverDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "ReciverDocumentTableViewCell")
        chatHistoryTableView.register(UINib(nibName: "SenderDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderDocumentTableViewCell")
    }
    
    func callTimerApi(){
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.callChatConversationAPI(isShow: false)
        }
    }
    
    //MARK:- DataSource & Deleget
    @IBAction func txtMsg(_ sender: UITextField) {
        
    }
    
    
    //MARK:- Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func btnBlock(_ sender: UIButton) {
//        let alert = UIAlertController(title: "", message: "Are you sure you want to block this user?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
//            switch action.style{
//                case .default:
//                self.blockUser()
//
//                case .cancel:
//                    print("cancel")
//
//                case .destructive:
//                    print("destructive")
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    @IBAction func btnSend(_ sender: UIButton) {
        view.endEditing(true)
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtMsg.text ?? "")){
            
        }
        else{
            callSendMSG(txt: txtMsg.text ?? "")
        }
    }
    
    
    //MARK:- Api Call
//    func blockUser(){
//        IJProgressView.shared.showProgressView()
//        let dict = ["blocked_by_user_id":UserDefaults.standard.string(forKey: KU_USERID) ?? "","blocked_whom_user_id":userid]
//        APIhandler.SharedInstance.API_WithParameters(aurl: API_BlockAPI, parameter: dict, completeBlock: { (responds) in
//            let data = responds as? [String:Any]
//
//            if((data!["status"] as! String).equalIgnoreCase("1")){
//
//                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: data!["message"] as? String ?? "")
//                self.navigationController?.popViewController(animated: true)
//             }
//            else{
//                 IJProgressView.shared.hideProgressView()
//                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: data!["message"] as? String ?? "")
//            }
//        })
//        {
//            (error) in
//            IJProgressView.shared.hideProgressView()
//        }
//    }
    
    func callChatConversationAPI(isShow: Bool) {
        if(isShow){
            IJProgressView.shared.showProgressView()
        }
        let dict = ["senderId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","receiverId":userid,"orderId":orderID]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_ChatHistory, parameter: dict, completeBlock: { (responseObj) in
            print(responseObj)
            if(isShow){
                IJProgressView.shared.hideProgressView()
            }
            let apiResponce = JSON(responseObj)
            self.marrChatConversationModel = ChatConversationModel(apiResponce)
            if(self.marrChatConversationModel.status.equalIgnoreCase("1")){
                
                self.marrChatList = self.marrChatConversationModel.chatList!.reversed()
                if(self.isLoading){
                    self.callTimerApi()
                }
            }
            self.chatHistoryTableView.estimatedRowHeight = 50
            self.chatHistoryTableView.rowHeight = UITableView.automaticDimension
            self.chatHistoryTableView.reloadData()

        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
            
        }
    }
    
    func callSendMSG(txt: String)  {
        let dict = ["senderId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","receiverId":userid,"message":txt,"orderId":orderID]
        self.txtMsg.text = nil
        APIhandler.SharedInstance.API_WithParameters(aurl: API_SendMessage, parameter: dict, completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()

            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
            }
            else{
            }
            
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()

        }
    }
    
//    func callReadAllMSG()  {
//        let dict = ["sender_id":UserDefaults.standard.string(forKey: KU_USERID) ?? "","receiver_id":userid]
//        self.txtMsg.text = nil
//        APIhandler.SharedInstance.API_WithParameters(aurl: API_MaskReadChat, parameter: dict, completeBlock: { (responseObj) in
//            print(responseObj)
//            IJProgressView.shared.hideProgressView()
//
//            let apiResponce = JSON(responseObj)
//            self.marrLoginModel = LoginModel(apiResponce)
//
//            if(self.marrLoginModel.status.equalIgnoreCase("1")){
//            }
//            else{
//            }
//
//        }) { (errorObj) in
//            IJProgressView.shared.hideProgressView()
//
//        }
//    }
}
extension ChatConversationVC: UITableViewDelegate,UITableViewDataSource{
    //MARK:- DataSource & Deleget
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrChatList.count > 0){
            return marrChatList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = marrChatList[indexPath.row]
        
        if(UserDefaults.standard.string(forKey: KU_USERID)!.equalIgnoreCase(data.senderId) ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTextTableViewCell", for: indexPath) as! SenderTextTableViewCell
          
         //   cell.lbldisc.text = nil //nil ConstantFunction.sharedInstance.changeDateFormate6(aDate: data.created)
            cell.lblName.text = data.message

            cell.viewMain.backgroundColor = colorBluetr
             
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverTableViewCell", for: indexPath) as! ReciverTableViewCell
            
           // cell.lbldisc.text = nil//ConstantFunction.sharedInstance.changeDateFormate6(aDate: data.created)
            cell.lblName.text = data.message

            cell.viewMain.backgroundColor = colorLightYellow

            return cell
        }
    }
}


