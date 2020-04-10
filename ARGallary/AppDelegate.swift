//
//  AppDelegate.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/8/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//
// swiftlint:disable line_length

import ARKit
import Firebase
import IQKeyboardManagerSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareLibraries()
        prepareAppearance()
        prepareApplication()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    // MARK: - Private

    private func prepareLibraries() {
        FirebaseApp.configure()

        IQKeyboardManager.shared.enable = true
    }

    private func prepareAppearance() {
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    private func prepareApplication() {
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }

        window = UIWindow()

        if let isAuthorized: Bool = UserDefaultsUtils.getValueForKey(.isAuthorized),
            isAuthorized {
            ApplicationRouter.preparationScreen.initializeWindow(window)
        } else {
            ApplicationRouter.login.initializeWindow(window)
        }
    }
}
