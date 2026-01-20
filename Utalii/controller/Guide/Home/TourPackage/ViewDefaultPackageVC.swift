//
//  ViewDefaultPackageVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 22/11/22.
//

import UIKit

class ViewDefaultPackageVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var imgBack: UIImageView!
    
    
    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblPackagePrice: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblCurrncyType: UILabel!
     
    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var marrPackages :Packages!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        lblPackageName.text = marrPackages.packageName
        let time = marrPackages.duration.components(separatedBy: "to")
        
        if(time.count == 0){
            lblStartTime.text = " "
            lblEndTime.text = " "
        }
        else if(time.count == 1){
            lblStartTime.text = time[0]
            lblEndTime.text = " "
        }
        else{
            lblStartTime.text = time[0]
            lblEndTime.text = time[1]
        }
        lblPackagePrice.text = marrPackages.packagePrice
        lblPackageType.text = marrPackages.packageType
        lblCurrncyType.text = marrPackages.currency
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
        imgBack.changePngColorTo(color: white)
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Api Call
}
