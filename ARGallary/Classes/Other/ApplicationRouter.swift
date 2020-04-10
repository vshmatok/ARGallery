//
//  ApplicationRouter.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/7/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

enum ApplicationRouter: String {

    // MARK: - Cases

    case login = "LoginNavigationController"
    case main = "MainNavigationController"
    case preparationScreen = "StartScreenViewController"

    // MARK: - Properties

    private var storyboard: UIStoryboard {
        switch self {
        case .login:
            return UIStoryboard(name: "Login", bundle: nil)
        case .main, .preparationScreen:
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }

    private var controller: UIViewController {
        return storyboard.instantiateViewController(withIdentifier: rawValue)
    }

    // MARK: - Public

    func change() {
        UIApplication.shared.keyWindow?.rootViewController = controller
    }

    func initializeWindow(_ window: UIWindow?) {
        window?.makeKeyAndVisible()
        window?.rootViewController = controller
    }
}
