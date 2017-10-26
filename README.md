# Azure.iOS

| App        | Status          |
| ---------- | --------------- |
| AzureData  | ![Build status][app-data-build-status] |


# API

The following usage examples are abbreviated, complete examples can be found in the [Wiki](/wiki/DocumentDB)


## Setup

```swift
AzureData.setup("cosmosDb name", key: "read-write key", keyType: .master)
```


## Databases

#### Create
```swift
AzureData.create (databaseWithId: id) { r in
    // database = r.resource
}
```

#### List
```swift
AzureData.databases () { r in
    // databases = r.resource?.items
}
```

#### Get
```swift
AzureData.get (databaseWithId: id) { r in
    // database = r.resource
}
```

#### Delete
```swift
AzureData.delete (database) { s in
    // s == successfully deleted
}
```



## Collections

#### Create
```swift
AzureData.create (collectionWithId: id, inDatabase: databaseId) { r in
    // collection = r.resource
}
// or
database.create (collectionWithId: id) { r in
    // collection = r.resource
}
```

#### List
```swift
AzureData.get (collectionsIn: databaseId) { r in
    // collections = r.resource?.items
}
// or
database.getCollections () { r in
    // collections = r.resource?.items
}
```

#### Get
```swift
AzureData.get (collectionWithId: id, inDatabase: databaseId) { r in
    // collection = r.resource
}
// or
database.get (collectionWithId: id) { r in
    // collection = r.resource
}
```

#### Delete
```swift
AzureData.delete (collection, from: databaseId) { s in
    // s == successfully deleted
}
// or
database.delete (collection) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
// TODO...
```



## Documents

#### Create
```swift
let newDocument = ADDocument()
			
newDocument["aNumber"] = 1_500_000
newDocument["aString"] = "Hello!"
			
AzureData.create (document, inCollection: collectionId, inDatabase: databaseId) { r in
    // document = r.resource
}
// or
AzureData.create (document, in: collection) { r in
    // document = r.resource
}
// or
collection.create (document) { r in
    // document = r.resource
}
```

#### List
```swift
AzureData.get (documentsAs: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
    // documents = r.resource?.items
}
// or
AzureData.get (documentsAs: ADDocument.self, in: collection) { r in
    // documents = r.resource?.items
}
// or
collection.get (documentsAs: ADDocument.self) { r in
    // documents in r.resource?.list
}
```

#### Get
```swift
AzureData.get (documentWithId: id, as: ADDocument.self, inCollection: collectionId, inDatabase: databaseId) { r in
    // document = r.resource
}
// or
AzureData.get (documentWithId: id, as: ADDocument.self, in: collection) { r in
    // document = r.resource
}
// or
collection.get (documentWithResourceId: id: as: ADDocument.self) { r in
    // document = r.resource
}
```

#### Delete
```swift
AzureData.delete (document, fromCollection: collectionId, inDatabase: databaseId) { r in
    // document = r.resource
}
// or
AzureData.delete (document, from: collection) { r in
    // document = r.resource
}
// or
collection.delete (document) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (document, inCollection: collectionId, inDatabase: databaseId) { r in
    // document = r.resource
}
// or
AzureData.replace (document, in: collection) { r in
    // document = r.resource
}
// or
collection.replace (document) { r in
    // document = r.resource
}
```

#### Query
```swift
let query = ADQuery.select("firstName", "lastName", ...)
                   .from("People")
                   .where("firstName", is: "Colby")
                   .and("lastName", is: "Williams")
                   .and("age", isGreaterThanOrEqualTo: 20)
                   .orderBy("_etag", descending: true)

AzureData.query(documentsIn: collectionId, inDatabase: databaseId, with: query) { r in
    // documents = r.resource?.items
}
// or
AzureData.query(documentsIn: collection, with: query) { r in
    // documents = r.resource?.items
}
// or
collection.query (documentsWith: query) { r in
    // documents in r.resource?.list
}
```



## Attachments

#### Create
```swift
// link to existing media asset:
AzureData.create (attachmentWithId: id, contentType: "image/png", andMediaUrl: url, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
	// attachment = r.resource
}

//or upload the media directly:
AzureData.create (attachmentWithId: id, contentType: "image/png", name: "file.png", with: media, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
	// attachment = r.resource
}
```

#### List
```swift
AzureData.get (attachmentsOn: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
	// attachments = r.resource
}
```

#### Delete
```swift
AzureData.delete (attachment, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { s in
	// s == successfully deleted
}
```

#### Replace
```swift
// link to existing media asset:
AzureData.replace(attachmentWithId: id, contentType: "image/png", andMediaUrl: url, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
	// attachment = r.resource
}

// or upload the media directly:
AzureData.replace(attachmentWithId: id, contentType: "image/png", name: "file.png", with: media, onDocument: documentId, inCollection: collectionId, inDatabase: databaseId) { r in
	// attachment = r.resource
}
```



## Stored Procedures

#### Create
```swift
AzureData.create (storedProcedureWithId: id, andBody: body, inCollection: collectionId, inDatabase: databaseId) { r in
	// storedProcedure = r.resource
}

AzureData.create (storedProcedureWithId: id, andBody: body, in: collection) { r in
	// storedProcedure = r.resource
}
// or
collection.create (storedProcedureWithId: storedProcedureId, andBody: body) { r in
    // storedProcedure = r.resource
}
```

#### List
```swift
AzureData.get (storedProceduresIn: collectionId, inDatabase: databaseId) { r in
	// storedProcedures = r.resource?.items
}

AzureData.get (storedProceduresIn: collection) { r in
	// storedProcedures = r.resource?.items
}
// or
collection.getStoredProcedures () { r in
    // storedProcedures in r.resource?.list
}
```

#### Delete
```swift
AzureData.delete (storedProcedure, fromCollection: collectionId, inDatabase: databaseId) { s in
	// s == successfully deleted
}

AzureData.delete (storedProcedure, from: collection) { s in
	// s == successfully deleted
}
// or
collection.delete (storedProcedure) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (storedProcedureWithId: id, andBody: body, inCollection: collectionId, inDatabase: databaseId) { r in
	// storedProcedure = r.resource
}

AzureData.replace (storedProcedureWithId: id, andBody: body, in: collection) { r in
	// storedProcedure = r.resource
}
// or
collection.replace (storedProcedureWithId: storedProcedureId, andBody: body) { r in
    // storedProcedure = r.resource
}
```

#### Execute
```swift
AzureData.execute (storedProcedureWithId: id, usingParameters: [], inCollection: collectionId, inDatabase: databaseId) { r in
	// r = raw response data
}

AzureData.execute (storedProcedureWithId: id, usingParameters: [], in: collection) { r in
	// r = raw response data
}
// or
collection.execute (storedProcedureWithId: storedProcedureId, usingParameters: parameters) { data in
    // data = response from stored procedure
}
```



## User Defined Functions

#### Create
```swift
AzureData.create (userDefinedFunctionWithId: id, andBody: body, inCollection: collectionId, inDatabase: databaseId) { r in
	// userDefinedFunction = r.resource
}

AzureData.create (userDefinedFunctionWithId: id, andBody: body, in: collection) { r in
	// userDefinedFunction = r.resource
}
// or
collection.create (userDefinedFunctionWithId: userDefinedFunctionId, andBody: body) { r in
    // userDefinedFunction = r.resource
}
```

#### List
```swift
AzureData.get (userDefinedFunctionsIn: collectionId, inDatabase: databaseId) { r in
	// userDefinedFunction = r.resource?.items
}

AzureData.get (userDefinedFunctionsIn: collection) { r in
	// userDefinedFunction = r.resource?.items
}
// or
collection.getUserDefinedFunctions () { r in
    // userDefinedFunctions in r.resource?.list
}
```

#### Delete
```swift
AzureData.delete (userDefinedFunction, fromCollection: collectionId, inDatabase: databaseId) { s in
	// s == successfully deleted
}

AzureData.delete (userDefinedFunction, from: collection) { s in
	// s == successfully deleted
}
// or
collection.delete (userDefinedFunction) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (userDefinedFunctionWithId: id, andBody: body, inCollection: collectionId, inDatabase: databaseId) { r in
	// userDefinedFunction = r.resource
}

AzureData.replace (userDefinedFunctionWithId: id, andBody: body, from: collection) { r in
	// userDefinedFunction = r.resource
}
// or
collection.replace (userDefinedFunctionWithId: userDefinedFunctionId, andBody: body) { r in
    // userDefinedFunction = r.resource
}
```



## Triggers

#### Create
```swift
AzureData.create (triggerWithId: id, operation: .all, type: .pre, andBody: body, inCollection: collectionId, inDatabase: databaseId) { r in
	// trigger = r.resource
}

AzureData.create (triggerWithId: id, operation: .all, type: .pre, andBody: bosy, in: collection) { r in
	// trigger = r.resource
}
// or
collection.create (triggerWithId: triggerId, andBody: body, operation: operation, type: type) { r in
    // trigger = r.resource
}
```

#### List
```swift
AzureData.get (triggersIn: collectionId, inDatabase: databaseId) { r in
	// triggers = r.resource?.items
}

AzureData.get (triggersIn: collection) { r in
	// triggers = r.resource?.items
}
// or
collection.getTriggers () { r in
    // triggers in r.resource?.list
}
```

#### Delete
```swift
AzureData.delete (trigger, fromCollection: collectionId, inDatabase: databaseId) { s in
	// s == successfully deleted
}

AzureData.delete (trigger, from: collection) { s in
	// s == successfully deleted
}
// or
collection.delete (trigger) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (triggerWithId: id, operation: .all, type: .pre, andBody: body, inCollection: collectionId, inDatabase: databaseId) { r in
	// trigger = r.resource
}

AzureData.replace (triggerWithId: id, operation: .all, type: .pre, andBody: body, in: collection) { r in
	// trigger = r.resource
}
// or
collection.replace (triggerWithId: triggerId, andBody: body, operation: operation, type: type) { r in
    // trigger = r.resource
}
```



## Users	

#### Create
```swift
AzureData.create (userWithId: id, inDatabase: databaseId) { r in
	// user = r.resource
}
// or
database.create (userWithId: userId) { r in
    // user = r.resource
}
```

#### List
```swift
AzureData.get (usersIn: databaseId) { r in
	// users = r.resource?.items
}
// or
database.getUsers () { r in
    // users = r.resource?.items
}
```

#### Get
```swift
AzureData.get (userWithId: id, inDatabase: databaseId) { r in
	// user = r.resource
}
// or
database.get (userWithId: userId) { r in
    // user = r.resource
}
```

#### Delete
```swift
AzureData.delete (user, fromDatabase: databaseId) { s in
	// s == successfully deleted
}
// or
database.delete (user: user) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (userWithId: id, with: newUserId, inDatabase: databaseId) { r in
	// user = r.resource
}
// or
database.replace (userWithId: userId) { r in
    // user = r.resource
}
```



## Permissions	

#### Create
```swift
AzureData.create (permissionWithId: id, mode: .read, in: resource, forUser: userId, inDatabase: databaseId) { r in
	// permission = r.resource
}
```

#### List
```swift
AzureData.get (permissionsFor: userId, inDatabase: databaseId) { r in
	// permissions = r.resource
}
```

#### Get
```swift
AzureData.get (permissionWithId: id, forUser: userId, inDatabase: databaseId) { r in
	// permission = r.resource
}
```

#### Delete
```swift
AzureData.delete (permission, forUser: userId, inDatabase: databaseId) { s in
	// s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (permissionWithId: id, mode: .read, in: resource, forUser: userId, inDatabase: databaseId) { r in
	// permission = r.resource
}
```



## Offers

#### Lists
```swift
AzureData.offers() { r in
// offers = r.resource?.items
}
```

#### Get
```swift
AzureData.get (offerWithId: id) { r in
	// offer = r.resource
}
```

#### Replace
```swift
// TODO...
```

#### Query
```swift
// TODO...
```






[app-data-build-status]:https://build.mobile.azure.com/v0.1/apps/359067a7-aa63-4c29-ac2e-bd9d29c086dc/branches/master/badge
