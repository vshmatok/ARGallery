//
//  AlbumViewModel.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/29/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

class AlbumViewModel {
    // MAKR: - Properties

    var name: String
    var content: [String: String]

    var isSeleted: Bool {
        return ARConfigService.shared.selectedAlbum?.name == name
    }

    // MARK: Init

    init(apiModel: AlbumModel) {
        self.name = apiModel.name
        self.content = apiModel.content
    }
}
