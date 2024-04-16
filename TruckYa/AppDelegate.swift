//
//  AppDelegate.swift
//  TruckYa
//
//  Created by Anshul on 16/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import GooglePlaces
import Firebase
import CoreLocation
import Stripe

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation!
    var window: UIWindow?
    var lat = ""
    var long = ""
    var iv: Any!
    static let shared = UIApplication.shared.delegate as! AppDelegate
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
//        setupPushNofications()
        
        GMSServices.provideAPIKey(Config.MapsConfig.GMS_API_KEY)
        GMSPlacesClient.provideAPIKey(Config.MapsConfig.GMS_API_KEY)
        Stripe.setDefaultPublishableKey(Config.PaymentConfig.stripeKey)
        IQKeyboardManager.shared.enable = true
        setupLocationManager()
        
        return true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last
        AppDelegate.shared.currentLocation = latestLocation
        AppDelegate.shared.lat = String(format: "%.4f", latestLocation!.coordinate.latitude)
        AppDelegate.shared.long = String(format: "%.4f", latestLocation!.coordinate.longitude)
        print(AppDelegate.shared.lat + " " + AppDelegate.shared.long)
        manager.stopUpdatingLocation()
    }
    
    
    
    func setupPushNofications() {
        if UserDefaults.standard.isLoggedIn == true {
            PushNotificationManager.shared.registerForPushNotifications()
//            let notificationOptions = launchOptions?[.remoteNotification]
//            if let notification = notificationOptions as? [String: AnyObject],
//                let type = notification["type"] as? String,
//                let notificationType = NotificationType(rawValue: type) {
//                PushNotificationManager.shared.handleNotification(withNotificationType: notificationType, data: notification, state: .Background)
//            }
        }
    }
    
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error")
    }
    
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        //MARK: •••••• Previously using below method ••••••
        /*
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("***** Remote Notification Message *******\n-----------\n")
        print(userInfo)
        print("\n------------\n")
        
        if let type = userInfo["type"] as? String,
            let notificationType = NotificationType(rawValue: type) {
            PushNotificationManager.shared.handleNotification(withNotificationType: notificationType, data: userInfo, state: .Background)
        }
        */
        
        
        guard let userInfo = userInfo as? [String: Any] else {
            print("Unable to convert userInfo as Dictionary")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let jsonString:String = String(data: data, encoding: .utf8) else {
                print("Unable to convert Data to JSON String")
                return
            }
            print("\n\n••• ---------------------------------------------- •••\n\n"+jsonString+"\n\n••• ---------------------------------------------- •••\n\n")
            guard let type = userInfo["type"] as? String,
                let notificationType = NotificationType(rawValue: type) else {
                    print("Notification Type not available")
                    return
            }
            PushNotificationManager.shared.handleRemoteNotification(withNotificationType: notificationType, data: data, state: .Background, completion: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        
        
        
        
        //        getNotificationDetails(userInfo: userInfo, sender: "application: didReceiveRemoteNotification")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        //MARK: Previously using below method!!
        /*
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //MARK: In app notification
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        if let type = userInfo["type"] as? String,
            let notificationType = NotificationType(rawValue: type) {
            PushNotificationManager.shared.handleNotification(withNotificationType: notificationType, data: userInfo, state: .Foreground)
        }
        */
        
        guard let userInfo = userInfo as? [String: Any] else {
            print("Unable to convert userInfo as Dictionary")
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
            guard let jsonString:String = String(data: data, encoding: .utf8) else {
                print("Unable to convert Data to JSON String")
                return
            }
            print("\n\n••• ---------------------------------------------- •••\n\n"+jsonString+"\n\n••• ---------------------------------------------- •••\n\n")
            guard let type = userInfo["type"] as? String,
                let notificationType = NotificationType(rawValue: type) else {
                    print("Notification Type not available")
                    return
            }
            PushNotificationManager.shared.handleRemoteNotification(withNotificationType: notificationType, data: data, state: .Background)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        
        //        getNotificationDetails(userInfo: userInfo, sender: "application: didReceiveRemoteNotification, fetchCompletionHandler")
    }
    // [END receive_message]
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

/*
 // [START ios_10_message_handling]
 @available(iOS 10, *)
 extension AppDelegate : UNUserNotificationCenterDelegate {
 
 // Receive displayed notifications for iOS 10 devices.
 func userNotificationCenter(_ center: UNUserNotificationCenter,
 willPresent notification: UNNotification,
 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 let userInfo = notification.request.content.userInfo
 
 // With swizzling disabled you must let Messaging know about the message, for Analytics
 // Messaging.messaging().appDidReceiveMessage(userInfo)
 // Print message ID.
 if let messageID = userInfo[gcmMessageIDKey] {
 print("Message ID: \(messageID)")
 }
 
 // Print full message.
 print(userInfo)
 // Change this to your preferred presentation option
 completionHandler([.alert, .badge, .sound])
 getNotificationDetails(userInfo: userInfo, sender: "userNotificationCenter: willPresent, iOS 10, *")
 }
 
 func userNotificationCenter(_ center: UNUserNotificationCenter,
 didReceive response: UNNotificationResponse,
 withCompletionHandler completionHandler: @escaping () -> Void) {
 let userInfo = response.notification.request.content.userInfo
 // Print message ID.
 if let messageID = userInfo[gcmMessageIDKey] {
 print("Message ID: \(messageID)")
 }
 
 // Print full message.
 print(userInfo)
 completionHandler()
 getNotificationDetails(userInfo: userInfo, sender: "userNotificationCenter: didReceive, iOS 10, *")
 }
 }
 // [END ios_10_message_handling]
 
 extension AppDelegate : MessagingDelegate {
 // [START refresh_token]
 func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
 print("Firebase registration token: \(fcmToken)")
 UserDefaults.standard.set(fcmToken, forKey: "fcmtoken")
 let dataDict:[String: String] = ["token": fcmToken]
 NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
 // TODO: If necessary send token to application server.
 // Note: This callback is fired at each app startup and whenever a new token is generated.
 }
 // [END refresh_token]
 // [START ios_10_data_message]
 // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
 // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
 func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
 print("Received data message: \(remoteMessage.appData)")
 }
 // [END ios_10_data_message]
 }
 
 
 */

public extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//}
