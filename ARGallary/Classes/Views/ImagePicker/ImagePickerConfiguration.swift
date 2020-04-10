//
//  ImagePickerConfiguration.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

// MARK: - Configuration

enum ImagePickerConfiguration {
    // MARK: - Cases

    case photo
    case video
    case both

    // MARK: - Public

    func getMediaTypes() -> [String] {
        switch self {
        case .photo:
            return ["public.image"]
        case .video:
            return ["public.movie"]
        case .both:
            return ["public.image", "public.movie"]
        }
    }
}
