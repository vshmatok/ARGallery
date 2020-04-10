//
//  AlertModel.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/21/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

struct AlertModel {
    let title: String?
    let message: String?
    let style: UIAlertController.Style

    let actions: [ActionModel]
}

struct ActionModel {
    let title: String?
    let style: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
}

struct InputAlertModel {
    let title: String?
    let message: String?
    let textFieldPlaceholder: String?
    let handler: ((String?) -> Void)?
}
