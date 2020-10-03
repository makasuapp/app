# Initial Setup

1. [Install Flutter](https://flutter.dev/docs/get-started/install)
2. Set up an Android emulator running Pixel 2 Android Q
3. Set up anything else needed: `flutter doctor`

# Running

1. Install any new packages: `flutter pub get`
2. Re-serialize any changed JSON models: `flutter packages pub run build_runner build --delete-conflicting-outputs --verbose`

Then in Visual Studio Code do Run -> Start Debugging

To run with environment variables passed in: `flutter run --dart-define=ENV=production --dart-define=<KEY>=<VALUE>`

Running on iOS:

```
  flutter build ios
```

Then open the ios folder in Xcode and run the simulator or your phone connected

# Testing

```
  flutter test
```

# Debugging

If you have package issues:

```
  flutter clean
  flutter pub cache repair
```
