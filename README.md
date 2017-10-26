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
AzureData.create(databaseWithId: id) { r in
    // database = r.resource
}
```

#### List
```swift
AzureData.databases { r in
    // databases = r.resource?.items
}
```

#### Get
```swift
AzureData.get(databaseWithId: id) { r in
    // database = r.resource
}
```

#### Delete
```swift
AzureData.delete(database) { s in
    // s == successfully deleted
}
```



## Collections

#### Create
```swift
AzureData.create(collectionWithId: id, in: databaseId) { r in
    // collection = r.resource
}

// using an instance of `ADDatabase`:
database.create(collectionWithId: id) { r in
    // collection = r.resource
}
```

#### List
```swift
AzureData.get(collectionsIn: databaseId) { r in
    // collections = r.resource?.items
}

// using an instance of `ADDatabase`
database.getCollections () { r in
    // collections = r.resource?.items
}
```

#### Get
```swift
AzureData.get(collectionWithId: id, in: databaseId) { r in
    // collection = r.resource
}

// using an instance of `ADDatabase`
database.get (collectionWithId: id) { r in
    // collection = r.resource
}
```

#### Delete
```swift
AzureData.delete(collection, from: databaseId) { s in
    // s == successfully deleted
}

// using an instance of `ADDatabase`
database.delete (collection: collection) { s in
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
			
AzureData.create(document, inCollection: collectionId, in: databaseId) { r in
    // document = r.resource
}

// using an instance of `ADCollection`
AzureData.create(document, in: collection) { r in
    // document = r.resource
}

// directly from an instance of `ADCollection`
collection.create (document: document) { r in
    // document = r.resource
}
```

#### List
```swift
AzureData.get(documentsAs: documentType, inCollection: collectionId, in: databaseId) { r in
    // documents = r.resource?.items
}

// using an instance of `ADCollection`
AzureData.get(documentsAs: documentType, in: collection) { r in
    // documents = r.resource?.items
}

// directly from an instance of `ADCollection`
collection.get (documentsAs: ADDocument.self) { r in
    // documents in r.resource?.list
}
```

#### Get
```swift
AzureData.get(documentWithId: documentId, as: documentType, inCollection: collectionId, in: databaseId) { r in
    // document = r.resource
}

// using an instance of `ADCollection`
AzureData.get(documentWithId: resourceId, as: documentType, in: collection) { r in
    // document = r.resource
}

// directly from an instance of `ADCollection`
collection.get(documentWithResourceId: documentId: as: ADDocument.self) { r in
    // document = r.resource
}
```

#### Delete
```swift
AzureData.delete(document, fromCollection: collectionId, in: databaseId) { r in
    // document = r.resource
}

// using an instance of `ADCollection`
AzureData.delete(document, from: collection) { r in
    // document = r.resource
}

// directly from an instance of `ADCollection`
collection.delete (document: document) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace(document, inCollection: collectionId, in: databaseId) { r in
    // document = r.resource
}

// using an instance of `ADCollection`
AzureData.replace(document, in: collection) { r in
    // document = r.resource
}

// directly from an instance of `ADCollection`
collection.replace (document: document) { r in
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

AzureData.query(documentsIn: collectionId, in: databaseId, with: query) { r in
    // documents = r.resource?.items
}

// using an instance of `ADCollection`
AzureData.query(documentsIn: collection, with: query) { r in
    // documents = r.resource?.items
}

// directly from an instance of `ADCollection`
collection.query (documentsWith: query) { r in
    // documents in r.resource?.list
}
```



## Attachments

#### Create
```swift
// link to existing media asset:
AzureData.createAttachment(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaUrl: mediaUrl) { r in
    // attachment = r.resource
}

//or upload the media directly:
AzureData.createAttachment(databaseId, collectionId: collectionId, documentId: documentId, contentType: contentType, mediaName: mediaName, media: media) { r in
    // attachment = r.resource
}
```

#### List
```swift
AzureData.attachemnts(databaseId, collectionId: collectionId, documentId: documentId) { r in
    // attachments = r.resource?.items
}
```

#### Delete
```swift
AzureData.delete (attachment, databaseId: databaseId, collectionId: collectionId, documentId: documentId) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
// link to existing media asset:
AzureData.replace(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaUrl: mediaUrl) { r in
    // att
    achment = r.resource
}

// or upload the media directly:
AzureData.replace(databaseId, collectionId: collectionId, documentId: documentId, attachmentId: attachmentId, contentType: contentType, mediaName: mediaName, media: media) { r in
    // attachment = r.resource
}
```



## Stored Procedures

#### Create
```swift
AzureData.createStoredProcedure (databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId, body: body) { r in
    // storedProcedure = r.resource
}

// using an instance of `ADCollection`
collection.create (storedProcedureWithId: storedProcedureId, andBody: body) { r in
    // storedProcedure = r.resource
}
```

#### List
```swift
AzureData.storedProcedures(databaseId, collectionId: collectionId) { r in
    // storedProcedures = r.resource?.items
}

// using an instance of `ADCollection`
collection.getStoredProcedures () { r in
    // storedProcedures in r.resource?.list
}
```

#### Delete
```swift
AzureData.delete(storedProcedure, databaseId: databaseId, collectionId: collectionId) { s in
    // s == successfully deleted
}

// using an instance of `ADCollection`
collection.delete (storedProcedure) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId, body: body) { r in
    // storedProcedure = r.resource
}

// using an instance of `ADCollection`
collection.replace (storedProcedureWithId: storedProcedureId, andBody: body) { r in
    // storedProcedure = r.resource
}
```

#### Execute
```swift
AzureData.execute (databaseId, collectionId: collectionId, storedProcedureId: storedProcedureId, parameters: parameters) { data in
    // data = response from stored procedure
}

// using an instance of `ADCollection`
collection.execute (storedProcedureWithId: storedProcedureId, usingParameters: parameters) { data in
    // data = response from stored procedure
}
```



## User Defined Functions

#### Create
```swift
AzureData.createUserDefinedFunction (databaseId, collectionId: collectionId, functionId: functionId, body: body) { r in
    // userDefinedFunction = r.resource
}

// using an instance of `ADCollection`
collection.create (userDefinedFunctionWithId: userDefinedFunctionId, andBody: body) { r in
    // userDefinedFunction = r.resource
}
```

#### List
```swift
AzureData.userDefinedFunctions(databaseId, collectionId: collectionId) { r in
    // udfs = r.resource?.items
}

// using an instance of `ADCollection`
collection.getUserDefinedFunctions () { r in
    // userDefinedFunctions in r.resource?.list
}
```

#### Delete
```swift
AzureData.delete(udf, databaseId: databaseId, collectionId: collectionId) { s in
    // s == successfully deleted
}

// using an instance of `ADCollection`
collection.delete (userDefinedFunction) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (databaseId, collectionId: collectionId, functionId: functionId, body: body) { r in
    // userDefinedFunction = r.resource
}

// using an instance of `ADCollection`
collection.replace (userDefinedFunctionWithId: userDefinedFunctionId, andBody: body) { r in
    // userDefinedFunction = r.resource
}
```



## Triggers

#### Create
```swift
AzureData.createTrigger (databaseId, collectionId: collectionId, triggerId: triggerId, triggerBody: triggerBody, operation: operation, triggerType: triggerType) { r in
    // trigger = r.resource
}

// using an instance of `ADCollection`
collection.create (triggerWithId: triggerId, andBody: body, operation: operation, type: type) { r in
    // trigger = r.resource
}
```

#### List
```swift
AzureData.triggers(databaseId, collectionId: collectionId) { r in
    // triggers = r.resource?.items
}

// using an instance of `ADCollection`
collection.getTriggers () { r in
    // triggers in r.resource?.list
}
```

#### Delete
```swift
AzureData.delete(trigger, databaseId: databaseId, collectionId: collectionId) { s in
    // s == successfully deleted
}

// using an instance of `ADCollection`
collection.delete (trigger) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (databaseId, collectionId: collectionId, triggerId: triggerId, triggerBody: triggerBody, operation: operation, triggerType: triggerType) { r in
    // trigger = r.resource
}

// using an instance of `ADCollection`
collection.replace (triggerWithId: triggerId, andBody: body, operation: operation, type: type) { r in
    // trigger = r.resource
}
```



## Users	

#### Create
```swift
AzureData.createUser(databaseId, userId: userId) { r in
    // user = r.resource
}

// using an instance of `ADDatabase`
database.create (userWithId: userId) { r in
    // user = r.resource
}
```

#### List
```swift
AzureData.users(databaseId) { r in
    // users = r.resource?.items
}

// using an instance of `ADDatabase`
database.getUsers () { r in
    // users = r.resource?.items
}
```

#### Get
```swift
AzureData.user(databaseId, userId: userId) { r in
    // user = r.resource
}

// using an instance of `ADDatabase`
database.get (userWithId: userId) { r in
    // user = r.resource
}
```

#### Delete
```swift
AzureData.delete(user, databaseId: databaseId) { s in
    // s == successfully deleted
}

// using an instance of `ADDatabase`
database.delete (user: user) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (databaseId, userId: userId, newUserId: userId) { r in
    // user = r.resource
}

// using an instance of `ADDatabase`
database.replace (userWithId: userId) { r in
    // user = r.resource
}
```



## Permissions	

#### Create
```swift
AzureData.createPermission (resource, databaseId: databaseId, userId: userId, permissionId: permissionId, permissionMode: permissionMode) { r in
    // permission = r.resource
}
```

#### List
```swift
AzureData.permissions (databaseId, userId: databaseId) { r in
    // permissions = r.resource?.items
}
```

#### Get
```swift
AzureData.permission (databaseId, userId: String, permissionId: permissionId) { r in
    // permission = r.resource
}
```

#### Delete
```swift
AzureData.delete(permission, databaseId: databaseId, collectionId: collectionId, userId: userId) { s in
    // s == successfully deleted
}
```

#### Replace
```swift
AzureData.replace (databaseId, userId: userId, permissionId: permissionId, permissionMode: permissionMode, resource: resource) { r in
    // permission = r.resource
}
```



## Offers

#### Lists
```swift
AzureData.offers { r in
    // offers = r.resource?.items
}
```

#### Get
```swift
AzureData.offer(offerId) { r in
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
