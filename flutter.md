# flutter

## change jdk
```
# ketoe iki gak perlu
flutter config --jdk-dir="/Users/sofyan/Applications/Android Studio.app/Contents/jbr/Contents/Home"

# buka file gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-all.zip
```

## openjdk21
```
brew install openjdk@21
sudo ln -sfn /usr/local/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
flutter create -e ztmp
cd ztmp/android/
./gradlew wrapper --gradle-version=8.5
```

## emulator
```
flutter emulators --launch Medium_Phone_API_35_X
```