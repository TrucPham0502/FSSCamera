//
//  Storage.swift
//  FSSCamera
//
//  Created by Truc Pham on 14/08/2023.
//

import Foundation
@propertyWrapper
struct Storage<T: Codable> {
    static func getGroup(group: String?) -> UserDefaults? {
        if let group = group { return  UserDefaults(suiteName: group) }
        else { return UserDefaults.standard }
    }
   
    static func set(data : T, key: String, group: String? = nil) {
        let save = try? JSONEncoder().encode(data)
        getGroup(group: group)?.set(save, forKey: key)
    }
    static func get(key: String, group: String? = nil) -> T? {
        guard let data = getGroup(group: group)?.object(forKey: key) as? Data else {
            return nil
        }
        let value = try? JSONDecoder().decode(T.self, from: data)
        return value
    }
    
    private let key: String
    private let defaultValue: T
    private let group: String?

    init(key: String, defaultValue: T, group: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.group = group
    }

    var wrappedValue: T {
        get {
            return Storage<T>.get(key: key, group: group) ?? defaultValue
        }
        set {
            Storage<T>.set(data: newValue, key: key, group: group)
        }
    }
}
extension Storage<Nothing> {
    static func remove(key: String, group: String? = nil) {
        getGroup(group: group)?.removeObject(forKey: key)
    }
}
@propertyWrapper
struct EncryptedStringStorage {

    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String {
        get {
            // Get encrypted string from UserDefaults
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            // Encrypt newValue before set to UserDefaults
            let encrypted = encrypt(value: newValue)
            UserDefaults.standard.set(encrypted, forKey: key)
        }
    }

    private func encrypt(value: String) -> String {
        // Encryption logic here
        return String(value.reversed())
    }
}
