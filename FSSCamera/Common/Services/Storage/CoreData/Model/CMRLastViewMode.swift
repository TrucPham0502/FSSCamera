//
//  LastViewMode.swift
//  ISCCamera
//
//  Created by TrucPham on 15/02/2022.
//  Copyright © 2022 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
class CMRLastViewMode : CoreDataObject {
    static let PHONE_NUMBER_FIELD = "PHONE_NUMBER"
    @NSManaged var PHONE_NUMBER : String?
    
    static let COMPANY_ID_FIELD = "COMPANY_ID"
    @NSManaged var COMPANY_ID : String?
    
    static let PERMISSION_COMPANY_FIELD = "PERMISSION_COMPANY"
    @NSManaged var PERMISSION_COMPANY : NSNumber?
    
    static let PLACE_ID_FIELD = "PLACE_ID"
    @NSManaged var PLACE_ID : String?
    
    static let PERMISSION_PLACE_FIELD = "PERMISSION_PLACE"
    @NSManaged var PERMISSION_PLACE : NSNumber?
    
    static let LICENSE_FIELD = "LICENSE"
    @NSManaged var LICENSE : String?
    
    static let IS_ACTIVE_FIELD = "IS_ACTIVE"
    @NSManaged var IS_ACTIVE : Bool
    
    
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(
            name: "CMRLastViewMode",
            managedObjectClass: CMRLastViewMode.self,
            attributes: [
                .attribute(name: PHONE_NUMBER_FIELD, type: .stringAttributeType),
                .attribute(name: COMPANY_ID_FIELD, type: .stringAttributeType),
                .attribute(name: PERMISSION_COMPANY_FIELD, type: .integer64AttributeType),
                .attribute(name: PLACE_ID_FIELD, type: .stringAttributeType),
                .attribute(name: PERMISSION_PLACE_FIELD, type: .integer64AttributeType),
                .attribute(name: LICENSE_FIELD, type: .stringAttributeType),
                .attribute(name: IS_ACTIVE_FIELD, type: .booleanAttributeType),
            ]
        )
    }
}
