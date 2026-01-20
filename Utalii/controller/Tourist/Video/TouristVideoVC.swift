//
//  TouristVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 29/09/22.
//

import UIKit
import GooglePlaces
import GoogleMaps

import SwiftyJSON
import SDWebImage

class TouristVideoVC: UIViewController,GMSMapViewDelegate{
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var collectionVideo: UICollectionView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var imgClose: UIImageView!
    
    //MARK: - Variable
    var latitude = UserDefaults.standard.string(forKey: KU_LOGINLATITUDE) ?? ""
    var logitude = UserDefaults.standard.string(forKey: KU_LOGINLOGITUDE) ?? ""
    
    var marrVideoListModel : VideoListModel!
    var marrVideoList = [VideoList]()

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        self.collectionVideo.register(UINib(nibName: "TouristVideoVCCollectionCell", bundle: nil), forCellWithReuseIdentifier: "TouristVideoVCCollectionCell")
        ConstantFunction.sharedInstance.setCollectionviewTouristVideo(aCollectiionView: collectionVideo)
        imgClose.changePngColorTo(color: colorBlue)
        txtLocation.text = UserDefaults.standard.string(forKey: KU_ADDRESS) ?? ""
        callNearByVideo()
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
    @IBAction func btnLocation(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.primaryTextColor = blackDark
        acController.secondaryTextColor = blackDark
        acController.tableCellBackgroundColor = white
        acController.tableCellSeparatorColor = black
        acController.primaryTextHighlightColor = black
        
        self.present(acController, animated: true, completion: nil)
    }
    
    @IBAction func btnRemoveAll(_ sender: UIView) {
        self.txtLocation.text = nil
        self.latitude = ""
        self.logitude = ""
        self.marrVideoList.removeAll()
        self.collectionVideo.reloadData()
    }
    
    //MARK: - Api Call
    func callNearByVideo(){
        self.marrVideoList.removeAll()
        self.collectionVideo.reloadData()
        IJProgressView.shared.showProgressView()
        let dict = ["lat":latitude,"lon":logitude,"radius":"50"]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_NearByVideo, parameter: dict, completeBlock: { (responseObj) in
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

extension TouristVideoVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(marrVideoList.count > 0){
            return marrVideoList.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TouristVideoVCCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TouristVideoVCCollectionCell", for: indexPath) as! TouristVideoVCCollectionCell
        
        let data = marrVideoList[indexPath.row]
        let urlNew:String = (data.coverImg).replacingOccurrences(of: " ", with: "%20")
        cell.imgBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))

        cell.lbl1.text = data.title
        cell.lbl2.text = data.siteLocation
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        touristMainVC.hideMenu()
        
        let vc:VideoPlayerVC = guideStoryBoard.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoURL = marrVideoList[indexPath.row].video
        vc.isTourist = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension TouristVideoVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(place.formattedAddress ?? "")")
        self.txtLocation.text = "\(place.formattedAddress ?? place.name ?? "")"
        print("Place attributions: \(String(describing: place.attributions))")
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                
                
                self.latitude = "\(place.coordinate.latitude)"
                self.logitude = "\(place.coordinate.longitude)"
                self.callNearByVideo()
                
                self.dismiss(animated: true)
                
            }
            
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}
