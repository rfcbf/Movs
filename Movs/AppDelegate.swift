//
//  AppDelegate.swift
//  Movs
//
//  Created by Renato Ferraz on 13/05/20.
//  Copyright © 2020 Renato Ferraz. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.AzulEscuro()
        UITabBar.appearance().barTintColor = UIColor.AmareloClaro()
        UITabBar.appearance().unselectedItemTintColor = UIColor.AmareloEscuro()
        
        UINavigationBar.appearance().barTintColor = UIColor.AmareloClaro()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.AzulEscuro()]

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Movs")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        statusBarView.tag = 150
        statusBarView.isUserInteractionEnabled = true
        view.addSubview(statusBarView)
    }
    
    func removeStatusBar() {
       if let viewWithTag = self.view.viewWithTag(150) {
           viewWithTag.removeFromSuperview()
       }
    }

}
