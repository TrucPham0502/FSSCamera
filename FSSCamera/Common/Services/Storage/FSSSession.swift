//
//  FSSSession.swift
//  FSSCamera
//
//  Created by Truc Pham on 19/08/2023.
//  Copyright © 2023 FSS Camera. All rights reserved.
//

import Foundation
class FSSSession {
    static let shared : FSSSession = .init()
    static let (TOKEN_KEY, PHONE_NUMBER_KEY, IS_UPDATE_KEY, AVATAR_KEY, ACCOUNT_KEY, TOPICS_KEY) = ("TOKEN_KEY", "PHONE_NUMBER_KEY", "IS_UPDATE_KEY", "AVATAR_KEY", "ACCOUNT_KEY", "TOPICS_KEY")
    static let USER_SESSIONKEY = "FSS.CAMERA.SAVE.USER_LOGIN"
    var tokenValidOTP = ""//token của validate otp trả về lưu lại để khi forgot pass khẩu or đăng ký thì vẫn chưa login nên ISCSession có giá trị là nil, chỉ khi đăng nhập thì biến này chính là token của ISCSession
    struct Model : Codable {
        var token: String?
        var phone: String?
        var isUpdate: Bool?
        var avatar: String?
        var account: String?
        var topics: String?
    }
    @Storage(key: FSSSession.USER_SESSIONKEY, defaultValue: nil)
    var data : Model?
    
    
    func save(data : Model) {
        var data = data
        if let phone = data.phone, !phone.isEmpty{
            if !(phone.contains("+" + Constants.countryCode)){
                data.phone = "+" + Constants.countryCode + phone
            }
            CMRCoreDataManager.shared.saveUserLogin(phone)
            //lamnhs thêm trường phone number vào các table ISC_CAMERA và ISC_CAMERA_MOMENT nếu trường phone number là null
            CMRCoreDataManager.shared.updateObjectPhoneNumber(phone)
        }
        self.data = data
    }
    
    func clearUserData(){
        //xoá lastview khi logout
        if let userLogin = data, let phone = userLogin.phone, !phone.isEmpty {
//            CMRCoreDataManager.shared.removeAllLastViewMode(phoneNumber: phone)
        }
        Storage.remove(key: FSSSession.USER_SESSIONKEY)
    }
}
