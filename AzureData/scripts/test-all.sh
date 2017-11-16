#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROJECT=${DIR%/*}/AzureData.xcodeproj

echo "$PROJECT"

xcodebuild clean test -project "$PROJECT" -scheme AzureData\ iOS -destination 'platform=iOS Simulator,name=iPhone X,OS=11.1' | xcpretty

xcodebuild clean test -project "$PROJECT" -scheme AzureData\ macOS -destination 'platform=macOS,arch=x86_64' | xcpretty

xcodebuild clean test -project "$PROJECT" -scheme AzureData\ tvOS -destination 'platform=tvOS Simulator,name=Apple TV 4K,OS=11.1' | xcpretty
