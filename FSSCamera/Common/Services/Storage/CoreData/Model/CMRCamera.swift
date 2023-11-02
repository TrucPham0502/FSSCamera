//
//  CMRCamera.swift
//  CMRCamera
//
//  Created by Truc Pham on 23/09/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
class CMRCamera : CoreDataObject {
    @NSManaged var PHONE_NUMBER : String?
    @NSManaged var SERIALNO : String?
    @NSManaged var NAME : String?
    @NSManaged var MAC : String?
    @NSManaged var WIFINAME : String?
    @NSManaged var IP : String?
    @NSManaged var PORT : String?
    @NSManaged var MODEL : String?
    @NSManaged var TYPE : String?
    @NSManaged var LASTIMAGE : String?
    @NSManaged var LASTIMAGETIME : String?
    @NSManaged var JSON_DATA : String?
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(
            name: "CMRCamera",
            managedObjectClass: CMRCamera.self,
            attributes: [
                .attribute(name: "PHONE_NUMBER", type: .stringAttributeType),
                .attribute(name: "SERIALNO", type: .stringAttributeType),
                .attribute(name: "NAME", type: .stringAttributeType),
                .attribute(name: "MAC", type: .stringAttributeType),
                .attribute(name: "WIFINAME", type: .stringAttributeType),
                .attribute(name: "IP", type: .stringAttributeType),
                .attribute(name: "PORT", type: .stringAttributeType),
                .attribute(name: "MODEL", type: .stringAttributeType),
                .attribute(name: "LASTIMAGE", type: .stringAttributeType),
                .attribute(name: "LASTIMAGETIME", type: .stringAttributeType),
                .attribute(name: "TYPE", type: .stringAttributeType),
                .attribute(name: "JSON_DATA", type: .stringAttributeType),
            ])
    }
}
