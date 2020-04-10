//
//  Collection+Safe.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/21/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
