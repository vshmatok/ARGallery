//
//  PermissionErrors.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

// MARK: - Permission error

enum PermissionError: LocalizedError {
    case couldNotReceiveMicrophonePermission
    case couldNotReceiveCameraPermission
    case couldNotReceiveLibraryPermission

    var errorDescription: String? {
        switch self {
        case .couldNotReceiveMicrophonePermission:
            return "Could access microphone permissions"
        case .couldNotReceiveCameraPermission:
            return "Could access camera permissions"
        case .couldNotReceiveLibraryPermission:
            return "Could access library permissions"
        }
    }
}
