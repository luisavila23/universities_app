# Universities App (Flutter Technical Test)

A Flutter app that consumes the universities dataset and displays it in both **List** and **Grid** layouts. Users can open a university detail screen to assign an image (camera/gallery) and enter the number of students with basic validation. Data is kept **in-memory only** (no persistence), as requested.

## Features

- Fetch universities from the provided JSON endpoint
- Universities list with **ListView / GridView** toggle
- University detail screen
- Assign image from **Gallery** or **Camera**
- Enter **number of students** with validation (required, numeric, > 0)
- **No persistence** between sessions (in-memory edits only)
- Bonus: client-side infinite scroll loading items in chunks of 20

## Tech Stack

- Flutter (Material 3)
- dio (network)
- flutter_riverpod (state management)
- image_picker (camera/gallery)

## Getting Started

### Prerequisites

- Flutter SDK installed
- iOS: Xcode + CocoaPods
- Android: Android SDK (optional)

### Install & Run

```bash
flutter pub get
open -a Simulator
flutter run
```
