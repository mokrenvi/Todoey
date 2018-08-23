//
//  AppDelegate.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/21/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String) for coredata
        //print(Realm.Configuration.defaultConfiguration.fileURL) for realm
        do {
            _ = try Realm()
//            try realm.write {
//                realm.add(data)
//            }
        } catch {
            print(error)
        }
        return true
    }
}
