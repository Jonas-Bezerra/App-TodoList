//
//  AppDelegate.swift
//  Lista
//
//  Created by jonas junior on 29/12/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 25),
                                              .foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(named: K.ColorName.lightBlue)
            return appearance
        }()

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
//        print(Realm.Configuration.defaultConfiguration.fileURL) 
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }
}

