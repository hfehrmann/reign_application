//
//  AppDelegate.swift
//  Reign
//
//  Created by Hans Fehrmann on 6/1/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: Coordinator!
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow()
        coordinator = MainCoordinator(window: window)
        coordinator.start()
        self.window = window
        return true
    }

}
