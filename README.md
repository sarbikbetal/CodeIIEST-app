# CodeIIEST

The official Android app for CodeIIEST, coding club of IIEST Shibpur for updates,

## Downloads

Check out the [releases](https://github.com/sarbikbetal/CodeIIEST-app/releases) tab for downloads

## Building

You should have the following installed for building this app

- Android Studio
- Flutter SDK

```shell
$ git clone https://github.com/sarbikbetal/CodeIIEST-app.git
$ cd CodeIIEST-app/
$ flutter pub get
Running "flutter pub get" in codeiiest...                           2.4s
$ flutter build apk --split-per-abi
Running Gradle task 'assembleRelease'...                               ⢿
Running Gradle task 'assembleRelease'... Done                     181.1s (!)
✓ Built build/app/outputs/apk/release/app-armeabi-v7a-release.apk (6.9MB).
✓ Built build/app/outputs/apk/release/app-arm64-v8a-release.apk (7.1MB).
✓ Built build/app/outputs/apk/release/app-x86_64-release.apk (7.3MB).
$ cd build/app/outputs/apk/release
```

and you would get the built APKs.
