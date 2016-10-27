//
//  CDGCoreDataProtocol.swift
//  CoreDataGenericModule
//
//  Created by Arturo Carretero Calvo on 27/10/16.
//  Copyright © 2016 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

/**
 Core Data protocol for implement in model class of app from Core Data module
 */
public protocol CDGCoreDataProtocol {
    /**
     *  Implement in model class. Return the object given a dictionary
     */
    init(dictionary: [String: String])
    
    /**
     *  Implement in model class. Return a dictionary (key - value) with the properties of the class
     */
    func saveAsDictionary() -> [String: String]
    
    /**
     * Set the unique identifier of the class
     */
    func uniqueIdentifier() -> String
}