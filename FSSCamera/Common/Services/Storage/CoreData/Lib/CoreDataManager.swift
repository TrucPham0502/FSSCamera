//
//  CoreDataManager.swift
//  CalendarDemo
//
//  Created by Truc Pham on 21/09/2021.
// Để query dữ liệu trong db

import Foundation
import CoreData
class CoreDataManager  {
    static let shared = CoreDataManager()
    class Objects<T: CoreDataObject>
    {
        private var fetchRequest : NSFetchRequest<T>?
        private var query : NSPredicate = .init()
        private init() {}
        
        //get data
        static func build() ->  Objects<T>{
            let core =  Objects<T>()
            core.fetchRequest =  NSFetchRequest<T>(entityName: String(describing: T.self))
            return core
        }
        
        func filter(_ query : NSPredicate) -> Self {
            if let fetchRequest = fetchRequest {
                self.query = query
                fetchRequest.predicate =  self.query
            }
            return self
        }
        
        func filter(and query : NSPredicate) -> Self {
            if let fetchRequest = fetchRequest {
                self.query = NSCompoundPredicate(type: .and, subpredicates: [self.query, query])
                fetchRequest.predicate = self.query
            }
            return self
        }
        
        func filter(or query : NSPredicate) -> Self {
            if let fetchRequest = fetchRequest {
                self.query = NSCompoundPredicate(type: .or, subpredicates: [self.query, query])
                fetchRequest.predicate = self.query
            }
            return self
        }
        func filter(not query : NSPredicate) -> Self {
            if let fetchRequest = fetchRequest {
                self.query = NSCompoundPredicate(type: .not, subpredicates: [self.query, query])
                fetchRequest.predicate = self.query
            }
            return self
        }
        
        func sorted(_ sortDescriptors : [NSSortDescriptor]) -> Self {
            if let fetchRequest = fetchRequest {
                fetchRequest.sortDescriptors = sortDescriptors
            }
            return self
        }
        
        func limit(_ number : Int) -> Self {
            if let fetchRequest = fetchRequest {
                fetchRequest.fetchLimit = number
            }
            return self
        }
        func fetch() -> [T] {
            if let fetchRequest = fetchRequest {
                return CoreDataManager.shared.contextManager.fetch(fetchRequest)
            }
            return []
        }
        
        
    }
    var contextInstance: NSManagedObjectContext!
    let contextManager: ContextManager!
    
    private init() {
        self.contextManager = ContextManager()
        self.contextInstance = contextManager.minionManagedObjectContextWorker
    }
    
}
