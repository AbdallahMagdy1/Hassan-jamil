# Hassan Jameel Motors Mobile App

## Summary

This app provides a seamless mobile experience for Hassan Jameel Motors customers, enabling users to browse vehicles, book services, view offers, and manage their profiles. Built with Flutter, it ensures high performance and cross-platform compatibility.

## Project Architecture

The app uses a modular architecture based on the MVC pattern and powered by [GetX](https://github.com/jonataslaw/getx) for state management and routing. The structure is organized as follows:

- **core/**  
  Contains helpers, remote APIs, statics, store, theme, translations, and widgets.

- **features/**  
  Each app feature (e.g., vehicle listing, booking, profile) is a folder with its own MVC structure:
  - `controller/` – Business logic and API calls
  - `model/` – Data models
  - `view/` – UI screens

- **statics/**  
  Centralized constants for feedback messages and error assets.

- **remote/**  
  API URLs and response format handling.

- **theme/**  
  Customizable app theme.

- **translations/**  
  Multi-language support (Arabic & English).

This architecture ensures maintainability, testability, and rapid development.

---

# Installation

Clone the project to your device:

```sh
git clone https://github.com/Invention-Technology/Flutter-Wings.git
```

Go to the project directory and run:

```sh
flutter pub get
```

to install all the dependencies.

---

# About Wings

Wings is an MVC file structure build with [getx](https://github.com/jonataslaw/getx) for [flutter](https://github.com/flutter/flutter) projects. to reduce the time of development  and increase the programmer productivity.

## File Structure

- core

  - immutable

    > this folder contains the core of Wings and should not be edited

  - mutable

    - [helpers](#helpers)
    - [remote](#remote)
    - [statics](#statics)
    - [store](#store)
    - [theme](#theme)
    - [translations](#translations)
    - [widgets](#widgets)

- features

  > here you can add your app features as the recommended structure (MVC)

  - featureName
    - controller
    - model
    - view

# Installation

clone the project to your device

# Hassan Jameel Motors Mobile App (hj_app)

This repository is the Flutter mobile app for Hassan Jameel Motors. It uses GetX for state management/routing and includes Firebase integration, in-app webviews, maps, and several common Flutter plugins.

This README has been updated with a fast scan of the project (packages, key folders, and assets).

## Quick facts
- Package name: `hj_app`
- Current version: `1.0.20+82` (see `pubspec.yaml`)
- Dart SDK constraint: `>=2.17.6 <3.0.0`

## Major dependencies (from pubspec.yaml)
These are the notable packages and the pinned versions used in the project:

- get: ^4.6.5
- flutter_inappwebview: ^6.1.5
- firebase_core: ^3.0.0
- firebase_messaging: ^15.0.0
- firebase_analytics: ^11.6.0
- firebase_crashlytics: ^4.3.10
- flutter_local_notifications: ^19.3.1
- google_maps_flutter: ^2.2.6
- geolocator: ^14.0.2
- permission_handler: ^12.0.1
- share_plus: ^11.0.0
- url_launcher: ^6.3.2
- package_info_plus: ^8.3.1
- app_tracking_transparency: ^2.0.6+1

Dev tools:
- flutter_native_splash: ^2.4.6
- flutter_launcher_icons: ^0.14.4
- flutter_lints: ^6.0.0

If you want to upgrade or check newer versions run:
```bash
flutter pub outdated
```

## Project structure (top-level)
This is a condensed view of the repository folders relevant to the app code and assets:

- `lib/`
  - `app.dart`, `main.dart` — app entry and boot logic
  - `initialBinding.dart` — GetX initial binding
  - `global/` — UI constants, URLs, helpers
  - `controller/` — GetX controllers (locale, theme, profile, map, etc.)
  - `view/` — screens and widgets
  - `model/` — data models
  - `firebase_options.dart` — firebase config (generated)

- `assets/`
  - `icons/` — SVG icon set (~23 files)
  - `images/` — PNG/GIF/video assets used in UI (~15 files)

- `ios/`, `android/` — platform projects
- `pubspec.yaml` — deps, assets, native splash config

See the `lib/` folder for the full app layout.

## Assets (fast inventory)
- Icons (in `assets/icons/`): alarm.svg, basket.svg, callUs.svg, camera.svg, compare.svg, eyeOn.svg, facebook.svg, favorite.svg, finance.svg, google.svg, iconPassword.svg, informationAboutUs.svg, loading.svg, location.svg, logoCamera.svg, logoLibrary.svg, main.svg, maintenance.svg, more.svg, myBookings.svg, myRequests.svg, myReservations.svg, recruitment.svg, search.svg, settings.svg, shop.svg, signIn.svg, signOut.svg, tips.svg
- Images (in `assets/images/`): authDarkScreen.png, authLightScreen.png, character.png, errorBottomSheet.png, hj-black.png, hj.png, insertPhotoID.png, loginPassWord.png, loginandstore.png, logoHJ.gif, logoOptionLogin.png, logoOptionRegister.png, noInternetConnection.png, pleaseLoginForABetterExperience.png, resetPassword.png, splash.mp4, splash.webm, verificationConfirm.png

## Important iOS notes (from quick runtime debug)
- If you use location, local network, or related permissions, make sure the following keys exist in `ios/Runner/Info.plist` with human-readable strings, otherwise iOS can kill the app when it requests permissions:
  - `NSLocationWhenInUseUsageDescription`
  - `NSLocalNetworkUsageDescription` (if you use local network/Bonjour features)
  - Remove or fix malformed `NSBonjourServices` entries (an incorrectly formatted array can cause issues)

Example Info.plist entries:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to show nearby services and map features.</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Needed to discover local devices on your network.</string>
```

## Common commands
- Install dependencies:
```bash
flutter pub get
```
- Run on iOS simulator/device:
```bash
flutter run -d <device-id>
```
- Analyze project:
```bash
flutter analyze
```

## Notes & next steps
- The repository contains a set of analyzer/info warnings (file naming conventions, missing type annotations). These are informational but worth addressing over time.
- If you want, I can:
  - Add a short CONTRIBUTING or DEV-SETUP section with Xcode plist snippets and common troubleshooting tips (fast follow-up),
  - Generate a smaller developer README that lists the most-used commands and how to run the app on device,
  - Or update `README.md` further with screenshots and CI instructions.

If you'd like me to apply any of the above follow-ups (e.g., add the Info.plist snippet directly, or include a developer quickstart), tell me which and I'll add it.
**For more information, please see the provided example inside feature folder.**
