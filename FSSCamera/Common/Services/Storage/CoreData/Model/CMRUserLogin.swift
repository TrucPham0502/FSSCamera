//
//  CMRUserLogin.swift
//  CMRUserLogin
//
//  Created by Truc Pham on 23/09/2021.
//  Copyright © 2021 fun.sdk.ftel.vn.su4. All rights reserved.
//

import Foundation
class CMRUserLogin : CoreDataObject {
    @NSManaged var PHONE_NUMBER : String?
    @NSManaged var TIME_DISSMISS_BANNER_HOME : String?
    @NSManaged var TIME_DISSMISS_BANNER_LIVE_STREAM : String?
    @NSManaged var TOTAL_DEVICE_IN_PAGE : String?
    override class func createEntity() -> CoreDataEntityDescription {
        return .entity(
            name: "CMRUserLogin",
            managedObjectClass: CMRUserLogin.self,
            attributes: [
                .attribute(name: "PHONE_NUMBER", type: .stringAttributeType),
                .attribute(name: "TIME_DISSMISS_BANNER_HOME", type: .stringAttributeType),
                .attribute(name: "TIME_DISSMISS_BANNER_LIVE_STREAM", type: .stringAttributeType),
                .attribute(name: "TOTAL_DEVICE_IN_PAGE", type: .stringAttributeType)
            ])
    }
}
