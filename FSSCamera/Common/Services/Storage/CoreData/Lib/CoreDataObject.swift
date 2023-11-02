//
//  CoreDataManagedObject.swift
//  CalendarDemo
//
//  Created by Truc Pham on 21/09/2021.
// 

import Foundation
import CoreData
class CoreDataObject: NSManagedObject {
    class func createEntity() -> CoreDataEntityDescription {
        fatalError("Must Override")
    }
}

