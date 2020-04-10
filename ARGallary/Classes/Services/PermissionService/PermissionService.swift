//
//  PermissionService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/15/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import AVFoundation
import Photos

final class PermissionService {
    func requestMicrophonePermission(completion: @escaping (Result<Bool, PermissionError>) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                guard granted else {
                    return completion(.failure(.couldNotReceiveMicrophonePermission))
                }
                completion(.success(true))
            }
        }
    }

    func requestPhotoLibraryAccess(completion: @escaping (Result<Bool, PermissionError>) -> Void) {
        PHPhotoLibrary.requestAuthorization { authorizatioStatus in
            DispatchQueue.main.async {
                guard authorizatioStatus == .authorized else {
                    return completion(.failure(.couldNotReceiveLibraryPermission))
                }
                completion(.success(true))
            }
        }
    }

    func requestPermissionToCamera(completion: @escaping (Result<Bool, PermissionError>) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                guard granted else {
                    return completion(.failure(.couldNotReceiveCameraPermission))
                }
                completion(.success(true))
            }
        }
    }

    func requestPermissionToFullPermissionToCamera(completion: @escaping (Result<Bool, PermissionError>) -> Void) {
        requestPermissionToCamera { [weak self] result in
            switch result {
            case .success:

                self?.requestMicrophonePermission(completion: { result in
                    switch result {
                    case .success:
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
