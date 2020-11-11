//
//  AppDelegate.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import IQKeyboardManager
import UserNotifications
import Firebase
import YandexMobileMetrica
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "cc216d43-cd1b-41a9-88c7-fbf2721f2e43")
        YMMYandexMetrica.activate(with: configuration!)
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForRemoteNotifications(application: application)
        window = UIWindow(frame: UIScreen.main.bounds)
        AppCenter.shared.createWindow(window!)
        AppCenter.shared.start()

        return true
    }
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
    
    private func registerForRemoteNotifications(application: UIApplication) -> Void {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    
    }
    
}
    
    



extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
{


    
    Messaging.messaging().apnsToken = deviceToken
}

func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print(" didFailToRegisterForRemoteNotificationsWithError  \(error)" )
}

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserManager.setFirebaseToken(token: fcmToken)

    }


func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
{
    completionHandler([.alert, .badge, .sound])
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

    if let info = userInfo[gcmMessageIDKey] {
        print(info)
    }

    print("userinfo no completionHandler", userInfo)
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {


    
    if let info = userInfo[gcmMessageIDKey] {
          print(info)
      }
        if let videoID = userInfo["id"] {
            UserManager.setVideoId(video : Int("\(videoID)")!)
            NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)

        }
    
      print("userinfo no completionHandler", userInfo)
    
    
}
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask?) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation ?? .allButUpsideDown
        }
    }

}


