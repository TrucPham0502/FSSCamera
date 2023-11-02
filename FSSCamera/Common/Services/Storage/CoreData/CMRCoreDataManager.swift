//
//  CMRCoreDataManager.swift
//  ISCCamera
//
//  Created by Truc Pham on 23/09/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
//import Realm
class CMRCoreDataManager {
    static let shared : CMRCoreDataManager = .init()
    private let coreDataManager = CoreDataManager.shared
    private var contextManager : ContextManager {
        coreDataManager.contextManager
    }
    
//    func migrationRealmDB(){
//        let realmURl = RLMRealmConfiguration.default().fileURL
//        let fileManager = FileManager.default
//        if let url = realmURl, fileManager.fileExists(atPath: url.path) {
//            // Migration User Login
//            if let _users = ISCRealManager.shared().getAllUser() as? [Dictionary<String, String>] {
//                _users.forEach({ d in
//                    let u = contextManager.build(object: CMRUserLogin.self)
//                    u.PHONE_NUMBER = d["PHONE_NUMBER"]
//                    u.TIME_DISSMISS_BANNER_HOME = d["TIME_DISSMISS_BANNER_HOME"]
//                    u.TIME_DISSMISS_BANNER_LIVE_STREAM = d["TIME_DISSMISS_BANNER_LIVE_STREAM"]
//                    u.TOTAL_DEVICE_IN_PAGE = d["TOTAL_DEVICE_IN_PAGE"]
//                })
//                contextManager.saveContext()
//            }
//
//            // Migration Camera Moment
//            if let _moments = ISCRealManager.shared().getAllCameraMoment() as? [Dictionary<String, String>] {
//                _moments.forEach({ d in
//                    let id : NSNumber = {
//                        if let myInteger = Int(d["ID"] ?? "0") {
//                            return NSNumber(value: myInteger)
//                        }
//                        return 0
//                    }()
//                    let u = contextManager.build(object: CMRCameraMoment.self)
//                    u.ID =  id
//                    u.PHONE_NUMBER = d["PHONE_NUMBER"]
//                    u.SERIALNO = d["SERIALNO"]
//                    u.CAMERANAME = d["CAMERANAME"]
//                    u.LINK = d["LINK"]
//                    u.THUMNAIL = d["THUMNAIL"]
//                    u.TYPE = d["TYPE"]
//                    u.CREATED_DISPLAY = d["CREATED_DISPLAY"]
//                    u.CREATED =  d["CREATED"]
//                    u.JSON_DATA = d["JSON_DATA"]
//                })
//                contextManager.saveContext()
//            }
//
//            // Migration Camera
//            if let _camera = ISCRealManager.shared().getAllCamera() as? [Dictionary<String, String>] {
//                _camera.forEach({ d in
//                    let u = contextManager.build(object: CMRCamera.self)
//                    u.PHONE_NUMBER = d["PHONE_NUMBER"]
//                    u.SERIALNO = d["SERIALNO"]
//                    u.NAME = d["NAME"]
//                    u.MAC = d["MAC"]
//                    u.WIFINAME = d["WIFINAME"]
//                    u.IP = d["IP"]
//                    u.PORT = d["PORT"]
//                    u.MODEL =  d["MODEL"]
//                    u.TYPE = d["TYPE"]
//                    u.LASTIMAGE = d["LASTIMAGE"]
//                    u.LASTIMAGETIME =  d["LASTIMAGETIME"]
//                    u.JSON_DATA = d["JSON_DATA"]
//
//                })
//                contextManager.saveContext()
//            }
//
//            // save change
//            contextManager.mergeChangesFromMainContext()
//
//            // Delete Realm DB
//            do {
//                try fileManager.removeItem(atPath: url.path)
//            }
//            catch let err {
//                print("An error took place: \(err)")
//            }
//        }
//
//    }
    
    
    func saveUserLogin(_ phoneNumber: String) {
        guard !phoneNumber.isEmpty, self.getUserLogin(phoneNumber) == nil  else { return }
        let newUser = contextManager.build(object: CMRUserLogin.self)
        newUser.PHONE_NUMBER = phoneNumber
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func getUserLogin(_ phoneNumber : String) -> CMRUserLogin? {
        return CoreDataManager.Objects<CMRUserLogin>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@", phoneNumber)).fetch().first
    }
    
    func getUserLoginTimeDissmissBannerHomeByPhone(_ phoneNumber: String) -> String? {
        guard let user = getUserLogin(phoneNumber) else { return nil }
        return user.TIME_DISSMISS_BANNER_HOME
    }
    
    func getUserLoginTimeDissmissBannerLiveStreamByPhone(_ phoneNumber : String) -> String? {
        guard let user = getUserLogin(phoneNumber) else { return nil }
        return user.TIME_DISSMISS_BANNER_LIVE_STREAM
    }
    
    func getUserLoginTotalDeviceInPageByPhone(_ phoneNumber : String) -> String? {
        guard let user = getUserLogin(phoneNumber) else { return nil }
        return user.TOTAL_DEVICE_IN_PAGE
    }
    
    func setUserLoginTimeDissmissBannerHomeByPhone(_ phoneNumber : String, timeDissmiss: String) {
        guard let user = getUserLogin(phoneNumber) else { return }
        user.TIME_DISSMISS_BANNER_HOME = timeDissmiss
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func setUserLoginTimeDissmissBannerLiveStreamByPhone(_ phoneNumber : String, timeDissmiss: String) {
        guard let user = getUserLogin(phoneNumber) else { return }
        user.TIME_DISSMISS_BANNER_LIVE_STREAM = timeDissmiss
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func setUserLoginTotalDeviceInPageByPhone(_ phoneNumber : String, totalDeviceInPage: String) {
        guard let user = getUserLogin(phoneNumber) else { return }
        user.TOTAL_DEVICE_IN_PAGE = totalDeviceInPage
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func updateObjectPhoneNumber(_ phoneNumber: String) {
        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == NULL")).fetch()
        moments.forEach({
            $0.PHONE_NUMBER = phoneNumber
        })
        let lastImages = CoreDataManager.Objects<CMRCamera>.build().filter(NSPredicate(format: "PHONE_NUMBER == NULL")).fetch()
        lastImages.forEach({
            $0.PHONE_NUMBER = phoneNumber
        })
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func addCameraMoment(_ phoneNumber: String, serialNo: String, cameraName: String, link: String, thumNail : String, type: String, createdDisplay: String, created: String, placeID: String, companyID: String, hasVolumn : Bool = false) {
        guard !thumNail.isEmpty else { return }
        var id : Int = 0
        if let camera = CoreDataManager.Objects<CMRCameraMoment>.build().sorted([.init(key: "ID", ascending: false)]).fetch().first, let _id = camera.ID {
            id = Int(truncating: _id) + 1
        }
        let moment = contextManager.build(object: CMRCameraMoment.self)
        moment.ID = NSNumber(integerLiteral: id)
        moment.PHONE_NUMBER = phoneNumber
        moment.SERIALNO = serialNo
        moment.CAMERANAME = cameraName
        moment.LINK = link
        moment.THUMNAIL = thumNail
        moment.TYPE = type
        moment.CREATED_DISPLAY = createdDisplay
        moment.CREATED = created
        moment.JSON_DATA = ""
        moment.COMPANY_ID = companyID
        moment.PLACE_ID = placeID
        moment.HAS_VOLUMN = hasVolumn
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func getListMoment(_ phoneNumber: String, private serialNo : String) -> [CMRCameraMoment]{
        return CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber, serialNo)).filter(and: .init(format: "IS_IGNORE == false OR IS_IGNORE == NULL")).sorted([.init(key: "ID", ascending: false)]).fetch()
    }
//    func getListMoment(_ phoneNumber: String, serialNo : [String], start : Date?, end: Date?) -> [ISCCameraMomentModels]{
//        if let start = start, end == nil {
//            return getListMoment(phoneNumber, serialNo: serialNo).filter({
//                if let date = $0.created.toDate("yyyy-MM-dd HH:mm:ss") {
//                    return date >= start
//                }
//                return false
//            })
//        }
//        else if let end = end, start == nil {
//            return getListMoment(phoneNumber, serialNo: serialNo).filter({
//                if let date = $0.created.toDate("yyyy-MM-dd HH:mm:ss") {
//                    return  date <= end
//                }
//                return false
//            })
//        }
//        guard let start = start, let end = end else {
//            return getListMoment(phoneNumber, serialNo: serialNo)
//        }
//        let res = getListMoment(phoneNumber, serialNo: serialNo).filter({
//            if let date = $0.created.toDate("yyyy-MM-dd HH:mm:ss") {
//                return date >= start && date <= end
//            }
//            return false
//        })
//        return res
//    }
    
//    func getListMoment(_ phoneNumber: String, serialNo : String) -> [ISCCameraMomentModels]{
//        return getListMoment(phoneNumber, private: serialNo).map({d in
//            let p = ISCCameraMomentModels()
//            p.phoneNumber = phoneNumber
//            p.serialNo = d.SERIALNO ?? ""
//            p.cameraName = d.CAMERANAME ?? ""
//            p.link = d.LINK ?? ""
//            p.type = d.TYPE ?? ""
//            p.thumnail = d.THUMNAIL ?? ""
//            p.created = d.CREATED ?? ""
//            p.created_display = d.CREATED_DISPLAY ?? ""
//            p.is_read = d.IS_READ
//            p.has_volumn = d.HAS_VOLUMN
//            return p
//        })
//    }
    
//    func getListMoment(_ phoneNumber: String, serialNo : [String]) -> [ISCCameraMomentModels]{
//        if serialNo.count == 0{
//            return []
//        }
//        let query = NSPredicate(format: "PHONE_NUMBER == %@", phoneNumber)
//        let queryIgnore = NSPredicate(format: "IS_IGNORE == false OR IS_IGNORE == NULL")
//        let filter : String = serialNo.reduce("") { partialResult, str in
//            if partialResult.isEmpty { return "SERIALNO == '\(str)'"}
//            return "\(partialResult) OR SERIALNO == '\(str)'"
//        }
//        let res = CoreDataManager.Objects<CMRCameraMoment>.build().filter(query).filter(and: queryIgnore).filter(and: NSPredicate(format: filter)).sorted([.init(key: "ID", ascending: false)]).fetch()
//        return res.map({d in
//            let p = ISCCameraMomentModels()
//            p.phoneNumber = phoneNumber
//            p.serialNo = d.SERIALNO ?? ""
//            p.cameraName = d.CAMERANAME ?? ""
//            p.link = d.LINK ?? ""
//            p.type = d.TYPE ?? ""
//            p.thumnail = d.THUMNAIL ?? ""
//            p.created = d.CREATED ?? ""
//            p.created_display = d.CREATED_DISPLAY ?? ""
//            p.is_read = d.IS_READ
//            p.has_volumn = d.HAS_VOLUMN
//            return p
//        })
//    }
    
    func getAllListMoment(private phoneNumber : String) -> [CMRCameraMoment] {
        return CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@", phoneNumber)).filter(and: NSPredicate(format: "IS_IGNORE == false OR IS_IGNORE == NULL")).sorted([.init(key: "ID", ascending: false)]).fetch()
    }
    
//    func getAllListMoment(_ phoneNumber : String) -> [ISCCameraMomentModels] {
//        return getAllListMoment(private: phoneNumber).map({d in
//            let p = ISCCameraMomentModels()
//            p.phoneNumber = phoneNumber
//            p.serialNo = d.SERIALNO ?? ""
//            p.cameraName = d.CAMERANAME ?? ""
//            p.link = d.LINK ?? ""
//            p.type = d.TYPE ?? ""
//            p.thumnail = d.THUMNAIL ?? ""
//            p.created = d.CREATED ?? ""
//            p.created_display = d.CREATED_DISPLAY ?? ""
//            p.has_volumn = d.HAS_VOLUMN
//            return p
//        })
//    }
    
    
    func getLastImage(_ phoneNumber: String, serialNo: String) -> String?{
        guard !serialNo.isEmpty else {return nil}
        return CoreDataManager.Objects<CMRCamera>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serialNo)).fetch().first?.LASTIMAGE
    }
    
    func getLastImageTime(_ phoneNumber: String, serialNo: String) -> String? {
        guard !serialNo.isEmpty else {return nil}
        return CoreDataManager.Objects<CMRCamera>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serialNo)).fetch().first?.LASTIMAGETIME
    }
    
    func addCameraLastImage(_ phoneNumber: String, serialNo: String, lastImage: String, lastImageTime: String){
        if let camera = CoreDataManager.Objects<CMRCamera>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serialNo)).fetch().first {
            camera.PHONE_NUMBER = phoneNumber
            camera.LASTIMAGE = lastImage
            camera.LASTIMAGETIME = lastImageTime
        }
        else {
            let camera = contextManager.build(object: CMRCamera.self)
            camera.PHONE_NUMBER = phoneNumber
            camera.SERIALNO = serialNo
            camera.NAME = ""
            camera.MAC = ""
            camera.IP = ""
            camera.PORT = ""
            camera.MODEL = ""
            camera.TYPE = ""
            camera.LASTIMAGE = lastImage
            camera.LASTIMAGETIME = lastImageTime
            camera.JSON_DATA = ""
            camera.WIFINAME = ""
        }
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    func deleteAllMoment() {
        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().fetch()
        contextManager.delete(items: moments)
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func deleteMomentLink(_ link: String) {
        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().sorted([.init(key: "ID", ascending: false)]).fetch()
        moments.forEach({
            if $0.LINK == link {
//                contextManager.delete(item: $0)
                $0.IS_IGNORE = true
            }
        })
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func deleteMoment(_ phoneNumber: String, serialNo: String) {
        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serialNo)).fetch()
//        contextManager.delete(items: moments)
        moments.forEach({
            $0.IS_IGNORE = true
        })
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func deleteMomentLink(_ phoneNumber: String, serialNo: String, link: String) {
        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@ AND LINK == %@", phoneNumber,serialNo, link)).fetch()
//        contextManager.delete(items: moments)
        moments.forEach({
            $0.IS_IGNORE = true
        })
        contextManager.saveContext()
        contextManager.mergeChangesFromMainContext()
    }
    
    func setIgnoreMoment(_ phoneNumber: String, serial: String, link: String, isIgnore: Bool){
        if let moment = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@ AND LINK == %@", phoneNumber,serial, link)).fetch().first {
            moment.IS_IGNORE = isIgnore
            contextManager.saveContext()
            contextManager.mergeChangesFromMainContext()
        }
    }
    
    func setReadMoment(_ phoneNumber: String, serial: String, link: String,isRead: Bool){
        if let moment = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@ AND LINK == %@", phoneNumber,serial, link)).fetch().first {
            moment.IS_READ = isRead
            contextManager.saveContext()
            contextManager.mergeChangesFromMainContext()
        }
    }
    
    func updateMomentCameraName(phoneNumber: String, serial: String, name: String) {
        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serial)).fetch()
        if moments.reversed().first?.CAMERANAME != name {
            moments.forEach({ $0.CAMERANAME = name })
            contextManager.saveContext()
            contextManager.mergeChangesFromMainContext()
        }
    }
    
//    func getMomentWithCompanyOrPlaceEmpty(_ phoneNumber : String) -> [ISCCameraMomentModels]  {
//        let data = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND COMPANY_ID == %@ OR COMPANY_ID == nil OR PLACE_ID == %@ OR PLACE_ID == nil", phoneNumber,"", "")).fetch().map({d -> ISCCameraMomentModels in
//            let p = ISCCameraMomentModels()
//            p.phoneNumber = d.PHONE_NUMBER ?? ""
//            p.serialNo = d.SERIALNO ?? ""
//            p.cameraName = d.CAMERANAME ?? ""
//            p.link = d.LINK ?? ""
//            p.type = d.TYPE ?? ""
//            p.thumnail = d.THUMNAIL ?? ""
//            p.created = d.CREATED ?? ""
//            p.created_display = d.CREATED_DISPLAY ?? ""
//            p.is_ignore = d.IS_IGNORE
//            p.company_id = d.COMPANY_ID ?? ""
//            p.place_id = d.PLACE_ID ?? ""
//            p.has_volumn = d.HAS_VOLUMN
//            return p
//        })
//        return data
//    }
    // $0 = Serial, $1 = companyId, $2 = placeId
    func updateCompanyAndPlace(_ phoneNumber : String, data: [(String, String, String)]){
        data.forEach { (serial, companyId, placeId) in
            if let moments = CoreDataManager.Objects<CMRCameraMoment>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serial)).fetch().first {
                moments.COMPANY_ID = companyId
                moments.PLACE_ID = placeId
                contextManager.saveContext()
            }
        }
        contextManager.mergeChangesFromMainContext()
    }
    
//    func getBaseListMoment(_ phoneNumber: String, serialNo : [String], start : Date?, end: Date?) -> [CMRCameraMoment]{
//        let moments = CoreDataManager.Objects<CMRCameraMoment>.build().fetch()
//        if let start = start, end == nil {
//            return moments.filter({
//                if let dateString = $0.CREATED, let date = dateString.toDate("yyyy-MM-dd HH:mm:ss") {
//                    return date >= start
//                }
//                return false
//            })
//        }
//        else if let end = end, start == nil {
//            return moments.filter({
//                if let dateString = $0.CREATED, let date = dateString.toDate("yyyy-MM-dd HH:mm:ss") {
//                    return  date <= end
//                }
//                return false
//            })
//        }
//        guard let start = start, let end = end else {
//            return moments
//        }
//        let res = moments.filter({
//            if let dateString = $0.CREATED, let date = dateString.toDate("yyyy-MM-dd HH:mm:ss") {
//                return date >= start && date <= end
//            }
//            return false
//        })
//        return res
//    }
    /**
     Xoa moment.
     - Parameters:
         - data: [(serial, date)]
     */
//    func deleteMomentToDate(data: [(String, Date)], phone: String){
//        let moments = data.flatMap{ cam -> [CMRCameraMoment] in
//           return self.getBaseListMoment(phone, serialNo: [cam.0], start: nil, end: cam.1)
//        }
//        guard moments.count > 0 else { return }
//        contextManager.delete(items: moments)
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
    /**
     Xoa Last image.
     - Parameters:
         - data: [(serial, date)]
     */
//    func deleteLastImageToDate(_ phone: String, data: [(String, Date)]) {
//        let _data = data.flatMap{ d -> [CMRCamera] in
//            return CoreDataManager.Objects<CMRCamera>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phone, d.0)).fetch().filter{
//                if let time = $0.LASTIMAGETIME {
//                    let date = Date(timeIntervalSince1970: .init((Int(time) ?? 0)/1000))
//                    return  date <= d.1
//                }
//                return false
//            }
//        }
//        guard _data.count > 0 else { return }
//        contextManager.delete(items: _data)
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
//    
//    //func saveCMRLastViewMode(phoneNumber:String, companyId:String = "", permissionCompany:NSNumber = 0, placeId:String = "", permissionPlace:NSNumber = 0, license:String = "")
//    func saveCMRLastViewMode(phoneNumber:String, companyId:String = "", data:[String:Any]){
//        if let modes = CoreDataManager.Objects<CMRLastViewMode>.build().filter(NSPredicate(format: "\(CMRLastViewMode.PHONE_NUMBER_FIELD) == %@ ", phoneNumber)).fetch() as? [CMRLastViewMode]{
//            for mode in modes {
//                mode.IS_ACTIVE = false
//            }
//            contextManager.saveContext()
//        }
//        var mode:CMRLastViewMode = contextManager.build(object: CMRLastViewMode.self)
//        if let modeCheck = CoreDataManager.Objects<CMRLastViewMode>.build().filter(NSPredicate(format: "\(CMRLastViewMode.PHONE_NUMBER_FIELD) == %@ AND \(CMRLastViewMode.COMPANY_ID_FIELD) == %@", phoneNumber,companyId)).fetch().first {
//            mode = modeCheck
//        }else{
//            mode.PHONE_NUMBER = phoneNumber
//            mode.COMPANY_ID = companyId
//        }
//        
//        for (key, value) in data {
//            if key == CMRLastViewMode.PERMISSION_COMPANY_FIELD, let valueCast = value as? NSNumber{
//                mode.PERMISSION_COMPANY = valueCast
//            }else if key == CMRLastViewMode.PLACE_ID_FIELD, let valueCast = value as? String{
//                mode.PLACE_ID = valueCast
//            }else if key == CMRLastViewMode.PERMISSION_PLACE_FIELD, let valueCast = value as? NSNumber{
//                mode.PERMISSION_PLACE = valueCast
//            }else if key == CMRLastViewMode.LICENSE_FIELD, let valueCast = value as? String{
//                mode.LICENSE = valueCast
//            }
//        }
//        
//        mode.IS_ACTIVE = true
//        
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
//    
//    /// Description lamnhs xoá lastview theo company
//    /// - Parameters:
//    ///   - phoneNumber: phoneNumber description
//    ///   - companyId: companyId description
//    func removeLastViewModeByCompany(phoneNumber:String, companyId:String = ""){
//        if let modes = CoreDataManager.Objects<CMRLastViewMode>.build().filter(NSPredicate(format: "\(CMRLastViewMode.PHONE_NUMBER_FIELD) == %@ AND \(CMRLastViewMode.COMPANY_ID_FIELD) == %@", phoneNumber,companyId)).fetch() as? [CMRLastViewMode]{
//            contextManager.delete(items: modes)
//            contextManager.saveContext()
//            contextManager.mergeChangesFromMainContext()
//        }
//    }
//    
//    /// Description lamnhs xoá tất cả lastview
//    /// - Parameters:
//    ///   - phoneNumber: <#phoneNumber description#>
//    ///   - companyId: <#companyId description#>
//    func removeAllLastViewMode(phoneNumber:String){
//        if let modes = CoreDataManager.Objects<CMRLastViewMode>.build().filter(NSPredicate(format: "\(CMRLastViewMode.PHONE_NUMBER_FIELD) == %@", phoneNumber)).fetch() as? [CMRLastViewMode]{
//            contextManager.delete(items: modes)
//            contextManager.saveContext()
//            contextManager.mergeChangesFromMainContext()
//        }
//    }
//    
//    func getLastViewActive(phoneNumber:String) -> CMRLastViewMode? {
//        return CoreDataManager.Objects<CMRLastViewMode>.build().filter(NSPredicate(format: "\(CMRLastViewMode.PHONE_NUMBER_FIELD) == %@ AND \(CMRLastViewMode.IS_ACTIVE_FIELD) == true", phoneNumber)).fetch().first
//    }
//     
//    
//    /// Description lamnhs kiểm tra mode có tồn tại chưa
//    /// - Parameters:
//    ///   - phoneNumber: <#phoneNumber description#>
//    ///   - companyId: <#companyId description#>
//    /// - Returns: <#description#>
//    func getModeByCompanyId(phoneNumber:String, companyId:String) -> CMRLastViewMode?{
//        return CoreDataManager.Objects<CMRLastViewMode>.build().filter(NSPredicate(format: "\(CMRLastViewMode.PHONE_NUMBER_FIELD) == %@ AND \(CMRLastViewMode.COMPANY_ID_FIELD) == %@", phoneNumber,companyId)).fetch().first
//    }
//    
//    func addReadSDCard(_ phoneNumber:String, serial: String, startTime: Date, isRead: Bool){
//        if let _ = CoreDataManager.Objects<CMRCameraSDCardModel>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@ AND START_TIME == %@", phoneNumber,serial, startTime.toString("yyyy-MM-dd HH:mm:ss"))).fetch().first {
//            return
//        }
//        let newSDCard = contextManager.build(object: CMRCameraSDCardModel.self)
//        newSDCard.PHONE_NUMBER = phoneNumber
//        newSDCard.SERIALNO = serial
//        newSDCard.START_TIME = startTime.toString("yyyy-MM-dd HH:mm:ss")
//        newSDCard.CREATED = Date().toString("yyyy-MM-dd HH:mm:ss")
//        newSDCard.IS_READ = isRead
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
//    
//    func getAllReadSDCard(_ phoneNumber:String, serial: String) -> [CMRCameraSDCardModel] {
//        return CoreDataManager.Objects<CMRCameraSDCardModel>.build().filter(NSPredicate(format: "PHONE_NUMBER == %@ AND SERIALNO == %@", phoneNumber,serial)).fetch()
//    }
//    
//    func saveCameraSDCardThumbnail(serial: String, imagePath: String) {
//        let model = contextManager.build(object: CMRCameraSDCardThumbnail.self)
//        model.SERIALNO = serial
//        model.CREATED = Date()
//        model.LINK = imagePath
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
//    
//    func getOutdatedSDCardThumbnail(date: Date) -> [CMRCameraSDCardThumbnail] {
//        let data = CoreDataManager.Objects<CMRCameraSDCardThumbnail>.build().filter(NSPredicate(format: "CREATED < %@", date as NSDate)).fetch()
//        return data
//    }
//    
//    func removeOutdatedSDCardThumbnail(data: CMRCameraSDCardThumbnail) {
//        contextManager.delete(item: data)
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
//    
//    func saveLastClearCacheTime(id: String) {
//        if let data = CoreDataManager.Objects<CMRLastClearCacheTime>.build().filter(NSPredicate(format: "ID == %@", id)).fetch().first {
//            data.TIME_CLEAR_CACHE = Date().toString("yyyy-MM-dd HH:mm:ss")
//            contextManager.saveContext()
//            contextManager.mergeChangesFromMainContext()
//            return
//        }
//        let model = contextManager.build(object: CMRLastClearCacheTime.self)
//        model.ID = id
//        model.TIME_CLEAR_CACHE = Date().toString("yyyy-MM-dd HH:mm:ss")
//        contextManager.saveContext()
//        contextManager.mergeChangesFromMainContext()
//    }
//    
//    func getLastClearCacheTime(id: String) -> String {
//        return CoreDataManager.Objects<CMRLastClearCacheTime>.build().filter(NSPredicate(format: "ID == %@", id)).fetch().first?.TIME_CLEAR_CACHE ?? ""
//    }
}
