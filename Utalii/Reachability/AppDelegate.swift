// Latest 11 sep shant unj UK 2023
//  AppDelegate.swift
//  Utalii
//
//  Created by Mitul Talpara on 26/09/22.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import LocalAuthentication

   
    var DeviceToken = ""
    var FCMToken = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?
    var deviceTockenString = ""
    var notification : String!
        //var DeviceToken = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #available(iOS 13.0, *) {
            // In iOS 13+, scene-based life cycle is used.
            // The window setup is done in SceneDelegate.
        } else {
            // For iOS 12 and below, setup the window here.
            window = UIWindow(frame: UIScreen.main.bounds)
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "loginNavigationView") as! UINavigationController
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                print("Notification authorization request failed: \(error.localizedDescription)")
            }
        }
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        let googleMapsApiKey = "AIzaSyDARs3i8XWlc-hYRUwQcIRbswM2KtxAeqI"
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey("AIzaSyDARs3i8XWlc-hYRUwQcIRbswM2KtxAeqI")
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true

        return true
    }
}

//extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
//    
//    func registerForPushNotifications(application: UIApplication) {
//        Messaging.messaging().delegate = self
//        
//        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization( options: authOptions,
//                                                                 completionHandler: {_, _ in })
//        application.registerForRemoteNotifications()
//    }
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        guard let fcmToken = fcmToken else { return }
//            //FCMToken = fcmToken
//            print("Firebase registration token: \(fcmToken)")
//            FCMToken = fcmToken
//            print(FCMToken + "sid")
//// sid           savedFcmToken = fcmToken
////            let dataDict:[String: String] = ["token": savedFcmToken ]
//          //  NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//       // }
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//        DeviceToken = token
//        print(FCMToken + "sid")
//        
//
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error.localizedDescription)")
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("didReceiveRemoteNotification")
//        guard let aps = userInfo as? [String: AnyObject] else {
//            completionHandler(.noData)
//            return
//        }
//        
//        print("Notification Data: \(aps)")
//        //onMessageReceived(param: aps)
//        completionHandler(.newData)
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("willPresent")
//        
//        let userInfo = notification.request.content.userInfo
//        completionHandler([.alert, .sound, .badge])
//        print(userInfo)
//        guard let aps = userInfo as? [String: AnyObject] else {
//            return
//        }
//        print("Notification Data: \(aps)")
//        print("")
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("didReceive")
//        guard let window = self.window else {
//            return
//        }
//        let userInfo = response.notification.request.content.userInfo
//        guard let aps = userInfo as? [String: AnyObject] else {
//            completionHandler()
//            return
//        }
//        print("Notification Data: \(aps)")
//        //        let rId = aps["rId"] as? String ?? ""
//        //        let content = aps["content"] as? String ?? ""
//        ////        guard let vc = StoryBoard.Restaurent.instantiateViewController(withIdentifier: "RestaurentDetailVC") as? RestaurentDetailVC else {
//        ////            return
//        ////        }
//        //        //vc.restaurantId = rId
//        //        if rId != "" {
//        //            let notificationResponse = ["userInfo": ["rId": rId]]
//        //            NotificationCenter.default.post(name: NSNotification.Name("MoveToRestaurantDetailsVC"), object: nil, userInfo: notificationResponse)
//        //        } else {
//        //            let notificationResponse = ["userInfo": ["content": content]]
//        //            NotificationCenter.default.post(name: NSNotification.Name("moveToSearchVC"), object: nil, userInfo: notificationResponse)
//        //        }
//        
//        //        let nav = UINavigationController(rootViewController: vc)
//        //        nav.isNavigationBarHidden = true
//        //        window.rootViewController = nav
//        //        window.makeKeyAndVisible()
//        completionHandler()
//    }
//    
//}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        DeviceToken = token
        print(DeviceToken + "sid")
        

    }

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM registration token: \(fcmToken)")
        // Save or send the token to your server
        let fcmToken = fcmToken
            //FCMToken = fcmToken
            print("Firebase registration token: \(fcmToken)")
            FCMToken = fcmToken
            print(FCMToken + "sid")
// sid           savedFcmToken = fcmToken
//            let dataDict:[String: String] = ["token": savedFcmToken ]
          //  NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
       // }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
            //FCMToken = fcmToken
            print("Firebase registration token: \(fcmToken)")
            FCMToken = fcmToken
            print(FCMToken + "sid")
// sid           savedFcmToken = fcmToken
//            let dataDict:[String: String] = ["token": savedFcmToken ]
          //  NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
       // }
    }

//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }


    func registerForPushNotifications(application: UIApplication) {
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions,
                                                                 completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }
    
   
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        guard let aps = userInfo as? [String: AnyObject] else {
            completionHandler(.noData)
            return
        }
        
        print("Notification Data: \(aps)")
        //onMessageReceived(param: aps)
        completionHandler(.newData)
    }
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        
        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .sound, .badge])
        print(userInfo)
        guard let aps = userInfo as? [String: AnyObject] else {
            return
        }
        print("Notification Data: \(aps)")
        print("")
    }
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
        guard let window = self.window else {
            return
        }
        let userInfo = response.notification.request.content.userInfo
        guard let aps = userInfo as? [String: AnyObject] else {
            completionHandler()
            return
        }
        print("Notification Data: \(aps)")
        //        let rId = aps["rId"] as? String ?? ""
        //        let content = aps["content"] as? String ?? ""
        ////        guard let vc = StoryBoard.Restaurent.instantiateViewController(withIdentifier: "RestaurentDetailVC") as? RestaurentDetailVC else {
        ////            return
        ////        }
        //        //vc.restaurantId = rId
        //        if rId != "" {
        //            let notificationResponse = ["userInfo": ["rId": rId]]
        //            NotificationCenter.default.post(name: NSNotification.Name("MoveToRestaurantDetailsVC"), object: nil, userInfo: notificationResponse)
        //        } else {
        //            let notificationResponse = ["userInfo": ["content": content]]
        //            NotificationCenter.default.post(name: NSNotification.Name("moveToSearchVC"), object: nil, userInfo: notificationResponse)
        //        }
        
        //        let nav = UINavigationController(rootViewController: vc)
        //        nav.isNavigationBarHidden = true
        //        window.rootViewController = nav
        //        window.makeKeyAndVisible()
        completionHandler()
    }
    
}
     

