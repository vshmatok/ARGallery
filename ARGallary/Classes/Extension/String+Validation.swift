//
//  String+Validation.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/7/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

extension String {
    func hasValidEmail() -> Bool {
        return self.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }

    func hasValidPassword() -> Bool {
        return self.count > 4
    }
}
