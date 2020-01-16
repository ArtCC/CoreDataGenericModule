//
//  Utils.swift
//  CoreDataGenericModule
//
//  Created by Arturo Carretero Calvo on 16/01/2020.
//  Copyright © 2020 Arturo Carretero Calvo. All rights reserved.
//

import UIKit

/// Show print only in debug
/// - Parameter items: string
public func printDebug(_ items: String) {
    if Utils.checkIfDEBUG() {
        print(items)
    }
}

/**
 Utils class: for functions necessary in all project
 */
class Utils: NSObject {
    
    /// Function for check is app in debuf or not
    ///
    /// - Returns: Bool value
    static func checkIfDEBUG() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
