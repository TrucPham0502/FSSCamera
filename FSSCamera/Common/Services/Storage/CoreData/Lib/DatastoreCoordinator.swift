//
//  DatastoreCoordinator.swift
//  CalendarDemo
//
//  Created by Truc Pham on 21/09/2021.
// Tạo db SQLite

import Foundation
import CoreData
struct DatastoreConfig {
    static var objectTypes : [CoreDataObject.Type] = []
    static var dbFilename = "CoreData.sqlite"
    static var appDomain = "com.vn.coredata"
}
class DatastoreCoordinator: NSObject {
    
   
   
    static let shared : DatastoreCoordinator = .init()
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelDescription = CoreDataModelDescription(
            entities: DatastoreConfig.objectTypes.map({
                return $0.createEntity()
            })
        )
        return modelDescription.makeModel()
        
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // auto migrate store
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        var url = self.applicationDocumentsDirectory.appendingPathComponent(DatastoreConfig.dbFilename)
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: DatastoreConfig.appDomain, code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
}
