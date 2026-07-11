#!/bin/sh
set -ue
set -x

mkdir -p _build/gen
mkdir -p _build/obj
[ -e _build/apk ] && rm -r _build/apk
mkdir -p _build/apk

bin/aapt package -m -J _build/gen -M AndroidManifest.xml -S res/ -I /android_test/cmdline-tools/platforms/android-35/android.jar
javac -classpath /android_test/cmdline-tools/platforms/android-35/android.jar -d _build/obj _build/gen/com/c4llv07e/testapp/R.java src/com/c4llv07e/testapp/*.java
bin/d8 _build/obj/com/c4llv07e/testapp/*.class /android_test/cmdline-tools/platforms/android-35/android.jar --output _build/apk/
bin/aapt package -f -M AndroidManifest.xml -S res/ -I /android_test/cmdline-tools/platforms/android-35/android.jar -F _build/TestApp.unsigned.apk _build/apk
bin/zipalign -f -p 4 _build/TestApp.unsigned.apk _build/TestApp.aligned.apk
bin/apksigner sign --ks c4-release-key.jks --ks-key-alias c4-key-alias --ks-pass pass:android --key-pass pass:android --out _build/TestApp.apk _build/TestApp.aligned.apk
