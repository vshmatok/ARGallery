//
//  CreateAlbumModel.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/29/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

struct CreateAlbumModel {
    // MARK: - Properties

    var name: String
    var content: [String: String]?

    var parameters: [String: Any] {
        return ["name": name,
                "content": content ?? NSNull()]
    }
}
