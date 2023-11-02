//
//  CMRCameraSDCardModel.swift
//  ISCCamera
//
//  Created by TrucPham on 11/10/2022.
//  Copyright © 2022 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
class CMRCameraSDCardModel : CoreDataObject {
    @NSManaged var PHONE_NUMBER : String?
    @NSManaged var SERIALNO : String?
    @NSManaged var START_TIME : String?
    @NSManaged var IS_READ : Bool
    @NSManaged var CREATED : String?
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(
            name: "CMRCameraSDCardModel",
            managedObjectClass: CMRCameraSDCardModel.self,
            attributes: [
                .attribute(name: "START_TIME", type: .stringAttributeType),
                .attribute(name: "PHONE_NUMBER", type: .stringAttributeType),
                .attribute(name: "SERIALNO", type: .stringAttributeType),
                .attribute(name: "CREATED", type: .stringAttributeType),
                .attribute(name: "IS_READ", type: .booleanAttributeType),
            ])
    }
}

class CMRCameraSDCardThumbnail: CoreDataObject {
    @NSManaged var SERIALNO: String?
    @NSManaged var CREATED: Date?
    @NSManaged var LINK: String?
    
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(name: "CMRCameraSDCardThumbnail",
                       managedObjectClass: CMRCameraSDCardThumbnail.self,
                       attributes: [
                        .attribute(name: "SERIALNO", type: .stringAttributeType),
                        .attribute(name: "CREATED", type: .dateAttributeType),
                        .attribute(name: "LINK", type: .stringAttributeType)
                       ])
    }
}

class CMRLastClearCacheTime: CoreDataObject {
    @NSManaged var ID: String?
    @NSManaged var TIME_CLEAR_CACHE: String?
    
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(name: "CMRLastClearCacheTime",
                       managedObjectClass: CMRLastClearCacheTime.self,
                       attributes: [
                        .attribute(name: "ID", type: .stringAttributeType),
                        .attribute(name: "TIME_CLEAR_CACHE", type: .stringAttributeType)
                       ])
    }
}
