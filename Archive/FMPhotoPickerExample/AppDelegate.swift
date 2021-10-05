//
//  AppDelegate.swift
//  FMPhotoPickerExample
//
//  Created by c-nguyen on 2018/01/25.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import UIKit
//import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //GADMobileAds.sharedInstance().start(completionHandler: nil)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let isQuoteSelectionDone = UserDefaults.standard.bool(forKey: "isQuoteSelectionDone")
//        if isQuoteSelectionDone == true{
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "startNav")
            
            self.window?.rootViewController = initialViewController
//        }
//        else{
//            let initialViewController = storyboard.instantiateViewController(withIdentifier: "QuoteCategoryTableViewController")
//
//            self.window?.rootViewController = initialViewController
//        }
        self.window?.makeKeyAndVisible()

        let captionCategoryList = ["RECENT","ATTITUDE","BEACH","BOYFRIEND","BOYS","CLEVER","COUPLE","CRUSH","EMOTIONAL","FRIENDSHIP DAY","FRIENDSHIP","FUNNY","GENERAL","GIRL ATTITUDE","GIRL","GIRLFRIEND","GYM","HATERS","LIFE","LOVE","MEN","PERSONALITY","PICTURES","PROFLLE PICTURE","RAIN","ROMANTIC","SAD","SELFIE","SHORT","SINGLE","SMILE","SORRY","STYLISH","SUMMER","SUNDAY","SWAG","WEEKEND","WIFE"]
        
        UserDefaults.standard.set(captionCategoryList, forKey: "captionCategoryList")
        
        let isSetAlready = UserDefaults.standard.bool(forKey: "isSetAlready")
        
        if isSetAlready == false{
            UserDefaults.standard.set(false, forKey: "Valentine")
            UserDefaults.standard.set(false, forKey: "Alphabet")
            UserDefaults.standard.set(false, forKey: "Bad boys")
            UserDefaults.standard.set(false, forKey: "Birthday")
            UserDefaults.standard.set(false, forKey: "Alien")
            UserDefaults.standard.set(false, forKey: "All")
            UserDefaults.standard.set(false, forKey: "Love")
            UserDefaults.standard.set(false, forKey: "Valentine Doodle")
            UserDefaults.standard.set(false, forKey: "Valentine Hand Drawn")
            UserDefaults.standard.set(false, forKey: "Valentine Lettering")
            
            UserDefaults.standard.set(false, forKey: "Pack 1")
            UserDefaults.standard.set(false, forKey: "Pack 2")
            UserDefaults.standard.set(true, forKey: "isSetAlready")

        }
        

        UserDefaults.standard.synchronize()

        let recentQuoteList = UserDefaults.standard.object(forKey: "recentUsedQuoteList");
        
        if let recentQuoteListExist = recentQuoteList{
            
        }
        else{
            UserDefaults.standard.set([[:]], forKey: "recentQuoteList")
            UserDefaults.standard.synchronize()
        }
        
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

