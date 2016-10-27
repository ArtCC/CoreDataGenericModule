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
open class CDGCoreDataDataController: NSObject {
    // MARK: - Public properties
    
    public static let sharedInstance: CDGCoreDataDataController = {
        let instance = CDGCoreDataDataController()
        return instance
    }()

    /**
     Manage object context
     */
    open var managedObjectContext: NSManagedObjectContext
    
    /**
     Init
     - returns: Init for Core Data Stack
     */
    public override init() {
        // This resource is the same name as your xcdatamodeld contained in your project
        let bundle: Bundle = Bundle(for: CDGCoreDataDataController.self)
        guard let modelURL = bundle.url(forResource: "CDGModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "CDGModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("CDGModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}
