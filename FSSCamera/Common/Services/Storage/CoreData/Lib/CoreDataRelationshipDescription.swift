//
//  CoreDataRelationshipDescription.swift
//  CoreDataModelDescription
//
//  Created by Truc Pham on 21/09/2021.
//  Copyright © 2021 Truc Pham. All rights reserved.
// Tạo mối quan hệ giữa các bảng

import CoreData
 struct CoreDataRelationshipDescription {

     static func relationship(
               name: String,
        destination: AnyClass,
           optional: Bool = true,
             toMany: Bool = false,
         deleteRule: NSDeleteRule = .nullifyDeleteRule,
            inverse: String? = nil) -> CoreDataRelationshipDescription {

        let maxCount = toMany ? 0 : 1

        return CoreDataRelationshipDescription(name: name, destination: String(describing: destination), optional: optional, maxCount: maxCount, minCount: 0, deleteRule: deleteRule, inverse: inverse)
    }

     var name: String

     var destination: String

     var optional: Bool

     var maxCount: Int

     var minCount: Int

     var deleteRule: NSDeleteRule

     var inverse: String?
}

