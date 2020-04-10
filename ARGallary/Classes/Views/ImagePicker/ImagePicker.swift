//
//  ImagePicker.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage)
    func didSelectVideo(URL: URL)
    func couldNotOpenImagePicker()
    func couldNotGetMediaContent()
}

final class ImagePicker: NSObject {
    // MARK: - Properties

    private let pickerController: UIImagePickerController
    private let permissionService: PermissionService
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    // MARK: - Initialization

    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        self.permissionService = PermissionService()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
    }

    // MARK: - Public

    func present(from sourceView: UIView, configuration: ImagePickerConfiguration) {
        pickerController.mediaTypes = configuration.getMediaTypes()

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = action(for: .camera, title: "Open camera") {
            alertController.addAction(action)
        }
        if let action = action(for: .photoLibrary, title: "Choose from gallery") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    // MARK: - Private

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            switch type {
            case .photoLibrary, .savedPhotosAlbum:

                self.permissionService.requestPhotoLibraryAccess { result in
                    self.handlePermissionRequestResult(result: result, for: type)
                }

            case .camera:

                self.permissionService.requestPermissionToFullPermissionToCamera { result in
                    self.handlePermissionRequestResult(result: result, for: type)
                }

            @unknown default:
                fatalError()
            }
        }
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage) {
        controller.dismiss(animated: true, completion: nil)

        delegate?.didSelect(image: image)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect video: URL) {
        controller.dismiss(animated: true, completion: nil)

        delegate?.didSelectVideo(URL: video)
    }

    private func handlePermissionRequestResult(result: (Result<Bool, PermissionError>),
                                               for type: UIImagePickerController.SourceType) {
        switch result {
        case .success:

            pickerController.sourceType = type
            presentationController?.present(pickerController, animated: true)

        case .failure:

            delegate?.couldNotOpenImagePicker()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            pickerController(picker, didSelect: image)
        } else if let videoURL = info[.mediaURL] as? URL {
            pickerController(picker, didSelect: videoURL)
        } else {
            delegate?.couldNotGetMediaContent()
        }
    }
}
