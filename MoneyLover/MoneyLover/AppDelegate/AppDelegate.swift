//
//  AppDelegate.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 11/22/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var coreDataManager = CoreDataManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        if let errorConfig = configureError {
            print(errorConfig)
        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme == "fb558824467644283" {
            FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        } else if url.scheme == "com.googleusercontent.apps.43222908773-mhq0odkbf410hs9ac5aa1e7qeihn6bfe" {
            return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return false
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
        coreDataManager.saveContext()
    }
}
