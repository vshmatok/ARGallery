//
//  AuthServiceError.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/7/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

// MARK: - Error

enum AuthError: LocalizedError {
    // MARK: - Cases

    case error(Error)
    case couldNotGetUser

    // MARK: - LocalizedError

    var errorDescription: String? {
        let baseError = "AuthService error: "

        switch self {
        case .error(let error):
            return baseError + error.localizedDescription
        case .couldNotGetUser:
            return baseError + "could not get user"
        }
    }
}
