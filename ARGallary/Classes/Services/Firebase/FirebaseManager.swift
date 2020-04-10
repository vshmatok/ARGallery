//
//  FirebaseManager.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/25/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Firebase
import Foundation

final class FirebaseManager {
    // MARK: - Properties

    private let databaseService: DatabaseService
    private let storageService: StorageService
    private let authService: AuthService

    // MARK: - Initialization

    init(storageService: StorageService, databaseService: DatabaseService, authService: AuthService) {
        self.storageService = storageService
        self.databaseService = databaseService
        self.authService = authService
    }

    init() {
        self.storageService = StorageServiceImplementation()
        self.databaseService = DatabaseServiceImplementation()
        self.authService = AuthServiceImplementation()
    }

    // MARK: - Public

    func createUser(withEmail email: String,
                    password: String,
                    completion: @escaping (Result<User, AuthError>) -> Void) {
        authService.createUser(withEmail: email, password: password, completion: completion)
    }

    func login(withEmail email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        authService.login(withEmail: email, password: password, completion: completion)
    }

    @discardableResult
    func signOut() -> Bool {
        if authService.signOut() {
            UserDefaultsUtils.removeObjectForKey(.isAuthorized)
            return true
        } else {
            return false
        }
    }

    func fetchAlbums(completion: @escaping (Result<AlbumsApiModel, DatabaseError>) -> Void) {
        let route = DatabaseRouter.albums.rawValue
        databaseService.fetch(route: route, completion: completion)
    }

    func fetchAlbum(album: String, completion: @escaping (Result<AlbumModel, DatabaseError>) -> Void) {
        let route = "\(DatabaseRouter.albums)/\(album)"
        databaseService.fetch(route: route, completion: completion)
    }

    func deleteAlbum(album: String, completion: @escaping (Result<VoidResponse, FirebaseManagerError>) -> Void) {
        let route = "\(DatabaseRouter.albums)/\(album)"

        databaseService.removeValue(route: route) { result in
            switch result {
            case .success:
                completion(.success(VoidResponse()))
            case let .failure(error):
                completion(.failure(.failedToDelete(error)))
            }
        }
    }

    func createNewAlbum(model: CreateAlbumModel,
                        completion: @escaping (Result<DatabaseReference, DatabaseError>) -> Void) {
        let route = "\(DatabaseRouter.albums)/\(model.name)"
        databaseService.setValue(route: route, value: model.parameters, completion: completion)
    }

    func downloadPhotosFrom(album: String, completion: @escaping (Result<[URL], StorageError>) -> Void) {
        let route = "\(album)/\(StorageRouter.photos.rawValue)"
        storageService.downloadFiles(route: route, folder: .image, completion: completion)
    }

    func uploadContent(album: String,
                       content: CreateImageModel,
                       completion: @escaping (Result<VoidResponse, FirebaseManagerError>) -> Void) {
        let group = DispatchGroup()

        let imageName = UUID().uuidString
        let videoName = UUID().uuidString + ".mov"

        let imageRoute = album + "/" + StorageRouter.photos.rawValue
        let videoRoute = album + "/" + StorageRouter.video.rawValue

        var savedVideoURL: URL?

        var failed = false

        guard let image = content.selectedImage,
            let imageData = image.jpegData(compressionQuality: 0.5),
            let videoURL = content.selectedVideoURL,
            let videoData = try? Data(contentsOf: videoURL) else {
                completion(.failure(.couldNotGetContentData))
                return
        }

        group.enter()
        storageService.uploadToServer(model: .init(fileName: imageName,
                                                   fileData: imageData),
                                      route: imageRoute) { result in
            switch result {
            case .success:
                print("Successfully saved image")
            case let .failure(error):
                print("Failed to save image: \(error.localizedDescription)")
                failed = true
            }
            group.leave()
        }

        group.enter()
        storageService.uploadToServer(model: .init(fileName: videoName,
                                                   fileData: videoData),
                                      route: videoRoute) { result in
            switch result {
            case let .success(url):
                savedVideoURL = url
                print("Successfully saved image")
            case let .failure(error):
                print("Failed to save video: \(error.localizedDescription)")
                failed = true
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            if !failed {
                self?.saveToDatabase(album: album,
                                     imageName: imageName,
                                     videoURL: savedVideoURL?.absoluteString ?? "",
                                     completion: completion)
            } else {
                completion(.failure(.failedToSave))
            }
        }
    }

    // MARK: - Private

    private func saveToDatabase(album: String,
                                imageName: String,
                                videoURL: String,
                                completion: @escaping (Result<VoidResponse, FirebaseManagerError>) -> Void) {
        let route = "\(DatabaseRouter.albums.rawValue)/\(album)/content/\(imageName)"

        databaseService.setValue(route: route, value: videoURL) { result in
            switch result {
            case .success:
                completion(.success(VoidResponse()))
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(.failedToSave))
            }
        }
    }
}
