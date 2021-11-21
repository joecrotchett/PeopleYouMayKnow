//
//  AppDelegate.swift
//  PYMK
//
//  Created by Joe on 11/20/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindow()
        return true
    }
    
    // MARK: Private
    
    private func configureWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        StyleGuide.apply(to: window!)
        
        let pymkViewController = PYMKViewController()
        let navigationController = UINavigationController(rootViewController: pymkViewController)
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
