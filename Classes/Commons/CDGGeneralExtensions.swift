//
//  CDGGeneralExtensions.swift
//  CoreDataGenericModule
//
//  Created by Arturo Carretero Calvo on 27/10/16.
//  Copyright © 2016 Arturo Carretero Calvo. All rights reserved.
//

import Foundation

// MARK: - String extension

/**
 String extension
 */
extension String {
    /**
     Localize string
     */
    var localized: String {
        if let bundle: NSBundle = NSBundle(identifier: CDGGeneralDefineConstants.kSDKBundle) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        } else {
            return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
        }
    }
}