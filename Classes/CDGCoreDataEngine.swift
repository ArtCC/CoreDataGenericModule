//
//  CDGCoreDataEngine.swift
//  CoreDataGenericModule
//
//  Created by Arturo Carretero Calvo on 27/10/16.
//  Copyright © 2016 Arturo Carretero Calvo. All rights reserved.
//

import Foundation
import CoreData
import RNCryptor

/**
 CDGCoreDataEngine class: This module serves to persist generic objects in Core Data with id as primary key to find them easily. The object is encrypted with password
 */
open class CDGCoreDataEngine: NSObject {
    
    // MARK: - Core Data functions
    /**
     Save an object given a dicionary and the name of Entity in Core Data
     - parameter object: Object model implement CDGCoreDataProtocol
     - parameter passwordForEncrypted: String for use like password for encrypted in Core Data
     - returns: results with Bool
     */
    open class func saveObject(_ object: CDGCoreDataProtocol, passwordForEncrypted: String) -> Bool {
        // Create an instance of our managedObjectContext
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        
        // We set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: managedContext)
        
        // Dictionary from object model
        let dict = object.saveAsDictionary()
        
        // Identifier from object model
        let identifier = object.uniqueIdentifier()
        
        // Save object in Core Data model with identifier like primary key
        entity.setValue(identifier, forKey: "idEntity")
        
        // Convert dictionary to data
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: dict)
        
        // Encrypted or not data object
        let cipherData: Data = RNCryptor.encrypt(data: data, withPassword: passwordForEncrypted)
        
        // Add object in Core Data context
        entity.setValue(cipherData, forKey: "dataEntity")
        
        // Save in bd
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            printDebug("Failed to save entity: \(error.localizedDescription)")
            return false
        }
    }
    
    /**
     Delete entity given the key and value
     - parameter identifier: Object identifier
     - returns: results with Bool
     */
    open class func deleteObjectWithIdentifier(_ identifier: String) -> Bool {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchPredicate = NSPredicate(format: "idEntity == %@", identifier)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = fetchPredicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedEntities = try managedContext.fetch(fetchRequest)
            if !fetchedEntities.isEmpty {
                for entity in fetchedEntities {
                    guard let entDelete = entity as? NSManagedObject else {
                        return false
                    }
                    managedContext.delete(entDelete)
                    try! managedContext.save()
                }
            }
        } catch let error as NSError {
            printDebug("Failed to delete entity: \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    /**
     Get any object from Core Data
     - parameter identifier: Object identifier
     - parameter passwordForEncrypted: String for use like password for encrypted in Core Data
     - returns: object
     */
    open class func getObjectWithIdentifier(_ identifier: String, passwordForEncripted: String) -> [String : String]? {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchPredicate = NSPredicate(format: "idEntity == %@", identifier)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = fetchPredicate
        do {
            let fetchedObject = try managedContext.fetch(fetchRequest)
            if !fetchedObject.isEmpty {
                
                // Decrypted object
                var dictionary: [String : String] = ["" : ""]
                guard let object = fetchedObject[0] as? NSManagedObject else {
                    return nil
                }
                if let _ = object.value(forKey: "idEntity"),
                    let dataEntity = object.value(forKey: "dataEntity") {
                    
                    // Decryption
                    guard let dEntity = dataEntity as? NSData else {
                        return nil
                    }
                    let originalData: Data = try RNCryptor.decrypt(data: dEntity as Data,
                                                                   withPassword: passwordForEncripted)
                    
                    // Convert data to dictionary
                    if let d = NSKeyedUnarchiver.unarchiveObject(with: originalData) {
                        guard let dict = d as? [String : String] else {
                            return nil
                        }
                        dictionary = dict
                    }
                    if !dictionary.isEmpty {
                        return dictionary
                    }
                    return nil
                }
            }
        } catch let error as NSError {
            fatalError("Failed to fetch entity: \(error)")
        }
        return nil
    }
    
    /**
     Get objects from Core Data
     - parameter entityName: Entity name for get object
     - parameter passwordForEncrypted: String for use like password for encrypted in Core Data
     - returns: Objects (array with dictionaries) or nil
     */
    open class func getObjectsFromCoreData(_ entityName: String, passwordForEncripted: String) -> Array<[String : String]> {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // Array for return with data or empty
        var array: Array<[String : String]> = []
        do {
            let fetchedObject = try managedContext.fetch(fetchRequest)
            if !fetchedObject.isEmpty {
                
                // Decrypted object
                var dictionary: [String : String] = ["" : ""]
                for object in fetchedObject {
                    if let _ = (object as AnyObject).value(forKey: "idEntity"),
                        let dataEntity = (object as AnyObject).value(forKey: "dataEntity") {
                        
                        // Decryption
                        guard let dEntity = dataEntity as? NSData else {
                            return []
                        }
                        let originalData: Data = try RNCryptor.decrypt(data: dEntity as Data,
                                                                       withPassword: passwordForEncripted)
                        
                        if let d = NSKeyedUnarchiver.unarchiveObject(with: originalData) {
                            
                            // Convert data to dictionary
                            guard let dict = d as? [String : String] else {
                                return []
                            }
                            dictionary = dict
                        }
                        if !dictionary.isEmpty {
                            array.insert(dictionary, at: 0)
                        }
                    }
                }
                return array
            }
        } catch {
            fatalError("Failed to fetch entity: \(error)")
        }
        return []
    }
    
    /**
     Delete all data from Entity in Core Data
     - returns: results with Bool
     */
    open class func deleteAllInCoreData() -> Bool {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                guard let managedObjectData:NSManagedObject = managedObject as? NSManagedObject else {
                    return false
                }
                managedContext.delete(managedObjectData)
            }
            printDebug("All entities delete from Core Data")
            return true
        } catch let error as NSError {
            printDebug("Delete all data in Object entity with error : \(error) \(error.userInfo)")
            return false
        }
    }
}
