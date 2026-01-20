//
//  PostAReviewVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 28/11/22.
//

import UIKit
import Cosmos
import SwiftyJSON

class PostAReviewVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var imgGuide: UIImageView!
    @IBOutlet weak var lblGuideName: UILabel!
    @IBOutlet weak var lblKnowLanguage: UILabel!
    @IBOutlet weak var viewGuideRate: CosmosView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewUserReview: CosmosView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblOtherRatingHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblOtherRating: UITableView!
    @IBOutlet weak var txtReview: KMPlaceholderTextView! 
    @IBOutlet weak var imgBack: UIImageView!
    
    //MARK: - Variable
    var marrOrderDetails : OrderDetails!
    var marrGuideReviewListModel : GuideReviewListModel!
    var marrGuideReviewReviewList = [GuideReviewReviewList]()
    
    var arrOtherReviewModel : OtherReviewModel!
    var arrReviewList = [ReviewList]()
    var marrLoginModel : LoginModel!

    var rating = 0.0
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        callGetReview()
        viewUserReview.didTouchCosmos = didTouchCosmos
        self.tblOtherRatingHeight.constant = 10
        
        imgBack.changePngColorTo(color: white)
        tblOtherRating.register(UINib(nibName: "OtherUserReviewTableCell", bundle: nil), forCellReuseIdentifier: "OtherUserReviewTableCell")
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
        statusBar.backgroundColor = colorAccent
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    
    //MARK :- Our Function
    private func didTouchCosmos(_ rating: Double) {
        self.rating = rating
    }
    func setTheme(){
        imgBack.changePngColorTo(color: white)

        let urlNew:String = (marrOrderDetails.guidePic).replacingOccurrences(of: " ", with: "%20")
        imgGuide.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))
        lblGuideName.text = marrOrderDetails.guidefullName
        lblKnowLanguage.text = marrOrderDetails.languageKnown
        viewGuideRate.rating = Double(marrOrderDetails.avgRating) ?? 0.0
        
        let urlNew1:String = (marrOrderDetails.travellerPic).replacingOccurrences(of: " ", with: "%20")
        imgUser.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "loding.png"))
        lblUserName.text = marrOrderDetails.travellerfullName
    }
    
    //MARK: - DataSource & Deleget
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtReview.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter review")
        }
        else if(rating == 0.0){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select rating")
        }
        else{
            calPostReview()
        }
    }
    
    //MARK: - Api Call
    func callGetReview(){
        IJProgressView.shared.showProgressView()
        let dict = ["orderId":self.marrOrderDetails.guideId,"guideId":self.marrOrderDetails.guideId]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_ReviewList, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.arrOtherReviewModel = OtherReviewModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if(self.arrOtherReviewModel.status.equalIgnoreCase("1")){
                if(self.arrOtherReviewModel.reviewList != nil){
                    self.arrReviewList = self.arrOtherReviewModel.reviewList!
                    self.tblOtherRatingHeight.constant = CGFloat(self.arrReviewList.count * 154)
                }
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.arrOtherReviewModel.error)
            }
            self.tblOtherRating.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func calPostReview(){
        IJProgressView.shared.showProgressView()
        let dict = ["orderId":self.marrOrderDetails.orderId,"guideId":self.marrOrderDetails.guideId,"userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","rating":"\(rating)","comments":txtReview.text ?? ""]

        APIhandler.SharedInstance.API_WithParameters(aurl: API_AddReview, parameter: dict, completeBlock: { (responseObj) in
            if(showLog){
                print("\(dict)  -- \(responseObj)")
            }
            let apiResponce = JSON(responseObj)
            self.marrLoginModel = LoginModel(apiResponce)
            IJProgressView.shared.hideProgressView()
            if(self.marrLoginModel.status.equalIgnoreCase("1")){
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.txtReview.text = nil
                self.viewUserReview.rating = 0.0
                
            }
            else{
                IJProgressView.shared.hideProgressView()
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
            self.tblOtherRating.reloadData()
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
}
extension PostAReviewVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrReviewList.count > 0){
            return arrReviewList.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OtherUserReviewTableCell = tableView.dequeueReusableCell(withIdentifier: "OtherUserReviewTableCell", for: indexPath) as! OtherUserReviewTableCell
        let data = arrReviewList[indexPath.row]
        
        let urlNew:String = (data.profilePic).replacingOccurrences(of: " ", with: "%20")
        cell.imgUser.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(named: "loding.png"))

        cell.lblUsername.text = data.travellerfullName
        cell.viewRating.rating = Double(data.rating) ?? 0
        cell.lblReview.text = data.comments
        cell.lblDate.text = ConstantFunction.sharedInstance.changeDateFormate3(aDate: data.updated)
        
        return cell
    }
}
