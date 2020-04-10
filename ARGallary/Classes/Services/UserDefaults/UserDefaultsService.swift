//
//  UserDefaultsService.swift
//  ARGallary
//
//  Created by Vlad Shmatok on 10/30/19.
//  Copyright © 2019 Vlad Shmatok. All rights reserved.
//

import Foundation

struct UserDefaultsUtils {
    static func setValueForKey<T>(_ key: UserDefaultsKey, _ value: T) {
        UserDefaults.standard.setValue(value, forKey: key.compositeKey)
        UserDefaults.standard.synchronize()
    }

    static func removeObjectForKey(_ key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.compositeKey)
    }

    static func getValueForKey<T>(_ key: UserDefaultsKey) -> T? {
        return UserDefaults.standard.value(forKey: key.compositeKey) as? T
    }

    static func getCodableValueForKey<T: Codable>(_ key: UserDefaultsKey, type: T.Type) -> T? {
        guard let data = UserDefaults.standard.value(forKey: key.compositeKey) as? Data,
              let value = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }

        return value
    }
}
