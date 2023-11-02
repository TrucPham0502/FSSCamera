//
//  Nothing.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
struct Nothing: Codable, Hashable {
    init() {}
    static var nothing: Nothing { return .init() }
}
