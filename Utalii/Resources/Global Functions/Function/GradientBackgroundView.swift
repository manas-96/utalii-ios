//
//  GradientView.swift
//  Click4Growth
//
//  Created by Mitul Talpara on 07/05/22.
//

import Foundation
import UIKit
import CoreGraphics

@IBDesignable
final class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 200 - 30),
                                height: 300)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.0, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}

@IBDesignable
final class GradientView1: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 200 - 30),
                                height: 50)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}

@IBDesignable
final class GradientView2: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 200 - 30),
                                height: 41)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.masksToBounds = true
    }
}

@IBDesignable
final class GradientView3: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 200 - 30),
                                height: 60)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
@IBDesignable
final class GradientView4: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 400 - 30),
                                height: 130)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.masksToBounds = true
    }
}
@IBDesignable
final class GradientView5: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 200 - 30),
                                height: 60)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = CGFloat(8)
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }
}

@IBDesignable
final class GradientView6: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: 210,
                                height: 210)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = CGFloat(20)
        layer.masksToBounds = true
    }
}
@IBDesignable
final class GradientView7: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 400 - 30),
                                height: 47)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = CGFloat(12)
        layer.masksToBounds = true
    }
}

@IBDesignable
final class GradientView8: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 400 - 30),
                                height: 32)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = CGFloat(10)
        layer.masksToBounds = true
    }
}

@IBDesignable
final class GradientView9: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 400 - 30),
                                height: 26)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = CGFloat(10)
        layer.masksToBounds = true
    }
}
@IBDesignable
final class GradientView10: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: (window?.frame.width ?? 400 - 30),
                                height: 103)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.zPosition = 1
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.2)
//        gradient.endPoint = CGPoint(x: 1.2, y: 1.5)
        gradient.locations = [0.2, 1.0]
        layer.addSublayer(gradient)
        layer.cornerRadius = CGFloat(10)
        layer.masksToBounds = true
    }
}
