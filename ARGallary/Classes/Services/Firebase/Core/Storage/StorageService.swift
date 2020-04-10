//
//  StorageService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/23/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import FirebaseStorage

// MARK: - Protocol

protocol StorageService: AnyObject {
    func downloadFiles(route: String, folder: Directory, completion: @escaping (Result<[URL], StorageError>) -> Void)
    func uploadToServer(model: UploadModel, route: String, completion: @escaping (Result<URL, StorageError>) -> Void)
}

final class StorageServiceImplementation: StorageService {
    // MARK: - Properties

    private let storage = Storage.storage()
    private let fileSystemService = FileSystemService()

    private var serialQueue = DispatchQueue(label: "serial.Storage", qos: .background)

    // MARK: Private

    func downloadFiles(route: String, folder: Directory, completion: @escaping (Result<[URL], StorageError>) -> Void) {
        let group = DispatchGroup()
        var fileURLArray: [URL] = []
        storage.reference().child(route).listAll { [weak self] list, error in
            if let error = error {
                completion(.failure(.fetchList(error: error)))
                return
            }

            self?.prepareFolder()

            for items in list.items {
                guard let fileURL = self?.fileSystemService.getURL(for: folder)?
                    .appendingPathComponent(items.name) else {
                    return
                }
                group.enter()
                items.write(toFile: fileURL) { url, error in
                    if let error = error {
                        print(StorageError.download(error: error))
                    } else if let url = url {
                        fileURLArray.append(url)
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                completion(.success(fileURLArray))
            }
        }
    }

    func uploadToServer(model: UploadModel, route: String, completion: @escaping (Result<URL, StorageError>) -> Void) {
        let reference = storage.reference().child(route + "/\(model.fileName)")
        reference.putData(model.fileData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(.upload(error: error)))
                return
            }

            reference.downloadURL { url, error in
                if let error = error {
                    completion(.failure(.upload(error: error)))
                    return
                }

                guard let url = url else {
                    return
                }

                completion(.success(url))
            }
        }
    }

    // MARK: - Private

    private func prepareFolder() {
        serialQueue.sync {
            fileSystemService.delete(directory: .image)
            fileSystemService.createDirectoriesIfNeeded()
        }
    }
}
