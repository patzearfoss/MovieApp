//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Patrick Zearfoss on 12/6/16.
//  Copyright © 2016 Pat Zearfoss. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        MovieApi.setup()
        
        return true
    }

   
}

