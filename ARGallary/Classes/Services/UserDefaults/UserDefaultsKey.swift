//
//  UserDefaultsKey.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/30/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
    // MARK: - Cases

    case selectedAlbum
    case isAuthorized

    // MARK: - Properties

    var compositeKey: String {
        return "\(rawValue)"
    }
}
