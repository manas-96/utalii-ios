//
//  UIFont+CustomDefine.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 07/05/22.
//
import Foundation
import  UIKit

extension UIFont
{
    /* Usage:
     * headerNameLabel.font = UIFont.customFontOfSize(14.0)
     */
    //MARK:- Custom Font Size
    class func CamptonBoldFont(size: CGFloat) -> UIFont
    {
        if IS_IPAD
        {
            return UIFont(name: Bold, size: size+3)!
        }
        else
        {
            return UIFont(name: Bold, size: size)!
        }
        
    }
    
    
    class func CamptonMediumFont(size: CGFloat) -> UIFont
    {
        if IS_IPAD
        {
            return UIFont(name: Medium, size: size+3)!
        }
        else
        {
            return UIFont(name: Medium, size: size)!
        }
        
    }
    
    class func CamptonBookFont(size: CGFloat) -> UIFont{
        if IS_IPAD
        {
            return UIFont(name: Light, size: size+3)!
        }
        else
        {
            return UIFont(name: Light, size: size)!
        }
        
    }
}
