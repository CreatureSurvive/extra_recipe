//
//  AppDelegate.swift
//  extra_recipe
//
//  Created by Ian Beer on 1/23/17.
//  Copyright © 2017 Ian Beer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum ShortcutIdentifier: String {
        case JailbreakIn30
        case JailbreakIn15
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }
    }
    
    var launchedShortcutItem: UIApplicationShortcutItem?

    var window: UIWindow?
    
    override init() {
        super.init()
        let jbIn30Shortcut = UIApplicationShortcutItem(type: "com.creaturecoding.extra-recipe-dark.JailbreakIn30", localizedTitle: "Jailbreak in 30", localizedSubtitle: "Attempt in 30 seconds", icon: UIApplicationShortcutIcon(type: .task), userInfo: nil)
        
        let jbIn15Shortcut = UIApplicationShortcutItem(type: "com.creaturecoding.extra-recipe-dark.JailbreakIn15", localizedTitle: "Jailbreak in 15", localizedSubtitle: "Attempt in 15 seconds", icon: UIApplicationShortcutIcon(type: .task), userInfo: nil)
        
        UIApplication.shared.shortcutItems = [jbIn30Shortcut, jbIn15Shortcut]
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        var seconds = 30
        
        switch (shortCutType) {
        case ShortcutIdentifier.JailbreakIn30.type:
            seconds = 30
            handled = true
            break
        case ShortcutIdentifier.JailbreakIn15.type:
            seconds = 15
            handled = true
            break
        default:
            break
        }
        
        // Display an alert indicating the shortcut selected from the home screen.
        if (handled) {
            let vc:ViewController = window!.rootViewController as! ViewController
            vc.autoRunAfterSeconds(autoRunSeconds: seconds)
        }
        
        return handled
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = false
        }
        
        return shouldPerformAdditionalDelegateHandling
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
        guard let shortcut = launchedShortcutItem else { return }
        _ = handleShortCutItem(shortcutItem: shortcut)
        launchedShortcutItem = nil
    }

    func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem: shortcutItem)
        completionHandler(handledShortCutItem)
    }

    
}

