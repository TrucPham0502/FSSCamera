//
//  CMRCameraMoment.swift
//  CMRCameraMoment
//
//  Created by Truc Pham on 23/09/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
class CMRCameraMoment : CoreDataObject {
    @NSManaged var ID : NSNumber?
    @NSManaged var PHONE_NUMBER : String?
    @NSManaged var SERIALNO : String?
    @NSManaged var CAMERANAME : String?
    @NSManaged var LINK : String?
    @NSManaged var THUMNAIL : String?
    @NSManaged var TYPE : String?
    @NSManaged var CREATED_DISPLAY : String?
    @NSManaged var CREATED : String?
    @NSManaged var JSON_DATA : String?
    @NSManaged var IS_IGNORE : Bool
    @NSManaged var COMPANY_ID : String?
    @NSManaged var PLACE_ID : String?
    @NSManaged var IS_READ : Bool
    @NSManaged var HAS_VOLUMN : Bool
    
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(
            name: "CMRCameraMoment",
            managedObjectClass: CMRCameraMoment.self,
            attributes: [
                .attribute(name: "ID", type: .integer64AttributeType),
                .attribute(name: "PHONE_NUMBER", type: .stringAttributeType),
                .attribute(name: "SERIALNO", type: .stringAttributeType),
                .attribute(name: "CAMERANAME", type: .stringAttributeType),
                .attribute(name: "LINK", type: .stringAttributeType),
                .attribute(name: "THUMNAIL", type: .stringAttributeType),
                .attribute(name: "TYPE", type: .stringAttributeType),
                .attribute(name: "CREATED_DISPLAY", type: .stringAttributeType),
                .attribute(name: "CREATED", type: .stringAttributeType),
                .attribute(name: "JSON_DATA", type: .stringAttributeType),
                .attribute(name: "IS_IGNORE", type: .booleanAttributeType),
                .attribute(name: "COMPANY_ID", type: .stringAttributeType),
                .attribute(name: "PLACE_ID", type: .stringAttributeType),
                .attribute(name: "IS_READ", type: .booleanAttributeType),
                .attribute(name: "HAS_VOLUMN", type: .booleanAttributeType),
            ])
    }
}
