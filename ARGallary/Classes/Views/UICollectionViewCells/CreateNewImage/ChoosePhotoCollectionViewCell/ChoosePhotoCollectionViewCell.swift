//
//  ChoosePhotoCollectionViewCell.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

final class ChoosePhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets

    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Properties

    private weak var delegate: CreateNewImageDelegate?

    // MARK: - IBAction

    @IBAction private func didTapSelectPhotoButton(_ sender: UIButton) {
        delegate?.didSelectImage()
    }
}

// MARK: - CreateNewImageBaseView

extension ChoosePhotoCollectionViewCell: CreateNewImageBaseView {
    func configureWith(model: CreateImageModel, delegate: CreateNewImageDelegate) {
        self.delegate = delegate
        imageView.image = model.selectedImage ?? UIImage(named: "photo_placeholder")
    }
}
