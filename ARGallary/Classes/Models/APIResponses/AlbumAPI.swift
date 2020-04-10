//
//  AlbumAPI.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/25/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

class AlbumsApiModel: DictionaryInitiable {
    // MARK: - Properties

    var albums: [AlbumModel]

    // MARK: - Init

    required init(dictionary: [AnyHashable: Any]) throws {
       albums = try dictionary.values.map({ try AlbumModel(dictionary: $0) })
    }
}

class AlbumModel: DictionaryInitiable {
    // MARK: - Properties

    let name: String
    var content: [String: String] = [: ]

    // MARK: - Init

    init(name: String, content: [String: String]) {
        self.name = name
        self.content = content
    }

    required init(dictionary: [AnyHashable: Any]) throws {
        guard let name = dictionary["name"] as? String else {
            throw DatabaseError.parsingError
        }

        self.name = name

        if let content = dictionary["content"] as? [String: String] {
            self.content = content
        }
    }

    init(dictionary: Any) throws {
        if let dictionary = dictionary as? [AnyHashable: Any] {
            guard let name = dictionary["name"] as? String else {
                throw DatabaseError.parsingError
            }

            self.name = name

            if let content = dictionary["content"] as? [String: String] {
                self.content = content
            }
        } else {
            throw DatabaseError.parsingError
        }
    }
}
