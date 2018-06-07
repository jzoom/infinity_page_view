#!/bin/bash

echo "$PWD"
export ROOT="$PWD"

mkdir ~/development

cd ~/development
wget https://storage.googleapis.com/flutter_infra/releases/beta/macos/flutter_macos_v0.4.4-beta.zip
unzip ~/development/flutter_macos_v0.4.4-beta.zip

export PATH=~/development/flutter/bin:$PATH


cd $ROOT/package
flutter packages get
