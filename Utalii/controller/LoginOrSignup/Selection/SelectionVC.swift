//
//  SelectionVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 08/10/22.
//

import UIKit
import SwiftyJSON

protocol changeDataDeleget: class {
    func didChangeData(selectedItem: [String],selectedID: [String],isIntrest: Bool)
}

class SelectionVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionSelectedItem: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblItem: UITableView!
    @IBOutlet weak var collectionSelectedItemHeight: NSLayoutConstraint!
    
    
    //MARK: - Variable
    var userID = ""
    var language = ""
    
    var isIntrest = true
    var delegate: changeDataDeleget?
    
    var arrSelectedItem = [String]()
    var arrSelectedItemID = [String]()
    
    var arrSelectedLanguage = [String]()
    var arrSelectedLanguageID = [String]()
     
    var marrInterestList = [InterestList]()
    var marrFliterInterestList = [InterestList]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        self.collectionSelectedItem.register(UINib(nibName: "SelectedItemCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectedItemCollectionCell")
        
        tblItem.register(UINib(nibName: "SelectionListTableCell", bundle: nil), forCellReuseIdentifier: "SelectionListTableCell")

        self.marrFliterInterestList = marrInterestList
        tblItem.reloadData()
        
        if(arrSelectedItem.count > 0){
            collectionSelectedItemHeight.constant = 42
        }
        else{
            collectionSelectedItemHeight.constant = 0
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        if #available(iOS 13, *){
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = background1
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
        else{
            UIApplication.shared.statusBarView?.backgroundColor = colorPrimaryDark
        }
        
        view.layer.cornerRadius = CGFloat(23)
        viewMain.layer.cornerRadius = CGFloat(23)
        if #available(iOS 11.0, *){
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            viewMain.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    //MARK :- Our Function
    func setTheme(){
        
    }
    
    //MARK: - DataSource & Deleget
    @IBAction func txtSearch(_ sender: UITextField) {
        IJProgressView.shared.showProgressView()
        let stext = sender.text!.lowercased()
        
        marrFliterInterestList.removeAll()
        
        if(stext.count == 0){
            marrFliterInterestList = marrInterestList
            tblItem.reloadData()
        }
        else{
            for x in 0..<marrInterestList.count{
                let data = marrInterestList[x]
                if(data.title.lowercased().contains(stext) ?? false){
                    marrFliterInterestList.append(data)
                }
                tblItem.reloadData()
            }
        }
        
        if(marrFliterInterestList.count == 0){
            let tblBGView = ConstantFunction.sharedInstance.getNoDataView(self.tblItem.frame, title: "OOPS! NO RESULTS", message: "", type: 0)
            self.tblItem.backgroundView = tblBGView
        }
        else{
            let tblBGView = ConstantFunction.sharedInstance.getNoDataView(self.tblItem.frame, title: "", message: "", type: 2)
            self.tblItem.backgroundView = tblBGView
            
        }
        
        IJProgressView.shared.hideProgressView()
    }
    
    
    //MARK: - Click Action
    @IBAction func btnClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveAndProceed(_ sender: UIButton) {
        delegate?.didChangeData(selectedItem: arrSelectedItem, selectedID: arrSelectedItemID, isIntrest: self.isIntrest)
        dismiss(animated: true)
    }
    
    
    @objc func btnRemove(_ sender: UIButton) {
        arrSelectedItem.remove(at: sender.tag)
        arrSelectedItemID.remove(at: sender.tag)
        collectionSelectedItem.reloadData()
    }
    
    
    //MARK: - Api Call
    
    
    
}

extension SelectionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(marrFliterInterestList.count > 0){
            return marrFliterInterestList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelectionListTableCell = tableView.dequeueReusableCell(withIdentifier: "SelectionListTableCell", for: indexPath) as! SelectionListTableCell

        let data = marrFliterInterestList[indexPath.row]
        
        cell.lblTitle.attributedText = data.title.attributedHtmlString
        
        cell.lblTitle.setMediumFontWithSize(size: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrSelectedItem.append(marrFliterInterestList[indexPath.row].title)
        arrSelectedItemID.append(marrFliterInterestList[indexPath.row].interestId)
        
        collectionSelectedItem.reloadData()
    }
}

extension SelectionVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(arrSelectedItem.count > 0){
            collectionSelectedItemHeight.constant = 42
            return arrSelectedItem.count
        }
        else{
            collectionSelectedItemHeight.constant = 0
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SelectedItemCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedItemCollectionCell", for: indexPath) as! SelectedItemCollectionCell

        cell.lblTitle.text = arrSelectedItem[indexPath.row]
        
        
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(self.btnRemove), for: .touchUpInside)
        
        return cell
        
    }
    
}
