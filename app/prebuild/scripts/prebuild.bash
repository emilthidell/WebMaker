#!/bin/bash
ls .meteor
mkdir .meteor/local
mkdir .meteor/local/build
mkdir .meteor/local/build/programs
mkdir .meteor/local/build/programs/server
mkdir .meteor/local/build/programs/server/assets
mkdir .meteor/local/build/programs/server/assets/packages
cp -r prebuild/resources/meteoric_ionic-sass/ .meteor/local/build/programs/server/assets/packages
cp -r prebuild/resources/meteoric_ionicons-sass/ .meteor/local/build/programs/server/assets/packages
