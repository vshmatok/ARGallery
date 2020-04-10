//
//  DatabaseService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/22/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Firebase
import Foundation

// MARK: - Protocol

protocol DatabaseService: AnyObject {
    func fetch<T: DictionaryInitiable>(route: String,
                                       completion: @escaping (Result<T, DatabaseError>) -> Void)
    func setValue(route: String,
                  value: Any,
                  completion: @escaping (Result<DatabaseReference, DatabaseError>) -> Void)
    func removeValue(route: String,
                     completion: @escaping (Result<DatabaseReference, DatabaseError>) -> Void)
}

final class DatabaseServiceImplementation: DatabaseService {
    // MARK: - Properties

    private let reference = Database.database().reference()

    // MARK: - Public

    // MARK: - Private

    func fetch<T: DictionaryInitiable>(route: String,
                                       completion: @escaping (Result<T, DatabaseError>) -> Void) {
        reference.child(route).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(),
                let snapshotValue = snapshot.value as? [AnyHashable: Any] else {
                    completion(.failure(.snapshotNotExist(route: route)))
                    return
            }

            do {
                let serializedValue = try T(dictionary: snapshotValue)
                completion(.success(serializedValue))
            } catch {
                completion(.failure(.parsingError))
            }
        }
    }

    func setValue(route: String,
                  value: Any,
                  completion: @escaping (Result<DatabaseReference, DatabaseError>) -> Void) {
        reference.child(route).setValue(value) { error, reference in
            if let error = error {
                completion(.failure(.common(error)))
                return
            }
            completion(.success(reference))
        }
    }

    func removeValue(route: String,
                     completion: @escaping (Result<DatabaseReference, DatabaseError>) -> Void) {
        reference.child(route).removeValue { error, reference in
            if let error = error {
                completion(.failure(.common(error)))
                return
            }
            completion(.success(reference))
        }
    }
}
