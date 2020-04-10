//
//  FirebaseManagerError.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/1/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

enum FirebaseManagerError: LocalizedError {
    // MARK: - Cases

    case couldNotGetContentData
    case failedToSave
    case failedToDelete(Error)

    // MARK: - LocalizedError

    var localizedDescription: String {
        let baseError = "FirebaseManager error: "
        switch self {
        case .couldNotGetContentData:
            return baseError + "Could not get file DATA"
        case .failedToSave:
            return baseError + "Failed to save DATA"
        case .failedToDelete(let error):
            return baseError + "Failed to delete Album: \(error.localizedDescription)"
        }
    }
}
