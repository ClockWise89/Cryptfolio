//
//  AppDelegate.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-08.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import Firebase
import CocoaLumberjack

#if DEBUG
    let logLevel = DDLogLevel.debug
#else
    let logLevel = DDLogLevel.info
#endif

/*
 - Start working with handling portfolios and transactions.
 - Add on transaction level, where user chooses asset and inputs data
 
 */


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        DDLog.add(DDTTYLogger.sharedInstance, with: logLevel) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance, with: logLevel) // ASL = Apple System Logs
        DDTTYLogger.sharedInstance.logFormatter = CustomLogger()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        if let path = dirPath.first {
            DDLogDebug("User directory: \(path)")
        }
        
        FirebaseConfiguration.shared.setLoggerLevel(.min) // Remove logging from firebase for the moment
        FirebaseApp.configure()
        DDLogDebug("Firebase is configured.")
        
        let _ = Database.shared // Initialize databases
        
        // Setup intial ViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        let mvc = MainViewController()
        let nvc = UINavigationController(rootViewController: mvc)
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()

        return true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

