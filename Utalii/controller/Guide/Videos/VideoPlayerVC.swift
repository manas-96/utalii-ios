//
//  VideoPlayerVC.swift
//  Utalii
//
//  Created by Mitul Talpara on 24/11/22.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerVC: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imgBack: UIImageView!

    //MARK: - Variable
    let uDefault = UserDefaults.standard
    var player : AVPlayer!
    var avpController = AVPlayerViewController()
    var videoURL = ""
    var isTourist = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        showVideo(videoLink: videoURL)
        imgBack.changePngColorTo(color: white)
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
        if(isTourist){
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = colorPrimaryDark
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
        else{
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = colorBlue
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
    }
    
    //MARK :- Our Function
    func setTheme(){
        
    }
    
    func showVideo(videoLink: String){
 
        let url = URL(string: videoLink)
        
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.view.frame.size.height = videoView.frame.size.height
        avpController.view.frame.size.width = videoView.frame.size.width
        self.videoView.addSubview(avpController.view)
        avpController.view.sizeToFit()
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: nil)
        
        player.play()
        
    }
    
    //MARK: - DataSource & Deleget
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Click Action
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Api Call
}
