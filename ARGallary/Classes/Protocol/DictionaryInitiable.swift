//
//  DictionaryInitiable.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/29/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

protocol DictionaryInitiable {
    init(dictionary: [AnyHashable: Any]) throws
}
