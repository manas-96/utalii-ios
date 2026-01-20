//
//  SceneDelegate.swift
//  Utalii
//
//  Created by Mitul Talpara on 26/09/22.
//

import UIKit

import IQKeyboardManagerSwift

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        appDel.window = window
        if #available(iOS 13, *){
            
        }
        else{
            UIApplication.shared.statusBarView?.backgroundColor = colorPrimaryDark
        }
        
        //        if(UserDefaults.standard.bool(forKey: KU_ISLOGIN)){
        //             let navigationController = storyBoard.instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
        //             guard let windowScene = (scene as? UIWindowScene) else { return }
        //             self.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        //             window!.windowScene = windowScene
        //             window!.rootViewController = navigationController//VC
        //             window!.makeKeyAndVisible()
        //             let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //             appDelegate.window = window
        //         }
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

