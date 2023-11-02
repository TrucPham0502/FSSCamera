//
//  ErrorKey.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation

enum ErrorKey: String {
    // Reachability Error
    case notConnectedToInternet
    case networkConnectionLost
    case cannotConnectToHost
    case timedOut
    
    case commonConnectionError
    
    // Server Error (>=500)
    case fiveXXHTTP
    
    // Client Error (400 <= x < 500)
    case fourXXHTTP
    case unauthorized
    
    // Data Response Error (json)
    case invalidJSONData
    
    // General Message
    case generalErrorMessage
}
