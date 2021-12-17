//
//  PushNotificationManager.swift
//  TruckYa
//
//  Created by Digit Bazar on 18/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//
public enum NotificationType:String {
    case newbooking, bookingaccept, driverreached, ridestart, ridecompleted, declinebooking, paymentdonebyrider
}
public enum NotificationState { case Background, Foreground }
import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications
import JSSAlertView
class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    static let shared = PushNotificationManager()
    var userID: String!
    override init() {
        super.init()
        guard let userId = UserDefaults.standard.userID else {
            print("UserID not set in UserDefaults")
            return
        }
        self.userID = userId
    }
    //    init(userID: String) {
    //        self.userID = userID
    //        super.init()
    //    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updatePushTokenIfNeeded()
    }
    func updatePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            print("FCM Token => \(token)")
            if let userId = UserDefaults.standard.userID {
                print("User ID while updating FCM Token => \(userId)")
                sendTokenToServer(userId: userId, token: token)
            } else {
                print("UserID not set in User Defaults")
            }
        } else {
            print("No FCM Token")
        }
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Remote Message App Data => \n")
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Did receive Registration Token => \n")
        updatePushTokenIfNeeded()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("REMOTE NOTIFICATION RECEIVED")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {
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
            completionHandler([.alert, .badge, .sound])
            handleNotification(withNotificationType: notificationType, data: data, state: .Background, completion: completionHandler)
        } catch let error {
            print(error.localizedDescription)
        }
        //        completionHandler([.alert, .badge, .sound])
        //        if let type = userInfo["type"] as? String,
        //            let notificationType = NotificationType(rawValue: type) {
        //            handleNotification(withNotificationType: notificationType, data: userInfo, state: .Background)
        //        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did Recivce Response => \n")
        //        let userInfo = response.notification.request.content.userInfo as! [String:Any]
        //        print(userInfo)
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
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
            completionHandler()
            handleRemoteNotification(withNotificationType: notificationType, data: data, state: .Background, completion: completionHandler)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        
        //        completionHandler()
        //        if let type = userInfo["type"] as? String,
        //            let notificationType = NotificationType(rawValue: type) {
        //            handleNotification(withNotificationType: notificationType, data: userInfo, state: .Background)
        //        }
        
    }
    
    func handleNotification(withNotificationType type: NotificationType, data: Data, state:NotificationState, completion: @escaping (UNNotificationPresentationOptions) -> Void) {
        switch type {
        case .newbooking: handleNewBookingNotification(data: data)
        case .bookingaccept: handleAcceptBookingNotification(data: data)
        case .driverreached: handleDriverReachedNotification()
        case .ridestart: handleJourneyStartedNotification()
        case .ridecompleted: handleJourneyCompletedNotification()
        case .declinebooking: handleDeclineNotification()
        case .paymentdonebyrider: handlePaymentDoneNotification()
        }
    }
    func handleRemoteNotification(withNotificationType type: NotificationType, data: Data, state:NotificationState, completion: (() -> Void)? = nil) {
        switch type {
        case .newbooking: handleNewBookingNotification(data: data)
        case .bookingaccept: handleAcceptBookingNotification(data: data)
        case .driverreached: handleDriverReachedNotification()
        case .ridestart: handleJourneyStartedNotification()
        case .ridecompleted: handleJourneyCompletedNotification()
        case .declinebooking: handleDeclineNotification()
        case .paymentdonebyrider: handlePaymentDoneNotification()
        }
    }
    func handlePaymentDoneNotification() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            print("Root VC not a UINavigatinController")
            return
        }
        if let rootViewController = UIApplication.topViewController() {
            if rootViewController is DriverDashboardVC {
                let viewController = rootViewController as! DriverDashboardVC
                viewController.processPaymentDoneNotification()
            } else {
                for vc in navigationController.viewControllers {
                    if vc is DriverDashboardVC {
                        let viewController = vc as! DriverDashboardVC
                        viewController.processPaymentDoneNotification()
                        //                            navigationController.popToViewController(viewController, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    func handleDeclineNotification() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            print("Root VC not a UINavigatinController")
            return
        }
        if let rootViewController = UIApplication.topViewController() {
            if rootViewController is CustomerDashboardVC {
//                let viewController = rootViewController as! CustomerDashboardVC
//                viewController.processDriverCompletedJourneyNotification()
            } else {
                for vc in navigationController.viewControllers {
                    if vc is CustomerDashboardVC {
//                        let viewController = vc as! CustomerDashboardVC
//                        viewController.processDriverCompletedJourneyNotification()
                        //                            navigationController.popToViewController(viewController, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    func handleJourneyCompletedNotification() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            print("Root VC not a UINavigatinController")
            return
        }
        if let rootViewController = UIApplication.topViewController() {
            if rootViewController is MapViewController {
                let viewController = rootViewController as! MapViewController
                viewController.processDriverCompletedJourneyNotification()
            } else {
                for vc in navigationController.viewControllers {
                    if vc is MapViewController {
                        let viewController = vc as! MapViewController
                        viewController.processDriverCompletedJourneyNotification()
                        //                            navigationController.popToViewController(viewController, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    func handleJourneyStartedNotification() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            print("Root VC not a UINavigatinController")
            return
        }
        if let rootViewController = UIApplication.topViewController() {
            if rootViewController is MapViewController {
                let viewController = rootViewController as! MapViewController
                viewController.processDriverStartedJourneyNotification()
            } else {
                for vc in navigationController.viewControllers {
                    if vc is MapViewController {
                        let viewController = vc as! MapViewController
                        viewController.processDriverStartedJourneyNotification()
                        
                        //                            navigationController.popToViewController(viewController, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    func handleDriverReachedNotification() {
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            print("Root VC not a UINavigatinController")
            return
        }
        if let rootViewController = UIApplication.topViewController() {
            if rootViewController is MapViewController {
                let viewController = rootViewController as! MapViewController
                viewController.processDriverReachedToSourceNotification()
            } else {
                for vc in navigationController.viewControllers {
                    if vc is MapViewController {
                        let viewController = vc as! MapViewController
                        viewController.processDriverReachedToSourceNotification()
                        //                            navigationController.popToViewController(viewController, animated: true)
                    }
                    
                }
            }
        }
        
        
    }
    func handleAcceptBookingNotification(data: Data) {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(AcceptBookingPayload.self, from: data)
            print(result)
            
            guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                print("Root VC not a UINavigatinController")
                return
            }
            if let rootViewController = UIApplication.topViewController() {
                if rootViewController is CustomerDashboardVC {
                    let viewController = rootViewController as! CustomerDashboardVC
                    viewController.bookingDetails = result
                } else {
                    for vc in navigationController.viewControllers {
                        if vc is CustomerDashboardVC {
                            let viewController = vc as! CustomerDashboardVC
                            viewController.bookingDetails = result
                            //                            navigationController.popToViewController(viewController, animated: true)
                        }
                        
                    }
                }
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func handleNewBookingNotification(data: Data) {
        print("glad to be here")
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(BookingPayloadCodable.self, from: data)
            print(result)
            if let customerName = result.ridername,
                let bookingId = result.bookingid,
                let sourceAddress = result.source,
                let destinationAddress = result.destination {
                print("customerName => \(customerName)\nbookingId => \(bookingId)\nsourceAddress => \(sourceAddress)\ndestinationAddress => \(destinationAddress)")
                guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                    print("Root VC not a UINavigatinController")
                    return
                }
                UserDefaults.standard.driverPushBoookingID = bookingId
                UserDefaults.standard.driverPushCustomerName = customerName
                UserDefaults.standard.driverPushSourceAddress = sourceAddress
                UserDefaults.standard.driverPushDestinationAddress = destinationAddress
                if let rootViewController = UIApplication.topViewController() {
                    if rootViewController is DriverDashboardVC {
                        let viewController = rootViewController as! DriverDashboardVC
                        if viewController.isLoaded {
                            viewController.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
                        } else {
                            viewController.bookingId = bookingId
                        }
                    } else {
                        for vc in navigationController.viewControllers {
                            if vc is DriverDashboardVC {
                                let viewController = vc as! DriverDashboardVC
                                if viewController.isLoaded {
                                    viewController.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
                                } else {
                                    viewController.bookingId = bookingId
                                }
                                navigationController.popToViewController(viewController, animated: true)
                            }
                            
                        }
                    }
                    
                    /*
                     for vc in navigationController.viewControllers {
                     if vc is DriverDashboardVC {
                     let viewController = vc as! DriverDashboardVC
                     if viewController.isLoaded {
                     viewController.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
                     } else {
                     viewController.bookingId = bookingId
                     }
                     navigationController.popToViewController(viewController, animated: true)
                     break
                     } else {
                     let viewController = DriverDashboardVC()
                     viewController.bookingId = bookingId
                     //                    viewController.processNotification(bookingId: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
                     //                    navigationController.pushViewController(viewController, animated: true)
                     navigationController.popToViewController(viewController, animated: true)
                     break
                     }
                     }
                     */
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        /*
         if let customerName = data["ridername"] as? String,
         let bookingId = data["bookingid"] as? String,
         let sourceAddress = data["source"] as? String,
         let destinationAddress = data["destination"] as? String {
         print("customerName => \(customerName)\nbookingId => \(bookingId)\nsourceAddress => \(sourceAddress)\ndestinationAddress => \(destinationAddress)")
         guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
         print("Root VC not a UINavigatinController")
         return
         }
         UserDefaults.standard.driverPushBoookingID = bookingId
         UserDefaults.standard.driverPushCustomerName = customerName
         UserDefaults.standard.driverPushSourceAddress = sourceAddress
         UserDefaults.standard.driverPushDestinationAddress = destinationAddress
         if let rootViewController = UIApplication.topViewController() {
         if rootViewController is DriverDashboardVC {
         let viewController = rootViewController as! DriverDashboardVC
         if viewController.isLoaded {
         viewController.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
         } else {
         viewController.bookingId = bookingId
         }
         } else {
         for vc in navigationController.viewControllers {
         if vc is DriverDashboardVC {
         let viewController = vc as! DriverDashboardVC
         if viewController.isLoaded {
         viewController.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
         } else {
         viewController.bookingId = bookingId
         }
         navigationController.popToViewController(viewController, animated: true)
         }
         
         }
         }
         
         /*
         for vc in navigationController.viewControllers {
         if vc is DriverDashboardVC {
         let viewController = vc as! DriverDashboardVC
         if viewController.isLoaded {
         viewController.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
         } else {
         viewController.bookingId = bookingId
         }
         navigationController.popToViewController(viewController, animated: true)
         break
         } else {
         let viewController = DriverDashboardVC()
         viewController.bookingId = bookingId
         //                    viewController.processNotification(bookingId: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
         //                    navigationController.pushViewController(viewController, animated: true)
         navigationController.popToViewController(viewController, animated: true)
         break
         }
         }
         */
         }
         }
         */
    }
    func deleteFCMToken(completion: @escaping ((Error?) -> Void)) {
        Messaging.messaging().deleteFCMToken(forSenderID: Config.FirebaseConfig.CloudMessagingConfig.SenderID, completion: completion)
    }
    func sendTokenToServer(userId:String, token:String) {
        NotificationsAPI.shared.updateFCMToken(userId: userId, token: token) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    
                }
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
                DispatchQueue.main.async {
                    
                }
            } else if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    
                    guard let status = result["status"] as? String else {
                        print("MARK: Unable to get Result Status from API Call")
                        return
                    }
                    let message = result["message"] as? String
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "FP Success")")
                    case .none: print("Unknown Case")
                    fatalError()
                    }
                    
                } catch let err {
                    print("Unable to decode data")
                    print("Err: \(err.localizedDescription)")
                }
            }
        }
    }
    
}
