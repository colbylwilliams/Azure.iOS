#!/usr/bin/env bash

if [ ! -z "$MOBILECENTER_SOURCE_DIRECTORY" ]; then
	cd $MOBILECENTER_SOURCE_DIRECTORY/AzureData\ Sample && carthage bootstrap
fi