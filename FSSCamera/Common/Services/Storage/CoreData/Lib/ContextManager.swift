//
//  ContextManager.swift
//  CalendarDemo
//
//  Created by Truc Pham on 21/09/2021.
//

import Foundation
import CoreData
class ContextManager: NSObject {

    let datastore: DatastoreCoordinator = DatastoreCoordinator.shared

    // Create master context reference, with PrivateQueueConcurrency Type.
    lazy var minionManagedObjectContextWorker: NSManagedObjectContext = {
        var minionManagedObjectContextWorker = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainManagedObjectContextInstance

        return minionManagedObjectContextWorker
    }()

    //Create main context reference, with MainQueueuConcurrency Type.
    lazy var mainManagedObjectContextInstance: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator

        return mainManagedObjectContext
    }()
    
    func delete(item: CoreDataObject){
        self.minionManagedObjectContextWorker.delete(item)
    }
    func delete(items: [CoreDataObject]){
        items.forEach({
            self.minionManagedObjectContextWorker.delete($0)
        })
    }
    
    func fetch<T : CoreDataObject>(_ fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            return try self.minionManagedObjectContextWorker.fetch(fetchRequest)
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
        }
        return []
    }

    // MARK: - Core Data Saving support

    /**
        Saves changes from the Main Context to the Master Managed Object Context.
        - Returns: Void
    */
    
    func saveContext() {
        defer {
            do {
                try minionManagedObjectContextWorker.save()
            } catch let masterMocSaveError as NSError {
                print("Master Managed Object Context save error: \(masterMocSaveError.localizedDescription)")
            } catch {
                print("Master Managed Object Context save error.")
            }
        }
    }

    /**
        Merge Changes on the Main Context to the Master Context.
        - Returns: Void
    */
    func mergeChangesFromMainContext() {
        DispatchQueue.main.async(execute: {
            do {
                try self.mainManagedObjectContextInstance.save()
            } catch let mocSaveError as NSError {
                print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }
    func build<O : CoreDataObject>(object : O.Type) -> O {
        return NSEntityDescription.insertNewObject(forEntityName: .init(describing: O.self),
            into: minionManagedObjectContextWorker) as! O
    }
}
