//
//  CreatePhotoViewController.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/9/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import AVFoundation
import UIKit

class CreatePhotoViewController: UIViewController, Loadable {
    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var saveButton: UIBarButtonItem!

    // MARK: - Properties

    private var imagePicker: ImagePicker!

    private let dataSource: [CreateNewImageBaseCellProtocol] = [ChoosePhotoCollectionViewCellModel(),
                                                                ChooseVideoCollectionViewCellModel()]
    private let model = CreateImageModel()

    private let firebaseManager = FirebaseManager()
    private let fileSystemService = FileSystemService()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()

        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }

    // MARK: - IBActions

    @IBAction private func didTappedPreviousButton(_ sender: UIButton) {
        guard let visibleCellIndexPath = indexPathOfVisibleCell() else {
            return
        }

        collectionView.safeScrollToItem(at: IndexPath(item: visibleCellIndexPath.row - 1,
                                                      section: visibleCellIndexPath.section),
                                        at: .centeredHorizontally,
                                        animated: true)
    }

    @IBAction private func didTappedNextButton(_ sender: UIButton) {
        guard let visibleCellIndexPath = indexPathOfVisibleCell() else {
            return
        }

        collectionView.safeScrollToItem(at: IndexPath(item: visibleCellIndexPath.row + 1,
                                                      section: visibleCellIndexPath.section),
                                        at: .centeredHorizontally,
                                        animated: true)
    }

    @IBAction private func didTappedSaveButton(_ sender: UIBarButtonItem) {
        if let selectedAlbum: String = UserDefaultsUtils.getValueForKey(.selectedAlbum) {
            showLoader(contentView: view)
            firebaseManager.uploadContent(album: selectedAlbum, content: model) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success:
                    self.addToARConfig(model: self.model)
                case let .failure(error):
                    self.hideLoader()
                    self.showErrorWith(contentView: self.view, status: error.localizedDescription)
                }
            }
        } else {
            showErrorWith(contentView: view,
                          status: "There is no Albums or Album not selected.\nCould not create image without album.")
        }
    }

    @IBAction private func didTappedDismissButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private

    private func addToARConfig(model: CreateImageModel) {
        guard let image = model.selectedImage,
            let videoURL = model.selectedVideoURL?.absoluteString else {
                hideLoader()
                dismiss(animated: true, completion: nil)
                return
        }

        ARConfigService.shared.addReferenceImage(image: image, videoURL: videoURL) { [weak self] in
            self?.hideLoader()
            self?.dismiss(animated: true, completion: nil)
        }
    }

    private func registerCells() {
        collectionView.registerNib(cellTypes: ChoosePhotoCollectionViewCell.self,
                                   ChooseVideoCollectionViewCell.self)
    }

    private func reloadData() {
        collectionView.reloadData()
    }

    private func configureControllButtonsForVisibleCellWith(indexPath: IndexPath) {
        guard dataSource.count > 1 else {
            controllButton(previousButton, isEnabled: false)
            controllButton(nextButton, isEnabled: false)
            return
        }

        if indexPath.row == 0 {
            controllButton(previousButton, isEnabled: false)
            controllButton(nextButton, isEnabled: true)
        } else if indexPath.row == dataSource.count - 1 {
            controllButton(previousButton, isEnabled: true)
            controllButton(nextButton, isEnabled: false)
        } else {
            controllButton(previousButton, isEnabled: true)
            controllButton(nextButton, isEnabled: true)
        }
    }

    private func controllButton(_ button: UIButton, isEnabled: Bool) {
        button.isUserInteractionEnabled = isEnabled
        button.alpha = isEnabled ? 1 : 0.5
    }

    private func indexPathOfVisibleCell() -> IndexPath? {
        guard
            let visibleCell = collectionView.visibleCells.first,
            let visibleCellIndexPath = collectionView.indexPath(for: visibleCell) else {
                return nil
        }

        return visibleCellIndexPath
    }

    private func checkSelectedData() {
        let isAllDataSet = model.selectedImage != nil && model.selectedVideoURL != nil
        saveButton.isEnabled = isAllDataSet
    }

    private func configureUI() {
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        previousButton.layer.cornerRadius = previousButton.frame.height / 2
    }
}

// MARK: - UICollectionViewDataSource

extension CreatePhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = dataSource[indexPath.row].cellIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath)

        if let view = cell as? CreateNewImageBaseView {
            view.configureWith(model: model, delegate: self)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate

extension CreatePhotoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width,
                      height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        configureControllButtonsForVisibleCellWith(indexPath: indexPath)
    }
}

// MARK: - CreateNewImageDelegate

extension CreatePhotoViewController: CreateNewImageDelegate {
    func didSelectImage() {
        imagePicker.present(from: view, configuration: .photo)
    }

    func didSelectVideo() {
        imagePicker.present(from: view, configuration: .video)
    }
}

// MARK: - ImagePickerDelegate

extension CreatePhotoViewController: ImagePickerDelegate {
    func didSelect(image: UIImage) {
        model.selectedImage = image
        checkSelectedData()
        reloadData()
    }

    func didSelectVideo(URL: URL) {
        model.selectedVideoURL = URL
        checkSelectedData()
        reloadData()
    }

    func couldNotOpenImagePicker() {
        showErrorWith(contentView: view, status: "Sorry, we cant open this without permissions")
    }

    func couldNotGetMediaContent() {
        showErrorWith(contentView: view, status: "Something went wrong, sorry")
    }
}
