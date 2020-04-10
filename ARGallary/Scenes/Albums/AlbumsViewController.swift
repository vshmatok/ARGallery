//
//  AlbumsViewController.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/21/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

// MARK: - Local constants

private struct LocalConstants {
    static let cellIdentifier: String = "AlbumCell"
}

class AlbumsViewController: UIViewController, Loadable, Alertable {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let firebaseManager = FirebaseManager()

    private var dataSource: [AlbumViewModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAlbums()
    }

    // MARK: - IBActions

    @IBAction private func didTappedDismissButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTappedAddButton(_ sender: UIBarButtonItem) {
        let model = InputAlertModel(title: "Create new Album",
                                    message: "Plese, write name of the album",
                                    textFieldPlaceholder: "Album name") { [weak self] text in
                                        self?.createNewAlbumWith(name: text)
        }
        showInputAlert(model: model)
    }

    @IBAction private func didTappedLogoutButton(_ sender: UIButton) {
        firebaseManager.signOut()
        ApplicationRouter.login.change()
    }

    // MARK: - Private

    private func fetchAlbums() {
        showLoader(contentView: view)
        firebaseManager.fetchAlbums { [weak self] result in
            guard let self = self else {
                 return
             }

            self.hideLoader()

            switch result {
            case let .success(response):
                self.dataSource = response.albums.map({ AlbumViewModel(apiModel: $0) })
                self.tableView.reloadData()
            case let .failure(error):
                self.showErrorWith(contentView: self.view, status: error.localizedDescription)
            }
        }
    }

    private func createNewAlbumWith(name: String?) {
        guard let name = name,
            !dataSource.contains(where: { $0.name == name }) else {
                showErrorWith(contentView: view, status: "Could not create album")
            return
        }

        showLoader(contentView: view)
        firebaseManager.createNewAlbum(model: .init(name: name)) { [weak self] result in
            guard let self = self else {
                return
            }

            self.hideLoader()

            switch result {
            case .success:
                self.showSuccessWith(contentView: self.view, status: "Album successfully created")
                self.fetchAlbums()
            case let .failure(error):
                self.showErrorWith(contentView: self.view, status: error.localizedDescription)
            }
        }
    }

    private func deleteAlbum(at indexPath: IndexPath) {
        let model = dataSource[indexPath.row]

        guard !model.isSeleted else {
            showErrorWith(contentView: view, status: "Could not delete selected album")
            return
        }

        showLoader(contentView: view)
        firebaseManager.deleteAlbum(album: model.name) { [weak self] result in
            guard let self = self else {
                return
            }

            self.hideLoader()

            switch result {
            case .success:
                self.dataSource.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Album deleted")
            case .failure(let error):
                self.showErrorWith(contentView: self.view, status: error.localizedDescription)
            }
        }
    }

    private func changeToAlbum(name: String) {
        showLoader(contentView: view)
        ARConfigService.shared.prepareARConfig(for: name) { [weak self] failed in
            guard let self = self else { return }
            self.hideLoader()
            if failed {
                self.showErrorWith(contentView: self.view, status: "Failed to change album")
            } else {
                UserDefaultsUtils.setValueForKey(.selectedAlbum, name)
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocalConstants.cellIdentifier)
        let model = dataSource[indexPath.row]

        cell?.textLabel?.text = model.name
        cell?.accessoryType = model.isSeleted ? .checkmark : .none

        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]

        guard ARConfigService.shared.selectedAlbum?.name != model.name else {
            return
        }

        changeToAlbum(name: model.name)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAlbum(at: indexPath)
        }
    }
}
