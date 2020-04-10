//
//  FileSystemError.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/23/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

enum FileSystemError: LocalizedError {
    // MARK: - Cases

    case couldNotGetURL

    // MARK: - LocalizedError

    var errorDescription: String? {
        let fileSystemError = "FileSystem Service Error: "
        switch self {
        case .couldNotGetURL:
            return fileSystemError + "Could not get documents directory URL"
        }
    }
}
