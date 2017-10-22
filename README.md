# Azure.iOS

| App        | Status          |
| ---------- | --------------- |
| AzureData  | ![Build status][app-data-build-status] |


## API

## Databases

#### Create

```swift
```

#### List

```swift
```

#### Get

```swift
// TODO...
```

#### Delete

```swift
// TODO...
```

## DocumentCollections

#### Create

```swift
// TODO...
```

#### List

```swift
// TODO...
```

#### Get

```swift
// TODO...
```

#### Delete

```swift
// TODO...
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
AzureData.document(ADDocument.self, databaseId: databaseId, collectionId: collectionId!, documentId: documentId) { document in
    // do stuff
}
```

#### Delete

```swift
AzureData.delete(document, databaseId: databaseId, collectionId: collectionId) { success in
    if success { 
        // document deleted 
    }
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
// TODO...
```

#### Delete

```swift
// TODO...
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
// TODO...
```

#### Delete

```swift
// TODO...
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
// TODO...
```

#### Delete

```swift
// TODO...
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
// TODO...
```

#### Delete

```swift
// TODO...
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
// TODO...
```

#### Get

```swift
// TODO...
```

#### Delete

```swift
// TODO...
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
// TODO...
```

#### Get

```swift
// TODO...
```

#### Delete

```swift
// TODO...
```

#### Replace

```swift
// TODO...
```

## Offers

#### List

```swift
// TODO...
```

#### Get

```swift
// TODO...
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
