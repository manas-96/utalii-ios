//
//  PostAVideoVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 05/10/22.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import AVKit
import MobileCoreServices
import AVFoundation
import SwiftyJSON
import Photos

import GooglePlaces
import GoogleMaps


class PostAVideoVC: UIViewController, UINavigationControllerDelegate,GMSMapViewDelegate, ImagePickerDelegate{
    
    func didSelect(image: UIImage?, name: String) {
        if(image != nil){
            self.imgThumbnil.image = nil
           // self.imgPhoto.image = image
            self.imgThumbnil.image = image
            thumbnillSelected = true
            imgThumb = name
               
            
        }
    }
    
    //MARK:- Outlet
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnPickVideo: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    
    
    @IBOutlet weak var viewUpdateHeight: NSLayoutConstraint!
    @IBOutlet weak var viewUpdate: GradientView1!
    @IBOutlet weak var video: UIImageView!
    
    @IBOutlet weak var viewThumbnil: UIView!
    @IBOutlet weak var viewThumbnilHeight: NSLayoutConstraint!
    @IBOutlet weak var imgThumbnil: UIImageView!

    @IBOutlet weak var imgBack: UIImageView!
    

    //MARK:- Variable
    @objc func video(
      _ videoPath: String,
      didFinishSavingWithError error: Error?,
      contextInfo info: AnyObject
    ) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"

      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.cancel,
        handler: nil))
      present(alert, animated: true, completion: nil)
    }
    var aURL: URL?
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var isSelectImage = false
    var thumbnillSelected = false
    var imgThumbs : UIImage?
    var marrLoginModel : LoginModel!
    var imgThumb : String?

    var currentOrientation: AVCaptureVideoOrientation?
    var videoConnection: AVCaptureConnection?
    
    var isHome = false
    var imagePicker: ImagePicker!

    var latitude = UserDefaults.standard.string(forKey: KU_LOGINLATITUDE) ?? ""
    var logitude = UserDefaults.standard.string(forKey: KU_LOGINLOGITUDE) ?? ""
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        imgBack.changePngColorTo(color: white)
        viewVideoPlayer.isHidden = true
        viewUpdateHeight.constant = 0
        viewUpdate.isHidden = true
        viewThumbnil.isHidden = true
        viewThumbnilHeight.constant = 0
        
        txtLocation.text = UserDefaults.standard.string(forKey: KU_ADDRESS) ?? ""
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
    
    //MARK:- Our Function
    func setTheme(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        video.changePngColorTo(color: colorBlue)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            // Take the user to Settings app to possibly change permission.
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Finished opening URL
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alert.addAction(settingsAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- DataSource & Deleget
    @IBAction func txtLocation(_ sender: UITextField) {
        
    }
    //MARK:- Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func imgReplace(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select video", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take video", style: .default , handler:{ (UIAlertAction)in
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Photo library", style: .default , handler:{ (UIAlertAction)in
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .photoLibrary)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Camera roll", style: .default , handler:{ (UIAlertAction)in
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive , handler:{ (UIAlertAction)in
            
            
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
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
    
    
     
    @IBAction func btnCloseText(_ sender: UIButton) {
        txtLocation.text = nil
    }
    
    @IBAction func btnChoseThumbnil(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.openCamera()){
            self.imagePicker.present(from: sender)
        }
        else{
            self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
        }
    }
    
    @IBAction func btnUpload(_ sender: UIButton) {
        if(ConstantFunction.sharedInstance.isEmpty(txt: txtTitle.text ?? "")){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter location")
        }
        else if(ConstantFunction.sharedInstance.isEmpty(txt: latitude)){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please enter Video Title")
        }
        else if(aURL == nil){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please upload a video using camara or gallery")
        }
        else if(thumbnillSelected == false){
            ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: "Please select a video thumbnail image")
        }
        else{
            callPostaVideoAPI()
        }
    }
    
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    //MARK:- Api Call
    func callPostaVideoAPI(){
        IJProgressView.shared.showProgressView()
        let img = generateThumbnail(path: aURL!)
        
        let heightInPoints = img!.size.height
        let heightInPixels = heightInPoints * img!.scale

        let widthInPoints = img!.size.width
        let widthInPixels = widthInPoints * img!.scale
        
        let dict = ["userId":UserDefaults.standard.string(forKey: KU_USERID) ?? "","title":txtTitle.text!,"siteLocation":txtLocation.text ?? "","lat":latitude,"lon":logitude]
        let imageData = self.imgThumbnil.image?.pngData()

        APIhandler.SharedInstance.Api_withImageVideoAndParameters(aWebServiceName: API_ADDShortVideo,videoName: "file",video: aURL, aDictParam: dict,aImag: self.imgThumbnil.image!,imgParameter: "coverImg", completeBlock: { (responseObj) in
            print(responseObj)
            IJProgressView.shared.hideProgressView()
            
            let apiResponce = JSON(responseObj)
             self.marrLoginModel = LoginModel(apiResponce)
            
            if (self.marrLoginModel.status.equalIgnoreCase("1")) {
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.message)
                self.navigationController?.popViewController(animated: true)
             } else {
                ConstantFunction.sharedInstance.showAlert(aTitle: AppName, aMsg: self.marrLoginModel.error)
            }
        }) { (errorObj) in
            IJProgressView.shared.hideProgressView()
        }
    }
    
    func videoConvert(videoURL: URL)  {
        IJProgressView.shared.showProgressView()  
        let avAsset = AVURLAsset(url: videoURL as URL, options: nil)
        let startDate = NSDate()
        //Create Export session

        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)

        //Creating temp path to save the converted video
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4")?.absoluteString
        let url = NSURL(fileURLWithPath: myDocumentPath!)

        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let filePath = documentsDirectory2.appendingPathComponent("\(Int64(Date().timeIntervalSince1970 * 1000))\(UserDefaults.standard.string(forKey: KU_USERID)!)VideoConvert.mp4")
        

        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch let error {
                print(error)
                IJProgressView.shared.hideProgressView()
            }
        }
        //URL
        print(filePath!.absoluteString)
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession!.timeRange = range
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
                case .failed:
                    print("%@",exportSession!.error ?? "Failed to get error")
                IJProgressView.shared.hideProgressView()
                case .cancelled:
                    print("Export canceled")
                IJProgressView.shared.hideProgressView()
                case .completed:
                    //Video conversion finished
                    let endDate = NSDate()
                    let time = endDate.timeIntervalSince(startDate as Date)
                    print(time)
                    print("Successful!")
                let url =
                print(exportSession!.outputURL!)
                self.aURL = exportSession!.outputURL!
                IJProgressView.shared.hideProgressView()
                break
                default:
                IJProgressView.shared.hideProgressView()
                    break
            }
        })
    }
}
 

extension PostAVideoVC: UIImagePickerControllerDelegate {
   
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        dismiss(animated: true, completion: nil)
        
        aURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        videoConvert(videoURL: (info[UIImagePickerController.InfoKey.mediaURL] as? URL)!)
        
        isSelectImage = true
        
        if let videoData = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            player = AVPlayer(url: videoData)
            viewVideoPlayer.isHidden = false
            btnPickVideo.isHidden = true
            viewUpdate.isHidden = false
            
            viewThumbnil.isHidden = false
            viewThumbnilHeight.constant = 180
            viewUpdateHeight.constant = 41
        }
        avpController.player = player
        avpController.view.frame.size.height = viewVideoPlayer.frame.size.height
        avpController.view.frame.size.width = viewVideoPlayer.frame.size.width
        self.viewVideoPlayer.addSubview(avpController.view)
        
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            
                let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
                
        else {
            return
        }
        
        // Handle a movie capture
        UISaveVideoAtPathToSavedPhotosAlbum(
            url.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            nil)
    }
}



extension PostAVideoVC: GMSAutocompleteViewControllerDelegate {

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
