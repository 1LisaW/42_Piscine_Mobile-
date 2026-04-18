# Diary App

A Flutter diary with **Firebase Authentication** and **Cloud Firestore**. Signed-in users add journal entries (title, body, mood), see them update live, and browse them on **Profile** or by **calendar day** on the **Calendar** tab. State is handled with **Riverpod**; the app loads client config from `assets/env/firebase.env` via `flutter_dotenv` before initializing Firebase.

## Features

- **Welcome screen** — background image and navigation to login.
- **Sign-in** — email/password (login and sign-up), **Google**, and **GitHub** (enable these providers in Firebase).
- **Home** — bottom navigation:
  - **Profile** — stream of all diary entries (newest first), “New diary entry”, read/delete via dialogs, profile header with email and sign-out.
  - **Calendar** — month view powered by **`table_calendar`**; pick a day to list entries whose `createdAt` falls on that local calendar day (`diary_entry_utils.entriesOnCalendarDay`). Tap an entry to open the same read dialog as on Profile.
- **Data model** — `title`, `body`, `moodIndex`, `createdAt` (server timestamp). Firestore path: `notes/{userEmail}/entries`.

## Tech stack

| Area | Packages / services |
| ---- | -------------------- |
| Backend | Firebase Auth, Cloud Firestore (`firebase_core`, `firebase_auth`, `cloud_firestore`) |
| Google sign-in | `google_sign_in` |
| State | `flutter_riverpod` |
| Calendar UI | `table_calendar` |
| Config | `flutter_dotenv` (`assets/env/firebase.env`) |
| UI | Material 3, green seed theme, **Dancing Script** (`assets/fonts/DancingScript-Regular.ttf`) |
| Dates | `intl` (where used in widgets) |

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) SDK matching `environment.sdk` in `pubspec.yaml`.
- A **Firebase** project with Authentication (Email/Password, Google, GitHub as needed) and **Cloud Firestore**, plus [security rules](https://firebase.google.com/docs/firestore/security/get-started) suited to your deployment.
- `lib/firebase_options.dart` aligned with your Firebase apps (e.g. [FlutterFire CLI](https://firebase.flutter.dev/docs/overview/)).

## Run the app

```bash
cd diary_app
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

Includes tests for `diary_entry_utils` and `DiaryListTile` (see `test/`).

## Project layout (`lib`)

| Path | Role |
| ---- | ---- |
| `main.dart` | `dotenv`, `Firebase.initializeApp`, `ProviderScope`, `AuthGate` |
| `features/auth/` | `AuthGate`, `AuthController`, `LoginScreen` |
| `screens/` | `WelcomeScreen`, `HomeScreen` |
| `widgets/` | `ProfileTab`, `CalendarTab`, `DiaryListTile`, `FeelTile`, `Profile_Info` |
| `dialogs/diary_entry_dialogs.dart` | Add / read entry UI |
| `services/` | `AuthService`, `DiaryService` |
| `providers/diary_providers.dart` | `diaryEntriesProvider` |
| `models/diary_entry.dart` | Entry model + Firestore mapping |
| `utils/diary_entry_utils.dart` | Filtering entries by calendar day |
| `constants/diary_ui_constants.dart` | Shared colors/styles |

## Assets

- `assets/images/welcome_screen_bg.jpg` — welcome background.
- `assets/env/firebase.env` — env loaded at startup; do not commit real keys to public repositories if you treat them as sensitive.

---

For general Flutter help, see the [Flutter documentation](https://docs.flutter.dev/).
