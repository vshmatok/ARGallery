//
//  UICollectionView+Register.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/17/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerClass(cellTypes: UICollectionViewCell.Type...) {
        cellTypes.forEach {
            let reuseIdentifier = $0.className
            register($0, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }

    func registerNib(cellTypes: UICollectionViewCell.Type...) {
        cellTypes.forEach {
            let reuseIdentifier = $0.className
            register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
}
