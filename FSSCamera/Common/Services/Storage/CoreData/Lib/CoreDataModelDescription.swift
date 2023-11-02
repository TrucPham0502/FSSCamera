//
//  CoreDataModelDescription.swift
//  CoreDataModelDescription
//
//  Created by Truc Pham on 21/09/2021.
//  Copyright © 2021 Truc Pham. All rights reserved.
// Tạo ra các object model, giống conver json to object

import CoreData


/// Used to create `NSManagedObjectModel`

 struct CoreDataModelDescription {

     var entities: [CoreDataEntityDescription]

     init(entities: [CoreDataEntityDescription]) {
        self.entities = entities
    }

     func makeModel(byMerging model: NSManagedObjectModel = NSManagedObjectModel()) -> NSManagedObjectModel {


        let entitiesDescriptions = self.entities
        let entities: [NSEntityDescription]
        
        var entityNameToEntity: [String: NSEntityDescription] = [:]
        var configurationNameToEntities: [String: Array<NSEntityDescription>] = [:]


        for entityDescription in entitiesDescriptions {
            let entity = NSEntityDescription()
            entity.name = entityDescription.name
            entity.managedObjectClassName = entityDescription.managedObjectClassName
            entity.isAbstract = entityDescription.isAbstract

            var propertyNameToProperty: [String: NSPropertyDescription] = [:]

            for attributeDescription in entityDescription.attributes {
                let attribute = attributeDescription.makeAttribute()
                propertyNameToProperty[attribute.name] = attribute
            }

            entity.properties = Array(propertyNameToProperty.values)
            entity.uniquenessConstraints = [entityDescription.constraints]

            // Map the entity to its name
            entityNameToEntity[entityDescription.name] = entity

            // Map the entity to its configuration
            if let configurationName = entityDescription.configuration {
                var configurationEntities = configurationNameToEntities[configurationName] ?? []
                configurationEntities.append(entity)
                configurationNameToEntities[configurationName] = configurationEntities
            }

        }

        var relationshipsWithInverse: [(CoreDataRelationshipDescription, NSRelationshipDescription)] = []

        for entityDescription in entitiesDescriptions {
            let entity = entityNameToEntity[entityDescription.name]!

            var propertyNameToProperty: [String: NSPropertyDescription] = [:]

            for relationshipDescription in entityDescription.relationships {
                let relationship = NSRelationshipDescription()
                relationship.name = relationshipDescription.name
                relationship.maxCount = relationshipDescription.maxCount
                relationship.minCount = relationshipDescription.minCount
                relationship.deleteRule = relationshipDescription.deleteRule
                relationship.isOptional = relationshipDescription.optional

                var destinationEntity = entityNameToEntity[relationshipDescription.destination]
                if destinationEntity == nil {
                    destinationEntity = model.entitiesByName[relationshipDescription.destination]
                }
                assert(destinationEntity != nil, "Can not find destination entity: '\(relationshipDescription.destination)', in relationship '\(relationshipDescription.name)', for entity: '\(entityDescription.name)'")
                relationship.destinationEntity = destinationEntity

                if let _ = relationshipDescription.inverse {
                    relationshipsWithInverse.append((relationshipDescription, relationship))
                }

                propertyNameToProperty[relationshipDescription.name] = relationship
            }

            // Relationships
            entity.properties += Array(propertyNameToProperty.values)

            // Parent-child entity
            if let parentName = entityDescription.parentEntity {
                let parentEntity = entityNameToEntity[parentName]
                assert(parentEntity != nil, "Can not find parent entity: '\(parentName)', for entity: '\(entityDescription.name)'")
                parentEntity?.subentities += [entity]
            }
        }

        // Third step
        for el in relationshipsWithInverse {
            let relationshipDescription = el.0
            let relationship = el.1

            let inverseRelationshipName = relationshipDescription.inverse!
            let inverseRelationship = relationship.destinationEntity!.propertiesByName[inverseRelationshipName] as? NSRelationshipDescription

            assert(inverseRelationship != nil, "Can not find inverse relationship '\(inverseRelationshipName)', for relationship: '\(relationshipDescription.name)', for entity: '\(relationship.entity.name ?? "nil")', destination entity: '\(relationship.destinationEntity!.name ?? "nil")'")

            relationship.inverseRelationship = inverseRelationship
        }

        entities = Array(entityNameToEntity.values)


        // Append new entities and set their configurations

        model.entities.append(contentsOf: entities)

        for (configurationName, entities) in configurationNameToEntities {
            model.setEntities(entities, forConfigurationName: configurationName)
        }
        
        return model
    }
}
