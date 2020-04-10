//
//  FirebaseError.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/22/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

enum DatabaseError: LocalizedError {
    // MARK: - Cases

    case common(Error)
    case snapshotNotExist(route: String)
    case parsingError

    // MARK: - LocalizedError

    var errorDescription: String? {
        let firebaseError = "Firebase Service Error: "
        switch self {
        case .common(let error):
            return firebaseError + error.localizedDescription
        case .snapshotNotExist(let route):
            return firebaseError + "snapshot dont exits at \(route)"
        case .parsingError:
            return firebaseError + "failed to parse"
        }
    }
}
