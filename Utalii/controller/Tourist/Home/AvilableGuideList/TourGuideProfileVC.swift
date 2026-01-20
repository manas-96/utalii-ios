//
//  TourGuideProfileVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 24/11/22.
//

import UIKit
import Cosmos
import SwiftyJSON

class TourGuideProfileVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblBenner: UIImageView!
    @IBOutlet weak var imgGuide: UIImageView!
    @IBOutlet weak var lblGuideName: UILabel!
    @IBOutlet weak var viewRate: CosmosView!
    
    @IBOutlet weak var lblComplitedToure: UILabel!
    @IBOutlet weak var lblGuideSince: UILabel!
    
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblAvilableFrom: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblImportantPlace: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblCurrntDate: UILabel!
    @IBOutlet weak var lblAboutus: UILabel!
    
    @IBOutlet weak var viewFeatureVideo: UIView!
    @IBOutlet weak var viewFeatureVideoHeight: NSLayoutConstraint! //200
    @IBOutlet weak var collectionVideo: UICollectionView!

    //MARK: - Variable
    let uDefault = UserDefaults.standard
    
    var marrGuideDetailModel : GuideDetailModel!
    var marrGuideDetails : GuideDetails!
    var marrVideos = [Videos]()
    
    var guideID = ""
    var startTime = ""
    var date = ""
    var location = ""
    var latitude = ""
    var logitude = ""
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        imgBack.changePngColorTo(color: white)
        lblAge.text = ConstantFunction.sharedInstance.changeDateFormate9(date: Date())
        imgLocation.changePngColorTo(color: colorBlue)
        callGuideDetail()
        self.viewFeatureVideo.isHidden = true
        self.viewFeatureVideoHeight.constant = 0
        
        self.collectionVideo.register(UINib(nibName: "ShortVideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ShortVideoCollectionCell")
        ConstantFunction.sharedInstance.setCollectionviewGuideProfileVideo(aCollectiionView: collectionVideo)

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
        statusBar.backgroundColor = colorPrimaryDark
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
    
    @IBAction func btnSelectTour(_ sender: UIButton) {
        let vc:SelectATourVC = touristStoryBoard.instantiateViewController(withIdentifier: "SelectATourVC") as! SelectATourVC
        vc.startTime = self.startTime
        vc.guideID = self.guideID
        vc.date = self.date
        vc.location = self.location
        vc.latitude = self.latitude
        vc.logitude = self.logitude
        vc.marrGuideDetails = self.marrGuideDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Api Call
    func callGuideDetail(){
        IJProgressView.shared.showProgressView()
        let dict = ["guideId":guideID]
        
        APIhandler.SharedInstance.API_WithParameters(aurl: API_GuideDetail, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            IJProgressView.shared.hideProgressView()
            let apiResponce = JSON(responseObj)
            
            self.marrGuideDetailModel = GuideDetailModel(apiResponce)

            if(self.marrGuideDetailModel.status.equalIgnoreCase("1")){
                if(self.marrGuideDetailModel.details != nil){
                    self.marrGuideDetails = self.marrGuideDetailModel.details!
                    if(self.marrGuideDetails.videos != nil){
                        self.marrVideos = self.marrGuideDetails.videos!
                        
                        if(self.marrVideos.count > 0){
                            self.viewFeatureVideo.isHidden = false
                            self.viewFeatureVideoHeight.constant = 233
                        }
                        else{
                            self.viewFeatureVideo.isHidden = true
                            self.viewFeatureVideoHeight.constant = 0
                        }
                    }
                    self.lblAddress.text = self.marrGuideDetails.address
                    self.lblGuideName.text = self.marrGuideDetails.fullName
                    self.viewRate.rating = Double(self.marrGuideDetails.avgRating) ?? 0.00
                    self.lblComplitedToure.text = self.marrGuideDetails.tripCompleted
                    self.lblGuideSince.text = self.marrGuideDetails.since
                    
                    self.lblRate.text = "\(self.marrGuideDetails.currencySymbol)\(self.marrGuideDetails.minimumCharge)"
                    self.lblAvilableFrom.text = ConstantFunction.sharedInstance.changeDateFormate11(aDate: self.marrGuideDetails.tourStartTime)
                    self.lblLanguage.text = self.marrGuideDetails.languageKnown
                    self.lblLocation.text = self.marrGuideDetails.address
                    self.lblImportantPlace.text = self.marrGuideDetails.placesKnown
                    
                    let date1 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate12(aDate: self.marrGuideDetails.dob), month: ConstantFunction.sharedInstance.changeDateFormate13(aDate: self.marrGuideDetails.dob), day: ConstantFunction.sharedInstance.changeDateFormate14(aDate: self.marrGuideDetails.dob), hour: 5, minute: 9).date!
                    
                    let date2 = DateComponents(calendar: .current, year: ConstantFunction.sharedInstance.changeDateFormate4(), month: ConstantFunction.sharedInstance.changeDateFormate5(), day: ConstantFunction.sharedInstance.changeDateFormate6(), hour: 5, minute: 9).date!

                    let years = date2.years(from: date1)
                    
                    self.lblAge.text = "\(years) Years"
                    self.lblAboutus.text = self.marrGuideDetails.descriptions
                    
                    let urlNew:String = (self.marrGuideDetails.coverpic ?? "").replacingOccurrences(of: " ", with: "%20")
                    let urlNew1:String = (self.marrGuideDetails.profilePic ?? "").replacingOccurrences(of: " ", with: "%20")

                    self.lblBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
                    self.imgGuide.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "loding.png"))
                }
                self.collectionVideo.reloadData()
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrGuideDetailModel.error)
            }
             
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    } 
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   } 
        return ""
    }
}
extension TourGuideProfileVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(marrVideos.count > 0){
            return marrVideos.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ShortVideoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortVideoCollectionCell", for: indexPath) as! ShortVideoCollectionCell

        let data = marrVideos[indexPath.row]
        let urlNew:String = (data.coverImg).replacingOccurrences(of: " ", with: "%20")
        cell.imgBenner.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        cell.lblTitle.text = data.title
        
        cell.imgDelete.isHidden = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc:VideoPlayerVC = guideStoryBoard.instantiateViewController(withIdentifier: "VideoPlayerVC") as! VideoPlayerVC
        vc.videoURL = marrVideos[indexPath.row].file
        vc.isTourist = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
