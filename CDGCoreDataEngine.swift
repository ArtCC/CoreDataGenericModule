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
public class CDGCoreDataEngine: NSObject {
    // MARK: - Core Data functions
    
    /**
     Save an object given a dicionary and the name of Entity in Core Data
     - parameter object: Object model implement CDGCoreDataProtocol
     - parameter passwordForEncrypted: String for use like password for encrypted in Core Data
     - returns: results with Bool
     */
    public class func saveObject(object: CDGCoreDataProtocol, passwordForEncrypted: String) -> Bool {
        // Create an instance of our managedObjectContext
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        // We set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: managedContext)
        // Dictionary from object model
        var dict = object.saveAsDictionary()
        // Identifier from object model
        let identifier = object.uniqueIdentifier()
        // Save object in Core Data model with identifier like primary key
        entity.setValue(identifier, forKey: "idEntity")
        // Convert dictionary to data
        let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
        // Encrypted or not data object
        var cipherData: NSData = RNCryptor.encryptData(data, password: passwordForEncrypted)
        // Add object in Core Data context
        entity.setValue(cipherData, forKey: "dataEntity")
        // Save in bd
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            fatalError("Failed to save entity: \(error)")
            return false
        }
    }
    
    /**
     Delete entity given the key and value
     - parameter identifier: Object identifier
     - returns: results with Bool
     */
    public class func deleteObjectWithIdentifier(identifier: String) -> Bool {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchPredicate = NSPredicate(format: "idEntity == %@", identifier)
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = fetchPredicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchRequest)
            for entity in fetchedEntities {
                managedContext.deleteObject(entity as! NSManagedObject)
                try! managedContext.save()
            }
        } catch let error as NSError {
            fatalError("Failed to delete entity: \(error)")
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
    public class func getObjectWithIdentifier(identifier: String, passwordForEncripted: String) -> [String : String]? {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchPredicate = NSPredicate(format: "idEntity == %@", identifier)
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = fetchPredicate
        do {
            let fetchedObject = try managedContext.executeFetchRequest(fetchRequest)
            // Decrypted object
            var dictionary: [String : String] = ["" : ""]
            let object = fetchedObject[0] as! NSManagedObject
            if let idEntity = object.valueForKey("idEntity"), dataEntity = object.valueForKey("dataEntity") {
                // Decryption
                do {
                    let originalData: NSData = try RNCryptor.decryptData(dataEntity as! NSData, password: passwordForEncripted)
                    // Convert data to dictionary
                    dictionary = (NSKeyedUnarchiver.unarchiveObjectWithData(originalData)! as? [String : String])!
                    return dictionary
                } catch {
                    print(error)
                }
            }
            return nil
        } catch let error as NSError {
            fatalError("Failed to fetch entity: \(error)")
        }
    }
    
    /**
     Get objects from Core Data
     - parameter entityName: Entity name for get object
     - parameter passwordForEncrypted: String for use like password for encrypted in Core Data
     - returns: Objects (array with dictionaries) or nil
     */
    public class func getObjectsFromCoreData(entityName: String, passwordForEncripted: String) -> Array<[String : String]> {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entityName)
        // Array for return with data or empty
        var array: Array<[String : String]> = []
        do {
            let fetchedObject = try managedContext.executeFetchRequest(fetchRequest)
            // Decrypted object
            var dictionary: [String : String] = ["" : ""]
            for object in fetchedObject {
                if let idEntity = object.valueForKey("idEntity"), dataEntity = object.valueForKey("dataEntity") {
                    // Decryption
                    do {
                        let originalData: NSData = try RNCryptor.decryptData(dataEntity as! NSData, password: passwordForEncripted)
                        // Convert data to dictionary
                        dictionary = (NSKeyedUnarchiver.unarchiveObjectWithData(originalData)! as? [String : String])!
                        array.insert(dictionary, atIndex: 0)
                    } catch {
                        print(error)
                    }
                }
            }
            return array
        } catch {
            fatalError("Failed to fetch entity: \(error)")
        }
    }
    
    /**
     Delete all data from Entity in Core Data
     - returns: results with Bool
     */
    public class func deleteAllInCoreData() -> Bool {
        let managedContext = CDGCoreDataDataController.sharedInstance.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
            print("All entities delete from Core Data")
            return true
        } catch let error as NSError {
            print("Delete all data in Object entity with error : \(error) \(error.userInfo)")
            return false
        }
    }
}