//
//  ViewController.swift
//  Utalii
//
//  Created by Mitul Talpara on 26/09/22.
//

import UIKit

class SplaceScreenVC: UIViewController {
    //MARK: - Outlet
    
    //MARK: - Variable
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
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
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = colorBlue
            window?.addSubview(statusBar)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = colorBlue
        }
    }
    
    //MARK :- Our Function
    func setTheme(){
       // UserDefaults.standard.set(false, forKey: KU_ISLOGIN)

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
     
    @objc func timerAction() {
        if(UserDefaults.standard.bool(forKey: KU_ISLOGIN)){
            if(UserDefaults.standard.string(forKey: KU_USERTYPE) == "1"){
                ConstantFunction.sharedInstance.touristHome()
            }
            else{
                ConstantFunction.sharedInstance.guideHome()
            }
        }
        else{
            ConstantFunction.sharedInstance.login()
        }
     }
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    
    //MARK: - Api Call
}

