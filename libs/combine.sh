#!/bin/bash
set projName  libLionSettings
echo "->" . $projName
mkdir libLionSettings
lipo -create Release-iphoneos/lib*  Release-iphonesimulator/lib*  -output ./libLionSettings/libLionSettings_all.a
cp -rf Release-iphoneos/include  ./libLionSettings/