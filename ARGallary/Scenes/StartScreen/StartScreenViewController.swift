//
//  StartScreenViewController.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/30/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController, Loadable {
    // MARK: - IBOutlet

    @IBOutlet private weak var statusLabel: UILabel!

    // MARK: - Properties

    private var firebaseManager: FirebaseManager!
    private var fileSystemService: FileSystemService!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseManager = FirebaseManager()
        fileSystemService = FileSystemService()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureARConfig()
    }

    // MARK: - Private

    private func configureARConfig() {
        if let selectedAlbum: String = UserDefaultsUtils.getValueForKey(.selectedAlbum) {
            ARConfigService.shared.prepareARConfig(for: selectedAlbum) { [weak self] _ in
                self?.changeRootController()
            }
        } else {
            changeRootController()
        }
    }

    private func changeRootController() {
        ApplicationRouter.main.change()
    }
}
