//
//  CryptorManager.swift
//  FSSCamera
//
//  Created by Truc Pham on 15/08/2023.
//

import Foundation
class CryptorManager {
    static let shared : CryptorManager = .init()
    static let iterationKey = "iterationKey"
    @Storage(key: CryptorManager.iterationKey, defaultValue: 100)
    var iterationLocal : Int
    init() {
        RNCryptor.iteration = self.iterationLocal
    }
    
    /// Description
    /// - Parameter value: value description
//    func upgradeIterationValue(value:Int){
//        if value != iterationLocal{
//            //Bước 1: Lấy token lưu trong bộ nhớ máy theo giá trị iterationLocal cũ
//
//            let tokenDecryptOld:String = ISCSession.getTokenDecrypt()
//            if tokenDecryptOld == "" {
//                //Bước 2: lưu lại giá trị iteration mới
//                self.iterationLocal = value
//                RNCryptor.iteration = self.iterationLocal
//                UserDefaults.standard.setValue(value: String(value), key: CryptorManager.iterationKey)
//                return
//            }
//
//            //Bước 2: lưu lại giá trị iteration mới
//            self.iterationLocal = value
//            RNCryptor.iteration = self.iterationLocal
//            UserDefaults.standard.setValue(value: String(value), key: CryptorManager.iterationKey)
//
//            //Bước 3: Lưu lại token encrypt theo giá trị iteration mới
//            ISCSession.update(key: ISCSession.tokenKey, value: encrypt(plainText: tokenDecryptOld, password: Common.PUBLIC_KEY))
//        }
//    }
    
    /// Description lamns mã hoá
    /// - Parameters:
    ///   - plainText: plainText description
    ///   - password: password description
    /// - Returns: description
    func encrypt(plainText : String, password: String) -> String {
        if let data: Data = plainText.data(using: .utf8){
            let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
            let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
            return encryptedString
        }
        return ""
    }

    
    /// Description  lamns giải mã
    /// - Parameters:
    ///   - encryptedText: encryptedText description
    ///   - password: password description
    /// - Returns: description
    func decrypt(encryptedText : String, password: String) -> String? {
        do  {
            if let data: Data = Data(base64Encoded: encryptedText){
                // Just get data from encrypted base64Encoded string.
                let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
                let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
                return decryptedString ?? ""
            }
        }
        catch {
            return nil
        }
        return nil
    }
}
