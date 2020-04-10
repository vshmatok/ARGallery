//
//  UICollectionView+SafeScroll.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/21/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

extension UICollectionView {
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0 &&
            indexPath.section >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.item < numberOfItems(inSection: indexPath.section) else {
                return
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
}
