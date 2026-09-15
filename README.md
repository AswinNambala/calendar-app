# 📅 Calendar App

A cross-platform **Flutter** calendar application with Google Sign-In, cloud-synced events, and local reminders — built with **Riverpod**, **Firebase**, and `table_calendar`.

## ✨ Features

- **Interactive Calendar View** — Month/week views powered by `table_calendar`
- **Google Sign-In Authentication** — Secure login via `firebase_auth` + `google_sign_in`
- **Cloud-Synced Events** — Events stored and synced in real time with **Cloud Firestore**
- **Local Notifications & Reminders** — Timezone-aware event reminders via `flutter_local_notifications` and `timezone`
- **Declarative Navigation** — Routing handled with `go_router`

## 🛠 Tech Stack

| Category | Package |
|---|---|
| Framework | Flutter (Dart SDK `^3.12.2`) |
| State Management | `flutter_riverpod ^3.4.3` |
| Navigation | `go_router ^18.0.1` |
| Backend / Database | `firebase_core`, `cloud_firestore` |
| Authentication | `firebase_auth`, `google_sign_in` |
| Calendar UI | `table_calendar ^3.2.1` |
| Notifications | `flutter_local_notifications`, `timezone` |
| Testing | `flutter_test`, `mocktail` |

## 📱 Supported Platforms

Android · iOS · Web · Windows · macOS

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.12.2` compatible)
- A [Firebase project](https://console.firebase.google.com/) with **Authentication** (Google Sign-In) and **Cloud Firestore** enabled
- `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) configured for your Firebase project

### Installation

```bash
# Clone the repository
git clone https://github.com/AswinNambala/calendar-app.git
cd calendar-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Firebase Setup

1. Create a project in the [Firebase Console](https://console.firebase.google.com/)
2. Enable **Google** as a sign-in provider under Authentication
3. Enable **Cloud Firestore** and deploy the included rules/indexes:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```
4. Add platform config files (`google-services.json`, `GoogleService-Info.plist`) to the respective platform folders

### Build

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## 📂 Project Structure

```
lib/
├── main.dart          # App entry point
├── models/            # Event/user data models
├── providers/          # Riverpod providers
├── screens/            # Calendar, auth, and settings screens
├── widgets/            # Reusable UI components
├── services/            # Firebase & notification services
└── router/              # go_router route definitions
```

> Note: adjust this section to match your actual `lib/` folder layout.

## 🔐 Firestore Security

Firestore access rules are defined in `firestore.rules` — review and adjust these before deploying to production.

## 📄 License

Add your license here (e.g. MIT).

## 🤝 Contributing

Contributions, issues, and feature requests are welcome. Feel free to open a pull request or issue.
