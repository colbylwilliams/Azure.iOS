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

#### Create

```swift
AzureData.createDatabase(newDatabaseId) { database in
    // do stuff
}
```

#### List

```swift
AzureData.databases { list in
    let count = list?.count
    let databases = list?.items
}
```

#### Get

```swift
AzureData.database(databaseId) { database in
    // do stuff
}
```

#### Delete

```swift
AzureData.delete(databaseId) { success in
    if success { // successfully deleted  }
}
```

## DocumentCollections

#### Create

```swift
AzureData.createDocumentCollection(databaseId, collectionId: newCollectionId) { collection in
    // do stuff
}
```

#### List

```swift
AzureData.documentCollections(databaseId) { list in
    let count = list?.count
    let collections = list?.items
}
```

#### Get

```swift
AzureData.documentCollection(databaseId, collectionId: collectionId) { collection in
    // do stuff
}
```

#### Delete

```swift
AzureData.delete(collection, databaseId: databaseId) { success in
    if success { // successfully deleted  }
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
			
AzureData.createDocument(databaseId, collectionId: collectionId, document: newDocument) { document in
    // do stuff
}
```

#### List

```swift
AzureData.documents(ADDocument.self, databaseId: databaseId, collectionId: collectionId) { list in
    let count = list?.count
    let documents = list?.items
}
```

#### Get

```swift
AzureData.document(ADDocument.self, databaseId: databaseId, collectionId: collectionId, documentId: documentId) { document in
    // do stuff
}
```

#### Delete

```swift
AzureData.delete(document, databaseId: databaseId, collectionId: collectionId) { success in
    if success { // successfully deleted  }
}
```

#### Replace

```swift
AzureData.replace(databaseId, collectionId: collectionId, document: newDocument) { document in
    // do stuff
}
```

#### Query

```swift
// TODO...
```



## Attachments

#### Create

```swift
// TODO...
```

#### List

```swift
AzureData.attachemnts(databaseId, collectionId: collectionId, documentId: documentId) { list in
    let count = list?.count
    let attachments = list?.items
}
```

#### Delete

```swift
AzureData.delete (attachment, databaseId: databaseId, collectionId: collectionId, documentId: documentId) { success in
    if success { // successfully deleted  }
}
```

#### Replace

```swift
// TODO...
```



## Stored Procedures

#### Create

```swift
// TODO...
```

#### List

```swift
AzureData.storedProcedures(databaseId, collectionId: collectionId) { list in
    let count = list?.count
    let storedProcedures = list?.items
}
```

#### Delete

```swift
AzureData.delete(storedProcedure, databaseId: databaseId, collectionId: collectionId) { success in
    if success { // successfully deleted  }
}

```

#### Replace

```swift
// TODO...
```

#### Execute

```swift
// TODO...
```



## User Defined Functions

#### Create

```swift
// TODO...
```

#### List

```swift
AzureData.userDefinedFunctions(databaseId, collectionId: collectionId) { list in
    let count = list?.count
    let udfs = list?.items
}
```

#### Delete

```swift
AzureData.delete(udf, databaseId: databaseId, collectionId: collectionId) { success in
    if success { // successfully deleted  }
}
```

#### Replace

```swift
// TODO...
```



## Triggers

#### Create

```swift
// TODO...
```

#### List

```swift
AzureData.triggers(databaseId, collectionId: collectionId) { list in
    let count = list?.count
    let triggers = list?.items
}
```

#### Delete

```swift
AzureData.delete(trigger, databaseId: databaseId, collectionId: collectionId) { success in
    if success { // successfully deleted  }
}
```

#### Replace

```swift
// TODO...
```



## Users	

#### Create

```swift
// TODO...
```

#### List

```swift
AzureData.users(databaseId) { list in
    let count = list?.count
    let users = list?.items
}
```

#### Get

```swift
AzureData.user(databaseId, userId: userId) { user in
    // do stuff
}
```

#### Delete

```swift
AzureData.delete(user, databaseId: databaseId) { success in
    if success { // successfully deleted  }
}
```

#### Replace

```swift
// TODO...
```



## Permissions	

#### Create

```swift
// TODO...
```

#### List

```swift
AzureData.permissions (databaseId, userId: databaseId) { list in 
    let count = list?.count
    let permissions = list?.items
}
```

#### Get

```swift
AzureData.permission (databaseId, userId: String, permissionId: permissionId) { permission in
    // do stuff
}
```

#### Delete

```swift
AzureData.delete(permission, databaseId: databaseId, collectionId: collectionId, userId: userId) { success in
    if success { // successfully deleted  }
}
```

#### Replace

```swift
// TODO...
```

## Offers

#### List

```swift
AzureData.offers { list in
    let count = list?.count
    let offers = list?.items
}
```

#### Get

```swift
AzureData.offer(offerId) { offer in
    // do stuff
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
