//
//  StorageError.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/25/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

enum StorageError: LocalizedError {
    // MARK: - Cases

    case fetchList(error: Error)
    case download(error: Error)
    case upload(error: Error)
    case delete(error: Error)

    // MARK: - LocalizedError

    var errorDescription: String? {
        let firebaseError = "Storage Service Error: "
        switch self {
        case .fetchList(let error), .download(let error), .upload(let error), .delete(let error):
            return firebaseError + error.localizedDescription
        }
    }
}
