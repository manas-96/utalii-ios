//
//  ShortVideosVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ShortVideosVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionVideo: UICollectionView!
    

    //MARK: - Variable
    var marrVideoListModel : VideoListModel!
    var marrVideoList = [VideoList]()
    var marrLoginModel : LoginModel!

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        self.collectionVideo.register(UINib(nibName: "ShortVideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ShortVideoCollectionCell")
        ConstantFunction.sharedInstance.setCollectionviewTouristVideo(aCollectiionView: collectionVideo)
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
        callVideoListAPI()
        viewMain.clipsToBounds = false
        viewMain.layer.cornerRadius = CGFloat(8)
        viewMain.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnPostVideo(_ sender: UIButton) {
        guideMainVC.hideVC()
        let vc:PostAVideoVC = guideStoryBoard.instantiateViewController(withIdentifier: "PostAVideoVC") as! PostAVideoVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
     
    @objc func btnDelete(_ sender: UIButton) {
        deleteVideo(id: self.marrVideoList[sender.tag].videoId, guideID: "")
    }
    
    
    //MARK: - Api Call
    func deleteVideo(id: String,guideID: String){
        
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "0","videoId":id] as [String : Any]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_DeleteVideo, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            self.marrLoginModel = nil
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.callVideoListAPI()
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func callVideoListAPI(){
        IJProgressView.shared.showProgressView()
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? ""]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_VideoList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrVideoListModel = VideoListModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if(self.marrVideoListModel.status.equalIgnoreCase("1")){
                if(self.marrVideoListModel.list != nil){
                    self.marrVideoList = self.marrVideoListModel.list!
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrVideoListModel.error)
            }
            self.collectionVideo.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension ShortVideosVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(marrVideoList.count > 0){
            return marrVideoList.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShortVideoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortVideoCollectionCell", for: indexPath) as! ShortVideoCollectionCell

        let data = marrVideoList[indexPath.row]
        let urlNew:String = (data.coverImg).replacingOccurrences(of: " ", with: "%20")
        cell.imgBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        cell.lblTitle.text = data.title
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete), for: .touchUpInside)

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guideMainVC.hideVC()
        let vc:VideoPlayerVC = guideStoryBoard.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoURL = marrVideoList[indexPath.row].video
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
