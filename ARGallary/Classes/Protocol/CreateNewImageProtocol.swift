//
//  CreateNewImageProtocol.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

protocol CreateNewImageBaseView: AnyObject {
    func configureWith(model: CreateImageModel, delegate: CreateNewImageDelegate)
}

protocol CreateNewImageDelegate: AnyObject {
    func didSelectImage()
    func didSelectVideo()
}

protocol CreateNewImageBaseCellProtocol {
    var cellIdentifier: String { get }
}
