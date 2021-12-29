#!/bin/sh

SDK_Name="AgoraExtApps"
SDK_Path="../../../ExtApps"
SDK_Version="2.0.0"

SDKs_Path="${SDK_Path}"

cd ${SDKs_Path}

Tag=${SDK_Name}_v${SDK_Version}

git tag -d ${Tag}
git push originGithub :refs/tags/${Tag}
git tag ${Tag}
git push originGithub --tags

pod spec lint ${SDK_Name}.podspec --allow-warnings --verbose
pod trunk push ${SDK_Name}.podspec --allow-warnings --verbose
