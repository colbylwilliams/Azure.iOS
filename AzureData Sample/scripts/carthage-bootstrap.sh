#!/usr/bin/env bash

# set -x

carthageDir="$SRCROOT/Carthage/Build/iOS/AzureData.framework"

# if not a CI build
if [ ! -z "$MOBILECENTER_SOURCE_DIRECTORY" ]; then

    echo "*** Skip this script for CI builds"

else

    echo "*** Checking for AzureData.framework at:  $carthageDir"

    if [ ! -d "$carthageDir" ];then

        echo "*** Unable to find AzureData.framework"
        echo "*** Checking if Carthage is installed"

        if [ ! -x "$(command -v carthage)" ]; then

            echo "error: Carthage is not installed - see instrucions for installing at https://github.com/Carthage/Carthage#installing-carthage."
            exit 1
        fi

        echo "*** Carthage installed, running: carthage bootstrap --platform iOS"

        carthage bootstrap --platform iOS
    
    else

        echo "*** Successfully found AzureData.framework"
    fi
fi
