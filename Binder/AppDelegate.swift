//
//  AppDelegate.swift
//  Finder
//
//  Created by Rao Mudassar on 11/3/18.
//  Copyright © 2018 Rao Mudassar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseInstanceID
import IQKeyboardManagerSwift
import FirebaseMessaging
import UserNotifications
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate,GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
       FirebaseApp.configure()
        
        
        IQKeyboardManager.shared.enable = true
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [Chat1ViewController.self]
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                           categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        if(UserDefaults.standard.string(forKey:"uid") == nil){
            
        }else if (UserDefaults.standard.string(forKey:"uid") == ""){
            
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabViewController:UINavigationController = (storyboard.instantiateViewController(withIdentifier: "navbar") as? UINavigationController)!
            self.window?.rootViewController = tabViewController
            self.window?.makeKeyAndVisible()
        }
        
        GIDSignIn.sharedInstance().clientID = "608889844435-fgb0ds67po2pfnm6i5q73mkkeck2aafr.apps.googleusercontent.com"
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
      return true

    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
        //            openURL:url
        //            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
        //            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
        //        ];
        
        let handled=FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]) || handled
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey:"DeviceToken")
        }else{
            
            UserDefaults.standard.set("abc", forKey:"DeviceToken")
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        
        
    }
    
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground, received: \n \(notification.request.content)")
        print(notification.request.content.userInfo)
        
        let type  = notification.request.content.userInfo[AnyHashable("gcm.notification.type")] as? String
        
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle tapped push from background, received: \n \(response.notification.request.content)")
        
        
        
        
        completionHandler()
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    

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
        UIApplication.shared.applicationIconBadgeNumber = 0
        //self.SignInApi()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

