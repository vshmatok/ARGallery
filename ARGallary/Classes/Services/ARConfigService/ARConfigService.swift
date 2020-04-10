//
//  ARConfigService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/30/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import ARKit
import UIKit

final class ARConfigService {
    // MARK: - Properties

    static let shared = ARConfigService()

    private var firebaseManager = FirebaseManager()

    var referenceImages: Set<ARReferenceImage> = []
    var selectedAlbum: AlbumModel?

    // MARK: - Init

    private init() {}

    // MARK: - Public

    func prepareARConfig(for album: String, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var failed = false

        clear()

        group.enter()
        firebaseManager.downloadPhotosFrom(album: album) { [weak self] result in
            switch result {
            case let .success(response):
                self?.addReferenceImagages(from: response) {
                    group.leave()
                }
            case let .failure(error):
                failed = true
                print(error.localizedDescription)
                group.leave()
            }
        }

        group.enter()
        firebaseManager.fetchAlbum(album: album) { result in
            switch result {
            case let .success(response):
                ARConfigService.shared.selectedAlbum = response
            case let .failure(error):
                failed = true
                print(error.localizedDescription)
            }

            group.leave()
        }

        group.notify(queue: .main) {
            completion(failed)
        }
    }

    func addReferenceImage(image: UIImage, videoURL: String, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let cgImage = image.cgImage {
                let arImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.2)
                let imageName = UUID().uuidString
                arImage.name = imageName

                self?.referenceImages.insert(arImage)
                self?.selectedAlbum?.content["imageName"] = videoURL
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    // MARK: - Private

    private func clear() {
        selectedAlbum = nil
        referenceImages.removeAll()
    }

    private func addReferenceImagages(from urls: [URL], completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            for url in urls {
                if let image = UIImage(contentsOfFile: url.path)?.cgImage {
                    let arImage = ARReferenceImage(image, orientation: .up, physicalWidth: 0.2)
                    arImage.name = url.lastPathComponent
                    self?.referenceImages.insert(arImage)
                }
            }

            DispatchQueue.main.async {
                completion?()
            }

        }
    }
}
