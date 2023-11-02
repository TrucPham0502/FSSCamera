//
//  CameraInfoRequest.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
struct CameraInfoRequest : Codable {
    let serialList: [String]
    let appVersion, deviceName: String?
    let mode : Mode

    enum CodingKeys: String, CodingKey {
        case serialList = "serial_list"
        case appVersion = "app_version"
        case deviceName = "device_name"
        case mode
    }
    enum Mode : String, Codable {
        case single = "single"
        case grid = "grid"
    }

}
