//
//  ConstantHeader.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 07/05/22.
//

import Foundation
import UIKit

//MARK:- Devices Type
let IS_OS_8_OR_LATER = CFloat(UIDevice.current.systemVersion)! > 8.0
let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)
let IS_RETINA = (UIScreen.main.scale >= 2.0)

//MARK:- get Devices Width and Height
let SCREEN_WIDTH = CGFloat(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)
let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6_7_8 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P_7P_8P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
let IS_IPHONE_X = (IS_IPHONE && SCREEN_HEIGHT == 812.0)
let IS_IPHONE_XOrGreter = (IS_IPHONE && SCREEN_HEIGHT == 812.0)

func getInteger(anything: Any?) -> Int {
    if let any:Any = anything {
        if let num = any as? NSNumber {
            return num.intValue
        } else if let str = any as? NSString {
            return str.integerValue
        }
    }
    return 0
}

func getInteger64(anything: Any?) -> Int64 {
    if let any:Any = anything {
        if let num = any as? NSNumber {
            return num.int64Value
        } else if let str = any as? NSString {
            return str.longLongValue
        }
    }
    return 0
}

func getString(anything: Any?) -> String {
    
    if let any:Any = anything {
        if let num = any as? NSNumber {
            return num.stringValue
        } else if let str = any as? String {
            return str
        }
    }
    return ""
}

func getBoolean(anything: Any?) -> Bool {
    
    if let any:Any = anything {
        if let num = any as? NSNumber {
            return num.boolValue
        } else if let str = any as? NSString {
            return str.boolValue
        }
    }
    return false
}

extension UILabel {
    
    func setRegularFontWithSize(size: CGFloat) {
        //        self.font = UIFont(name: K_Roboto_Regular, size: size)
        self.font = UIFont.CamptonBookFont(size: size)
    }
    
    func setMediumFontWithSize(size: CGFloat) {
        //        self.font = UIFont(name: K_Roboto_Medium, size: size)
        self.font = UIFont.CamptonMediumFont(size: size)
    }
   
    func setBoldFontWithSize(size: CGFloat) {
        //        self.font = UIFont(name: K_Roboto_Bold, size: size)
        self.font = UIFont.CamptonBoldFont(size: size)
    }
    
    func setControllerTitleWithText(stringText: String) {
        self.text = stringText
        self.setRegularFontWithSize(size: 17)
    }
}

extension UITextField {
    
   func setRegularFontWithSize(size: CGFloat) {
           //        self.font = UIFont(name: K_Roboto_Regular, size: size)
           self.font = UIFont.CamptonBookFont(size: size)
       }
       
       func setMediumFontWithSize(size: CGFloat) {
           //        self.font = UIFont(name: K_Roboto_Medium, size: size)
           self.font = UIFont.CamptonMediumFont(size: size)
       }
        
       func setBoldFontWithSize(size: CGFloat) {
           //        self.font = UIFont(name: K_Roboto_Bold, size: size)
           self.font = UIFont.CamptonBoldFont(size: size)
       }
       
    
}

extension UITextView {
    
    func setRegularFontWithSize(size: CGFloat) {
           //        self.font = UIFont(name: K_Roboto_Regular, size: size)
           self.font = UIFont.CamptonBookFont(size: size)
       }
       
       func setMediumFontWithSize(size: CGFloat) {
           //        self.font = UIFont(name: K_Roboto_Medium, size: size)
           self.font = UIFont.CamptonMediumFont(size: size)
       }
 
       func setBoldFontWithSize(size: CGFloat) {
           //        self.font = UIFont(name: K_Roboto_Bold, size: size)
           self.font = UIFont.CamptonBoldFont(size: size)
       }
       
}

extension UIButton {
    
    func setRegularFontWithSize(size: CGFloat) {
        self.titleLabel!.font = UIFont.CamptonBookFont(size: size)
        
    }
    
    func setMediumFontWithSize(size: CGFloat) {
        self.titleLabel!.font = UIFont.CamptonMediumFont(size: size)
    }
 
    func setBoldFontWithSize(size: CGFloat) {
        self.titleLabel!.font = UIFont.CamptonBoldFont(size: size)
    }
    
    
}

