//
//  AppDelegate.swift
//  CoreDataAlbelli
//
//  Created by Pavle Mijatovic on 09/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()

        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(identifier: "Users_ID")
        let vc = sb.instantiateViewController(identifier: "Articles_ID")
        window?.rootViewController = vc

        return true
    }
}

