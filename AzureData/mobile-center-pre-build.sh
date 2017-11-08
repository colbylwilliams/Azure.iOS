#!/usr/bin/env bash

accountName="$AZURE_COSMOS_DB_ACCOUNT_NAME"
accountKey="$AZURE_COSMOS_DB_ACCOUNT_KEY"

# echo Account Name: "$accountName"
# echo Account Key: "$accountKey"


# echo Source Directory: "$MOBILECENTER_SOURCE_DIRECTORY"

# frmkInfoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData/Source/Info.plist"
testInfoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData/Tests/Info.plist"


# echo Framework Info.plist Path: "$frmkInfoPlist"
# echo Test Info.plist Path: "$testInfoPlist"


# plutil -replace ADDatabaseAccountName -string "$accountName" "$frmkInfoPlist"
# plutil -replace ADDatabaseAccountKey -string "$accountKey" "$frmkInfoPlist"

plutil -replace ADDatabaseAccountName -string "$accountName" "$testInfoPlist"
plutil -replace ADDatabaseAccountKey -string "$accountKey" "$testInfoPlist"
