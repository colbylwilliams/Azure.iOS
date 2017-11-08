#!/usr/bin/env bash

# frmkInfoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData/Source/Info.plist"
testInfoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData/Tests/Info.plist"

# plutil -replace ADDatabaseAccountName -string "$accountName" "$frmkInfoPlist"
# plutil -replace ADDatabaseAccountKey -string "$accountKey" "$frmkInfoPlist"

plutil -replace ADDatabaseAccountName -string "$AZURE_COSMOS_DB_ACCOUNT_NAME" "$testInfoPlist"
plutil -replace ADDatabaseAccountKey -string "$AZURE_COSMOS_DB_ACCOUNT_KEY" "$testInfoPlist"
