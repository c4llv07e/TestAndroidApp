#!/bin/sh
set -ue
mkdir -p _build/gen/com/c4llv07e/testapp
mkdir -p _build/apk
bin/aapt package -f -m -J _build/gen -S res -M AndroidManifest.xml  -I /android_test/cmdline-tools/platforms/android-35/android.jar 
javac -classpath /android_test/cmdline-tools/platforms/android-35/android.jar -d _build/obj _build/gen/com/c4llv07e/testapp/R.java src/com/c4llv07e/testapp/MainActivity.java
bin/d8 _build/obj/com/c4llv07e/testapp/*.class --output _build/apk/my_classes.jar --no-desugaring
(cd _build/apk; ../../bin/d8 /android_test/cmdline-tools/platforms/android-35/android.jar ./my_classes.jar)
bin/aapt package -f -M AndroidManifest.xml -S res/ -I /android_test/cmdline-tools/platforms/android-35/android.jar -F _build/TestApp.unsigned.apk _build/apk/
bin/zipalign -f -p 4 _build/TestApp.unsigned.apk _build/TestApp.aligned.apk
bin/apksigner sign --ks c4-release-key.jks --ks-key-alias c4-key-alias --ks-pass pass:android --key-pass pass:android --out _build/TestApp.apk _build/TestApp.aligned.apk
