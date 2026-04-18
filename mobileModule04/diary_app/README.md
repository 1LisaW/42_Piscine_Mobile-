# Diary App

A Flutter diary with **Firebase Authentication** and **Cloud Firestore**. Signed-in users can add journal entries with a title, body, and mood (emoji), browse them in real time on the **Profile** tab, and open or delete entries. State is handled with **Riverpod**; the app loads extra client config from `assets/env/firebase.env` via `flutter_dotenv` before initializing Firebase.

## Features

- **Welcome screen** — background image and navigation to login.
- **Sign-in options** — email/password (login and sign-up), **Google**, and **GitHub** (see Firebase setup below).
- **Home** — bottom navigation:
  - **Profile** — stream of diary entries (newest first), “New diary entry” dialog (title, body, mood picker), read and delete actions, profile header with email and sign-out.
  - **Calendar** — placeholder screen (label only).
- **Data model** — each entry has `title`, `body`, `moodIndex`, and `createdAt` (server timestamp). Entries live under Firestore path `notes/{userEmail}/entries`.

## Tech stack

| Area | Packages / services |
| ---- | -------------------- |
| Backend | Firebase Auth, Cloud Firestore (`firebase_core`, `firebase_auth`, `cloud_firestore`) |
| Google sign-in | `google_sign_in` |
| State | `flutter_riverpod` |
| Config | `flutter_dotenv` (`assets/env/firebase.env`) |
| UI | Material 3, green seed theme, **Dancing Script** font (`assets/fonts/DancingScript-Regular.ttf`) |
| Dates | `intl` |

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) SDK matching `environment.sdk` in `pubspec.yaml`.
- A **Firebase** project with:
  - **Authentication** providers enabled: Email/Password, Google, and GitHub as used in the app.
  - **Cloud Firestore** created; secure your data with [security rules](https://firebase.google.com/docs/firestore/security/get-started) appropriate for production (the app reads/writes per signed-in user under `notes/{email}/entries`).
- Platform Firebase config: `lib/firebase_options.dart` (e.g. from [FlutterFire CLI](https://firebase.flutter.dev/docs/overview/)). Ensure `assets/env/firebase.env` matches your project if you rely on env-driven values elsewhere.

## Run the app

```bash
cd diary_app
flutter pub get
flutter run
```

## Project layout (`lib`)

| Path | Role |
| ---- | ---- |
| `main.dart` | `dotenv` load, `Firebase.initializeApp`, `ProviderScope`, `AuthGate` |
| `features/auth/` | `AuthGate`, `AuthController`, `LoginScreen` |
| `screens/` | `WelcomeScreen`, `HomeScreen` |
| `services/` | `AuthService`, `DiaryService` |
| `providers/diary_providers.dart` | `diaryEntriesProvider` streaming from Firestore |
| `models/diary_entry.dart` | Entry model and Firestore mapping |
| `widgets/profile_info.dart` | Profile header / logout |

## Assets

- `assets/images/welcome_screen_bg.jpg` — welcome background.
- `assets/env/firebase.env` — optional env keys loaded at startup (keep out of public repos if you treat them as sensitive; rotate keys in [Google Cloud Console](https://console.cloud.google.com/) if exposed).

---

For general Flutter help, see the [Flutter documentation](https://docs.flutter.dev/).
