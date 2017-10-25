#!/usr/bin/env bash

accountName="$AZURE_COSMOS_DB_ACCOUNT_NAME"
accountKey="$AZURE_COSMOS_DB_ACCOUNT_KEY"

echo Account Name: "$accountName"
echo Account Key: "$accountKey"


echo Source Directory: "$MOBILECENTER_SOURCE_DIRECTORY"


fmkInfoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData/AzureData/Info.plist"
appInfoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData/AzureDataApp/Info.plist"


echo Framework Info.plist Path: "$fmkInfoPlist"
echo App Info.plist Path: "$appInfoPlist"


plutil -replace ADDatabaseAccountName -string "$accountName" "$fmkInfoPlist"

plutil -replace ADDatabaseAccountName -string "$accountName" "$appInfoPlist"

plutil -replace ADDatabaseAccountKey -string "$accountKey" "$fmkInfoPlist"

plutil -replace ADDatabaseAccountKey -string "$accountKey" "$appInfoPlist"