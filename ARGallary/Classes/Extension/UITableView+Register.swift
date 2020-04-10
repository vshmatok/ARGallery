//
//  UITableView+Register.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/17/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

extension UITableView {
    func register(cellTypes: UITableViewCell.Type...) {
        cellTypes.forEach {
            let reuseIdentifier = $0.className
            register($0, forCellReuseIdentifier: reuseIdentifier)
        }
    }
}
