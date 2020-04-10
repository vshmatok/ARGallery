//
//  AuthService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 11/7/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import FirebaseAuth
import Foundation

// MARK: - Protocol

protocol AuthService: AnyObject {
    func createUser(withEmail email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void)
    func login(withEmail email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void)
    func signOut() -> Bool
}

final class AuthServiceImplementation: AuthService {

    // MARK: - Public

    func createUser(withEmail email: String,
                    password: String,
                    completion: @escaping (Result<User, AuthError>) -> Void) {
          Auth.auth().createUser(withEmail: email, password: password) { user, error in
              if let error = error {
                  completion(.failure(.error(error)))
                  return
              }

              guard let user = user?.user else {
                  completion(.failure(.couldNotGetUser))
                  return
              }

              completion(.success(user))
          }
    }

    func login(withEmail email: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                completion(.failure(.error(error)))
                return
            }

            guard let user = user?.user else {
                completion(.failure(.couldNotGetUser))
                return
            }

            completion(.success(user))
        }
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
