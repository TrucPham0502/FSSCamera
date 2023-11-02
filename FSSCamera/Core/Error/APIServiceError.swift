//
//  APIServiceError.swift
//  FSSCamera
//
//  Created by Truc Pham on 13/08/2023.
//

import Foundation
let kDefaultFunctionName = "UnknownFunctionName"
let kDefaultCustomErrorCode = 0

class APIServiceError: KeyLocalizeError {
    
    override class var errorDomain: String { get { return "APIServiceError" }}
    
    override var errorUserInfo: [String : Any] { get { return [
        "keyLocalize": keyLocalize,
        "functionName": functionName
        ] }}
    
    let customErrorCode: Int
    
    override var errorCode: Int { get { return customErrorCode } }
    
    let functionName: String

    override init(keyLocalize: String = "") {
        self.functionName = kDefaultFunctionName
        self.customErrorCode = kDefaultCustomErrorCode
        super.init(keyLocalize: keyLocalize)
    }
    
    init(keyLocalize: String = "", functionName: String? = kDefaultFunctionName, customErrorCode: Int? = kDefaultCustomErrorCode) {
        self.functionName = functionName ?? kDefaultFunctionName
        self.customErrorCode = customErrorCode ?? kDefaultCustomErrorCode
        super.init(keyLocalize: keyLocalize)
    }
}
