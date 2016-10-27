//
//  CDGCoreDataDataController.swift
//  CoreDataGenericModule
//
//  Created by Arturo Carretero Calvo on 27/10/16.
//  Copyright © 2016 Arturo Carretero Calvo. All rights reserved.
//

import Foundation
import CoreData

/**
 CDGCoreDataDataController class: for create context and data base model
 */
public class CDGCoreDataDataController: NSObject {
    // MARK: - Public properties
    
    /**
     Manage object context
     */
    public var managedObjectContext: NSManagedObjectContext
    
    /**
     Singleton for Core Data Controller class
     */
    public class var sharedInstance: CDGCoreDataDataController {
        struct Static {
            static var instance: CDGCoreDataDataController?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = CDGCoreDataDataController()
            initialize()
        }
        return Static.instance!
    }
    
    /**
     Init
     - returns: Init for Core Data Stack
     */
    public override init() {
        // This resource is the same name as your xcdatamodeld contained in your project
        let bundle: NSBundle = NSBundle(identifier: CDGGeneralDefineConstants.kSDKBundle)!
        guard let modelURL = bundle.URLForResource("CDGModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "CDGModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.URLByAppendingPathComponent("CDGModel.sqlite")
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}