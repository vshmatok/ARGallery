//
//  ChooseVideoCollectionViewCell.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import AVKit
import UIKit

final class ChooseVideoCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet

    @IBOutlet private weak var videoView: UIImageView!

    // MARK: - Properties

    private var playerViewController = AVPlayerViewController()
    private weak var delegate: CreateNewImageDelegate?

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        playerViewController.player?.pause()
        playerViewController.player = nil
    }

    // MARK: - IBOutlet

    @IBAction private func didTappedSelectVideoButton(_ sender: UIButton) {
        delegate?.didSelectVideo()
    }

    // MARK: - Private

    private func prepareVideo(videoURL: URL) {
        videoView.addSubview(playerViewController.view)
        playerViewController.view.frame = videoView.bounds
        playerViewController.player = AVPlayer(url: videoURL)
    }
}

// MARK: - CreateNewImageBaseView

extension ChooseVideoCollectionViewCell: CreateNewImageBaseView {
    func configureWith(model: CreateImageModel, delegate: CreateNewImageDelegate) {
        self.delegate = delegate

        if let videoURL = model.selectedVideoURL {
            prepareVideo(videoURL: videoURL)
        }
    }
}
