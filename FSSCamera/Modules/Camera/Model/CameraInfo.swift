//
//  CameraInfo.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
struct CameraInfo {
    let password : String
    let username : String
    let name : String
    let channelObj: ChannelObj?
    struct ChannelObj {
        let channels: [Channel]
        let defaultChannel: Int
    }
    
    struct Channel {
        let stream: Int?
        let label: String?
    }
}
