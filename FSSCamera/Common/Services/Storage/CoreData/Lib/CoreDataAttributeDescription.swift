//
//  CoreDataAttributeDescription.swift
//  CoreDataModelDescription
//
//  Created by Truc Pham on 21/09/2021.
//  Copyright © 2021 Truc Pham. All rights reserved.
// Khởi tạo cột trong table

import CoreData


/// Describes and creates`NSAttributeDescription`
struct CoreDataAttributeDescription {
    static func attribute(name: String, type: NSAttributeType, isOptional: Bool = true, defaultValue: Any? = nil, isIndexedBySpotlight: Bool = false) -> CoreDataAttributeDescription {
            return CoreDataAttributeDescription(name: name, attributeType: type, isOptional: isOptional, defaultValue: defaultValue, isIndexedBySpotlight: isIndexedBySpotlight)
        }

         var name: String

         var attributeType: NSAttributeType

         var isOptional: Bool
        
         var defaultValue: Any?
        
         var isIndexedBySpotlight: Bool

         func makeAttribute() -> NSAttributeDescription {
            let attribute = NSAttributeDescription()
            attribute.name = name
            attribute.attributeType = attributeType
            attribute.isOptional = isOptional
            attribute.defaultValue = defaultValue
            attribute.isIndexedBySpotlight = isIndexedBySpotlight

            return attribute
        }
   
}
