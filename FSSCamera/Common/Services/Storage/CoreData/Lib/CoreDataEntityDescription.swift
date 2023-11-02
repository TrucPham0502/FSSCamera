//
//  CoreDataEntityDescription.swift
//  CoreDataModelDescription
//
//  Created by Truc Pham on 21/09/2021.
//  Copyright © 2021 Truc Pham. All rights reserved.
// Tạo ra table

import CoreData


/// Describes and creates `NSEntityDescription`


struct CoreDataEntityDescription {
    static func entity(name: String,
                              managedObjectClass: CoreDataObject.Type = CoreDataObject.self,
                              parentEntity: String? = nil,
                              isAbstract: Bool = false,
                              attributes: [CoreDataAttributeDescription] = [],
                              relationships: [CoreDataRelationshipDescription] = [],
                              constraints: [Any] = [],
                              configuration: String? = nil) -> CoreDataEntityDescription {
        CoreDataEntityDescription(name: name, managedObjectClassName: NSStringFromClass(managedObjectClass), parentEntity: parentEntity, isAbstract: isAbstract, attributes: attributes, relationships: relationships, constraints: constraints, configuration: configuration)
    }
    
     var name: String

     var managedObjectClassName: String

     var parentEntity: String?

     var isAbstract: Bool

     var attributes: [CoreDataAttributeDescription]
    
     var relationships: [CoreDataRelationshipDescription]
    
     var constraints: [Any]

     var configuration: String?
}
