//
//  ClassName+Extension.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/17/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return String(describing: type(of: self))
    }
}
