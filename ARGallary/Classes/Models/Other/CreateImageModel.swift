//
//  CreateImageModel.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

final class CreateImageModel {
    // MARK: - View Model

    var selectedImage: UIImage?
    var selectedVideoURL: URL?
}

struct ChoosePhotoCollectionViewCellModel: CreateNewImageBaseCellProtocol {
    var cellIdentifier = String(describing: ChoosePhotoCollectionViewCell.self)
}

struct ChooseVideoCollectionViewCellModel: CreateNewImageBaseCellProtocol {
    var cellIdentifier = String(describing: ChooseVideoCollectionViewCell.self)
}
