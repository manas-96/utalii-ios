//
//  SelectLoginTypeVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 27/09/22.
//

import UIKit

class SelectLoginTypeVC: UIViewController {
    //MARK: - Outlet
    
    //MARK: - Variable
    @IBOutlet weak var lblDeviceToken: UITextField!
    
    @IBOutlet weak var lblFcmToken: UITextField!
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
//        self.lblDeviceToken.text = "DeviceToeken = \(DeviceToken)"
//        self.lblFcmToken.text = "FCMTocken = \(FCMToken)"

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
    
    @IBAction func btnGuestPressed(_ sender: Any) {
        UserDefaults.standard.set("Guest", forKey: "Guest") //setObject
        ConstantFunction.sharedInstance.touristHome()
    }
    
    @IBAction func btnTourust(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "Guest")

        let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.viewType = "Tourust"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnGuide(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "Guest")

        let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.viewType = "Guide"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Api Call
}
