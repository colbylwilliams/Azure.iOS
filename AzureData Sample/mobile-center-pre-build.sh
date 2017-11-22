#!/usr/bin/env bash

infoPlist="$MOBILECENTER_SOURCE_DIRECTORY/AzureData Sample/AzureData iOS Sample/Info.plist"

plutil -replace ADDatabaseAccountName -string "$AZURE_COSMOS_DB_ACCOUNT_NAME" "$infoPlist"
plutil -replace ADDatabaseAccountKey -string "$AZURE_COSMOS_DB_ACCOUNT_KEY" "$infoPlist"
