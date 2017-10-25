# Azure.iOS

| App        | Status          |
| ---------- | --------------- |
| AzureData  | ![Build status][app-data-build-status] |


# API

## Setup

```swift
AzureData.setup("cosmosDb name", key: "read-write key", keyType: .master)
```


## Databases

### Create

```swift
AzureData.createDatabase(newDatabaseId) { response in
    if let database = response.resource {
        print(database)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

### List

```swift
AzureData.databases { response in
    if let databases = response.resource?.items {
        print(databases)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Get

```swift
AzureData.database(databaseId) { response in
    if let database = response.resource {
        print(database)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

### Delete

```swift
AzureData.delete(databaseId) { success in
    if success { /* successfully deleted */ }
}
```

## DocumentCollections

### Create

```swift
AzureData.createDocumentCollection(databaseId, collectionId: newCollectionId) { response in
    if let collection = response.resource {
        print(collection)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDatabase`:
```swift
database.create(collectionWithId: newCollectionId) { response in
    if let collection = response.resource {
        print(collection)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

### List

```swift
AzureData.documentCollections(databaseId) { response in
    if let collections = response.resource?.items {
        print(collections)
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.getCollections () {
    if let collections = response.resource?.items {
        print(collections)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Get

```swift
AzureData.documentCollection(databaseId, collectionId: collectionId) { response in
    if let collection = response.resource {
        print(collection)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.get (collectionWithId: newCollectionId) { response in
    if let collection = response.resource {
        print(collection)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete(collection, databaseId: databaseId) { success in
    if success { /* successfully deleted */ }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.delete (collection: collection) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```



## Documents

### Create

```swift
let newDocument = ADDocument()
			
newDocument["aNumber"] = 1_500_000
newDocument["aString"] = "Hello!"
			
AzureData.createDocument(databaseId, collectionId: collectionId, document: newDocument) { response in
    if let document = response.resource {
        print(document)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.create<T: ADDocument> (document: newDocument) { response in
    if let document = response.resource {
        print (document)
    } else if error = response.error {
        error.printLog()
    }
}
```

### List

```swift
AzureData.documents(ADDocument.self, databaseId: databaseId, collectionId: collectionId) { response in
    if let documents = response.resource?.items {
        print(documents)
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.get<T: ADDocument> (documentsAs: ADDocument.self) { response in
    if let documents in response.resource?.list {
        print(documents)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Get

```swift
AzureData.document(ADDocument.self, databaseId: databaseId, collectionId: collectionId, documentId: documentId) { response in
    if let document = response.resource {
        print(document)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.get(documentWithResourceId: documentId: as: ADDocument.self) { response in
    if let document = response.resource {
        print (document)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete(document, databaseId: databaseId, collectionId: collectionId) { success in
    if success { /* successfully deleted */ }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.delete (document: document) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
AzureData.replace(databaseId, collectionId: collectionId, document: newDocument) { response in
    if let document = response.resource {
        print(document)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.replace (document: document) { response in
    if let document = response.resource {
        print (document)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Query

```swift
let query = ADQuery.select("firstName", "lastName", ...)
                   .from("People")
                   .where("firstName", is: "Colby")
                   .and("lastName", is: "Williams")
                   .and("age", isGreaterThanOrEqualTo: 20)
                   .orderBy("_etag", descending: true)

AzureData.query(databaseId, collectionId: documentCollectionId, query: query) { response in
    if let items = response.resource?.items {
        for item in items {
            print(item)
        }
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.query (documentsWith: query) { response in
    if let documents in response.resource?.list {
        print(documents)
    } else if error = response.error {
        error.printLog()
    }
}
```


## Attachments

### Create

```swift
// TODO...
```

### List

```swift
AzureData.attachemnts(databaseId, collectionId: collectionId, documentId: documentId) { response in
    if let attachments = response.resource?.items {
        print(attachments)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete (attachment, databaseId: databaseId, collectionId: collectionId, documentId: documentId) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```



## Stored Procedures

### Create

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.create (storedProcedureWithId: storedProcedureId, andBody: body) { response in
    if let storedProcedure = response.resource {
        print (storedProcedure)
    } else if error = response.error {
        error.printLog()
    }
}
```

### List

```swift
AzureData.storedProcedures(databaseId, collectionId: collectionId) { response in
    if let storedProcedures = response.resource?.items {
        print(storedProcedures)
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.getStoredProcedures () { response in
    if let storedProcedures in response.resource?.list {
        print(storedProcedures)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete(storedProcedure, databaseId: databaseId, collectionId: collectionId) { success in
    if success { /* successfully deleted */ }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.delete (storedProcedure) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.replace (storedProcedureWithId: storedProcedureId, andBody: body) { response in
    if let storedProcedure = response.resource {
        print (storedProcedure)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Execute

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.execute (storedProcedureWithId: storedProcedureId, usingParameters: parameters) { data in
    
}
```


## User Defined Functions

### Create

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.create (userDefinedFunctionWithId: userDefinedFunctionId, andBody: body) { response in
    if let userDefinedFunction = response.resource {
        print (userDefinedFunction)
    } else if error = response.error {
        error.printLog()
    }
}
```

### List

```swift
AzureData.userDefinedFunctions(databaseId, collectionId: collectionId) { response in
    if let udfs = response.resource?.items {
        print(udfs)
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.getUserDefinedFunctions () { response in
    if let userDefinedFunctions in response.resource?.list {
        print(userDefinedFunctions)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete(udf, databaseId: databaseId, collectionId: collectionId) { success in
    if success { /* successfully deleted */ }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.delete (userDefinedFunction) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.replace (userDefinedFunctionWithId: userDefinedFunctionId, andBody: body) { response in
    if let userDefinedFunction = response.resource {
        print (userDefinedFunction)
    } else if error = response.error {
        error.printLog()
    }
}
```


## Triggers

### Create

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.create (triggerWithId: triggerId, andBody: body, operation: operation, type: type) { response in
    if let trigger = response.resource {
        print (trigger)
    } else if error = response.error {
        error.printLog()
    }
}
```

### List

```swift
AzureData.triggers(databaseId, collectionId: collectionId) { response in
    if let triggers = response.resource?.items {
        print(triggers)
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.getTriggers () { response in
    if let triggers in response.resource?.list {
        print(triggers)
    } else if error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete(trigger, databaseId: databaseId, collectionId: collectionId) { success in
    if success { /* successfully deleted */ }
}
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.delete (trigger) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```

Or directly from an instance of `ADDocumentCollection`
```swift
collection.replace (triggerWithId: triggerId, andBody: body, operation: operation, type: type) { response in
    if let trigger = response.resource {
        print (trigger)
    } else if error = response.error {
        error.printLog()
    }
}
```



## Users	

### Create

```swift
AzureData.createUser(databaseId, userId: newUserId) { response in
    if let user = response.resource {
        print(user)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.create (userWithId: newUserId) { response in
    if let user = response.resource {
        print(user)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### List

```swift
AzureData.users(databaseId) { response in
    if let users = response.resource?.items {
        print(users)
    } else if let error = response.error {
        error.printLog()
    }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.getUsers () {
    if let users = response.resource?.items {
        print(users)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Get

```swift
AzureData.user(databaseId, userId: userId) { response in
    if let user = response.resource {
        print(user)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.get (userWithId: newUserId) { response in
    if let user = response.resource {
        print(user)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Delete

```swift
AzureData.delete(user, databaseId: databaseId) { success in
    if success { /* successfully deleted */ }
}
```

Or directly from an instance of `ADDatabase`
```swift
database.delete (user: user) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```



## Permissions	

### Create

```swift
// TODO...
```

### List

```swift
AzureData.permissions (databaseId, userId: databaseId) { response in
    if let permissions = response.resource?.items {
        print(permissions)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Get

```swift
AzureData.permission (databaseId, userId: String, permissionId: permissionId) { response in
    if let permission = response.resource {
        print(permission)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

### Delete

```swift
AzureData.delete(permission, databaseId: databaseId, collectionId: collectionId, userId: userId) { success in
    if success { /* successfully deleted */ }
}
```

### Replace

```swift
// TODO...
```

## Offers

### List

```swift
AzureData.offers { response in
    if let offers = response.resource?.items {
        print(offers)
    } else if let error = response.error {
        error.printLog()
    }
}
```

### Get

```swift
AzureData.offer(offerId) { response in
    if let offer = response.resource {
        print(offer)
    } else if let error = response.error {
        error.pringLog()
    }
}
```

### Replace

```swift
// TODO...
```

### Query

```swift
// TODO...
```







[app-data-build-status]:https://build.mobile.azure.com/v0.1/apps/359067a7-aa63-4c29-ac2e-bd9d29c086dc/branches/master/badge
