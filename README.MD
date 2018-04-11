# Core Data generic module

## Description

This module serves to persist generic objects in Core Data with id as primary key to find them easily.
The object is encrypted with password.
For encryption and decryption use (include in module and install automatically with pod like dependency):

`https://github.com/RNCryptor/RNCryptor`

Install from cocoapods with:

```
pod 'CoreDataGenericModule', :git => "https://github.com/ArtCC/CoreDataGenericModule.git"
```

Available from iOS 8++ and Swift 3.0

## Implementation:

### Model:

```
CDGModel.xcdatamodeld
```

Only one entity with two properties:

```
Object => idEntity (String) and dataEntity (Binary Data)
```

This module are composed with two classes and one protocol:

### Classes:

##### CDGCoreDataDataController.swift => Init context and model

For init context and model only:

```
CDGCoreDataDataController.sharedInstance
```

##### CDGCoreDataEngine.swift => For save, delete, search, etc.

Save an object given a dicionary and the name of Entity in CoreData

- parameter object: Object model implement CDGCoreDataProtocol
- parameter passwordForEncrypted: String for use like password for encrypted in Core Data
- returns: results with Bool

```
func saveObject(object: CDGCoreDataProtocol, passwordForEncrypted: String) -> Bool
```

Delete entity given the key and value

- parameter identifier: Object identifier
- returns: results with Bool

```
func deleteObjectWithIdentifier(identifier: String) -> Bool
```

Get any object from Core Data

- parameter identifier: Object identifier
- parameter passwordForEncrypted: String for use like password for encrypted in Core Data
- returns: object

```
func getObjectWithIdentifier(identifier: String) -> AnyObject?
```

Get objects from Core Data

- parameter entityName: Entity name for get object
- parameter passwordForEncrypted: String for use like password for encrypted in Core Data
- returns: Objects (array with dictionaries) or nil

```
func getObjectsFromCoreData(entityName: String, passwordForEncripted: String) -> Array<[String : String]>
```

Delete all data from Entity in Core Data

- returns: results with Bool

```
func deleteAllInCoreData() -> Bool
```

### Protocol (The model that will be persisted should form this protocol):

##### CDGCoreDataProtocol.swift

```
public protocol CDGCoreDataProtocol {
    /**
     *  Implement in model class. Return the object given a dictionary
     */
    init(dictionary: [String: String])
    
    /**
     *  Implement in model class. Return a dictionary (key - value) with the properties of the class
     */
    func saveAsDictionary() -> NSDictionary
    
    /**
     * Set the unique identifier of the class
     */
    func uniqueIdentifier() -> String
}
```

### Example of implementation in model:

```
import Foundation
import CoreDataGenericModule

/**
 User class
 */
class User: NSObject, CDGCoreDataProtocol {
    /**
     Id card for user object model
     */
    var idCard: String = ""
    
    /**
     Name for user object model
     */
    var name: String = ""
    
    /**
     Init for object model
     - parameter idCard: idCard description
     - parameter name:   name description
     - returns: object init
     */
    init(idCard: String, name: String) {
        self.idCard = idCard
        self.name = name
    }
    
    // MARK: CDGCoreDataProtocol
    
    required init(dictionary: [String: String]) {
        idCard = dictionary["idCard"]!
        name = dictionary["name"]!
    }
    
    func saveAsDictionary() -> NSDictionary {
        return [
            "idCard" : idCard,
            "name" : name
        ]
    }
    
    func uniqueIdentifier() -> String {
        return idCard
    }
}
```
