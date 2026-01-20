//
//  ConstantFunction.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 07/05/22.
//
import Foundation
import UIKit
import Alamofire
import SystemConfiguration
import AVKit
import PopMenu
import SwiftMessages

class ConstantFunction {
    class var sharedInstance: ConstantFunction{
        let SharedInstance: ConstantFunction = {
            ConstantFunction()
        }()
        return SharedInstance
    }
    
    func getNoDataView(_ viewFrame: CGRect, title: String, message: String,type: Int) -> UIView {
        let bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewFrame.size.width, height: viewFrame.size.height))
        
        if(type == 1){
            let imgView = UIImageView.init(image: UIImage(named: "no_data"))
            imgView.frame = CGRect(x: bgView.center.x-70, y: bgView.center.y-100, width: 140, height: 100)
            imgView.contentMode = .scaleAspectFit
            bgView.addSubview(imgView)
        }
        
        let lblTitle = UILabel.init(frame: CGRect(x: 8, y: bgView.center.y+8, width: viewFrame.size.width-16, height: 21))
        lblTitle.text = title
        lblTitle.font = UIFont(name: Medium, size: 15.0)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.black
        bgView.addSubview(lblTitle)
        
        let lblMessage = UILabel.init(frame: CGRect(x: 8, y: (lblTitle.frame.origin.y+lblTitle.frame.size.height), width: viewFrame.size.width-16, height: 21))
        lblMessage.text = message
        lblMessage.font = UIFont(name: Medium, size: 13.0)
        lblMessage.textAlignment = .center
        lblMessage.textColor = UIColor.darkGray
        bgView.addSubview(lblMessage)
        
        return bgView
    }
     
    func getNoDataView1(_ viewFrame: CGRect, title: String, message: String,type: Int) -> UIView {
        let bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewFrame.size.width, height: viewFrame.size.height))
        
        if(type == 1){
            let imgView = UIImageView.init(image: UIImage(named: "no_data"))
            imgView.frame = CGRect(x: bgView.center.x, y: bgView.center.y, width: 140, height: 100)
            imgView.contentMode = .scaleAspectFit
            bgView.addSubview(imgView)
        }
        
        let lblTitle = UILabel.init(frame: CGRect(x: -20, y: bgView.center.y, width: viewFrame.size.width, height: 21))
        lblTitle.text = title
        lblTitle.font = UIFont(name: Medium, size: 15.0)
    
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.black
        bgView.addSubview(lblTitle)
        
        let lblMessage = UILabel.init(frame: CGRect(x: 0, y: (lblTitle.frame.origin.y+lblTitle.frame.size.height), width: viewFrame.size.width-16, height: 21))
        lblMessage.text = message
        lblMessage.font = UIFont(name: Medium, size: 13.0)
        lblMessage.textAlignment = .center
        lblMessage.textColor = UIColor.darkGray
        bgView.addSubview(lblMessage)
        
        return bgView
    }
    
    func buttonTintColor(aButton: UIButton,aColor: UIColor,aimageName : String){
        let image = UIImage(named: aimageName)?.withRenderingMode(.alwaysTemplate)
        aButton.setImage(image, for: .normal)
        aButton.tintColor = aColor
    }
    func tableViewCellAnimation(aCell: UITableViewCell){
        aCell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            aCell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                aCell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
        
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //TODO:- Show Camra Permition
    func openCamera() -> Bool{
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
        case .notDetermined:
             return true
        case .restricted:
            showAlert(aTitle: "Unable to access the Camera", aMsg: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
            return false
        case .denied:
            showAlert(aTitle: "Unable to access the Camera", aMsg: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.")
            return false
            
        case .authorized:
            return true
        }
    }
     
    //MARK:- Alert
    func showAlert(aTitle : String,aMsg : String){
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: "", body: aMsg, iconText: "")
        
        view.button?.isHidden = true
        
        SwiftMessages.show( view: view)
    }
    
    func showBottomAlert(aTitle : String,aMsg : String){
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: "", body: aMsg, iconText: "")
        
        view.button?.isHidden = true
        
        SwiftMessages.show( view: view)
    }
    
    //MARK:- POPMENU
    func setDropdown(actions : [PopMenuDefaultAction], aView : UIViewController){
           
           actions.forEach({
               $0.imageRenderingMode = .alwaysOriginal
           })
           
           let manager = PopMenuManager.default
           manager.actions = actions
           // manager.popMenuAppearance.popMenuFont = UIFont(name: RobotoMedium, size: 16)!
           manager.popMenuAppearance.popMenuColor.backgroundColor = .solid(fill: UIColor.white)
           manager.popMenuAppearance.popMenuCornerRadius = 5
           
       }
    
    //MARK:- setUserdefaultvalue
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
         return value
        }
    }
    
    
    //TODO:- Date To String
    func changeDateFormate1() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        
        return dateFormatterGet.string(from: Date())
    }
 
    func changeDateFormate111() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        return dateFormatterGet.string(from: Date())
    }
    
    func changeDateFormate112() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm:ss"
        
        return dateFormatterGet.string(from: Date())
    }
    func changeDateFormateaam() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "h:mm a"
        
        return dateFormatterGet.string(from: Date())
    }
    func changeDateFormate2() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        
        return dateFormatterGet.string(from: Date())
    }
    
    func changeDateFormate3() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        
        return dateFormatterGet.string(from: Date())
    }
    
    func changeDateFormate4() -> Int{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy"
        
        return Int(dateFormatterGet.string(from: Date())) ?? 2022
    }
    
    func changeDateFormate5() -> Int{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM"
        
        return Int(dateFormatterGet.string(from: Date())) ?? 2022
    }
    
    func changeDateFormate6() -> Int{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd"
        
        return Int(dateFormatterGet.string(from: Date())) ?? 2022
    }
    
    func changeDateFormate15(date: Date) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MMM-yyyy"
        
        return dateFormatterGet.string(from: date)
    }
    
    func changeDateFormate7(date: Date) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "hh:mm a"
        
        return dateFormatterGet.string(from: date)
    }
    
    func changeDateFormate8(date: Date) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        return dateFormatterGet.string(from: date)
    }
    
    func changeDateFormate9(date: Date) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        
        return dateFormatterGet.string(from: date)
    }
    
    
    func changeDateFormate10(date: Date) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "hh:mm a"
        
        return dateFormatterGet.string(from: date)
    }
    
    func convertStringToDate7(aDate: String) -> Date{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return Date()
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: aDate)!
        }
    }
  
    func convertStringToDate77(aDate: String) -> Date{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return Date()
        }else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.date(from: aDate)!
        }
    }
    
    //TODO:- String To String 
    func changeDateFormate2(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-05-19
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "E, dd MMM,YYYY"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate3(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd MMM YYYY"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
      
    func changeDateFormate4(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "hh:mm a"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate5(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd MMMM YYYY"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate6(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "E, dd MMM,YYYY hh:mm a"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate8(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd-MM-YYYY hh:mm a"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate9(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY" 
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "yyyy-MM-dd"
                final = dateFormatter.string(from: date)
                
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate10(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "HH:mm:ss"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    
    func changeDateFormate100(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "hh:mm a"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return aDate
            }
        }
    }
    
    func changeDateFormate11(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "00:00"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "hh:mm a"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return "00:00"
            }
        }
    }
    
    func changeDateFormate12(aDate : String) -> Int{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return 0
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "yyyy"
                final = dateFormatter.string(from: date)
                return Int(final) ?? 0
            }
            else{
                return 0
            }
        }
    }
    
    func changeDateFormate13(aDate : String) -> Int{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return 0
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "MM"
                final = dateFormatter.string(from: date)
                return Int(final) ?? 0
            }
            else{
                return 0
            }
        }
    }
    
    func changeDateFormate14(aDate : String) -> Int{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return 0
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd"
                final = dateFormatter.string(from: date)
                return Int(final) ?? 0
            }
            else{
                return 0
            }
        }
    }
    
    func changeDateFormate15(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "0"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "MM/dd/yyyy"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return "0"
            }
        }
    }
   
    func changeDateFormate16(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return aDate
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "hh:mm a"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return aDate
            }
        }
    }
    
    func changeDateFormate17(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "0"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "MM/dd/yyyy"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return "0"
            }
        }
    }
    
    func changeDateFormate18(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "0"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "hh:mm a"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return "0"
            }
        }
    }
    
    func changeDateFormate19(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "0"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "E, MM/dd/yyyy, hh:mm a"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return "0"
            }
        }
    }
    
    
    func changeDateFormate20(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "0"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd/MM/yyyy"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return "0"
            }
        }
    }
    
    func changeDateFormate21(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return "0"
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "hh:mm a"
                final = dateFormatter.string(from: date)
                return final
            }
            else{
                return "0"
            }
        }
    }
    
    func changeDateFormate22(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd-MM-YYYY"
                final = dateFormatter.string(from: date)
                
                return "\(final)"
            }
            else{
                return aDate
            }
        }
    }
    
    func changeDateFormate23(aDate : String) -> String{
        if(aDate.equalIgnoreCase("") || aDate.trimmingCharacters(in: .whitespaces).isEmpty){
            return ""
        }else{
          //  2022-04-30 15:13:32
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: aDate){
                var final = ""
                dateFormatter.dateFormat = "dd/MMM/YYYY, EEEE, hh:mm a"
                final = dateFormatter.string(from: date)
                return "\(final)"
            }
            else{
                return ""
            }
        }
    }
    //TODO:- JsonTo String
    func jsonToString(json: AnyObject) -> String{
         do {
             let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
             let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""

            return convertedString as String
         } catch let myJSONError {

            return ""
         }
     }
      
    func login(){
        UserDefaults.standard.set(false, forKey: KU_ISLOGIN)
        UserDefaults.standard.setValue("", forKey: KU_USERID)
        UserDefaults.standard.setValue("", forKey: KU_USERTYPE) 
      // sid UserDefaults.standard.removeObject(forKey: KU_USERRESPONCE)

        if #available(iOS 13.0, *){
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "loginNavigationView") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "loginNavigationView") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }

    func touristHome(){
        if #available(iOS 13.0, *){
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeDetail") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristHomeDetail") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
    
    func touristProfile(){
        if #available(iOS 13.0, *){
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristProfileVC") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristProfileVC") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
    
    func touristVideo(){
        if #available(iOS 13.0, *){
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristVideoVC") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristVideoVC") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
    
    func touristCalendar(){
        if #available(iOS 13.0, *){
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "BookingHistoryVC") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
    
    func touristMessage(){
        if #available(iOS 13.0, *){
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristMessageVC") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = touristStoryBoard.instantiateViewController(withIdentifier: "TouristMessageVC") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
    
    func guideHome(){
        if #available(iOS 13.0, *){
            let navigationController = guideStoryBoard.instantiateViewController(withIdentifier: "GuideHomeDetail") as! UINavigationController
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                K_AppDelegate.window = window
            }
        }
        else {
            let navigationController = guideStoryBoard.instantiateViewController(withIdentifier: "GuideHomeDetail") as! UINavigationController
            let window = UIApplication.shared.delegate!.window!
            window!.rootViewController = navigationController
            UIView.transition(with: window!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
  
    
    //TODO:- Validation
    
    func isEmailValid(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isEmpty(txt: String) -> Bool{
        if(txt.trimmingCharacters(in: .whitespaces).isEmpty){
            return true
        }
        else{
            return false
        }
    }
    
    //TODO:- Hide Show StatusBar
    public func showStatusBar() {
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        UIView.animate(withDuration: 0.3) {
            statusBarWindow?.alpha = 1
        }
    }
    
    public func hideStatusBar() {
        
        let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
        UIView.animate(withDuration: 0.3) {
            statusBarWindow?.alpha = 0
        }
    }
    
    //TODO: Collection View
     
    func setCollectionviewTouristVideo(aCollectiionView: UICollectionView){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
 
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if(IS_IPAD){
            layout.itemSize = CGSize(width: (width / 2)-18, height: 190)
        }
        else{
            layout.itemSize = CGSize(width: (width / 2)-18, height: 190)
        }
         
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        aCollectiionView.collectionViewLayout = layout
    }
    
    func setCollectionviewDefaultPackage(aCollectiionView: UICollectionView){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
 
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if(IS_IPAD){
            layout.itemSize = CGSize(width: (width / 2)-18, height: 141)
        }
        else{
            layout.itemSize = CGSize(width: (width / 2)-18, height: 141)
        }
         
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .horizontal
        aCollectiionView.collectionViewLayout = layout
    }
    
    func setCollectionviewGuideProfileVideo(aCollectiionView: UICollectionView){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
 
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if(IS_IPAD){
            layout.itemSize = CGSize(width: (width / 2)-18, height: 190)
        }
        else{
            layout.itemSize = CGSize(width: (width / 2)-18, height: 190)
        }
         
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .horizontal
        aCollectiionView.collectionViewLayout = layout
    }
 }

