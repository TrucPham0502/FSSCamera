//
//  KeyLocalizeError.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
class KeyLocalizeError: Error, CustomNSError {
    var keyLocalize: String = "generalErrorMessage"
    
//    class var errorDomain: String { get { return String(describing: type(of: self)) }}
    
    class var errorDomain: String { get { return "FSS" }}
    
    var errorUserInfo: [String : Any] { get { return ["keyLocalize": keyLocalize] }}
    
    var errorCode: Int { get { return 0 } }
    
    init(keyLocalize: String = "generalErrorMessage") {
        self.keyLocalize = keyLocalize
    }
    
    init() {
        
    }
}
