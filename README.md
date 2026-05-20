# EduCore Student Mobile App

Flutter mobile application for students of the EduCore school management system.

## Tech Stack
- **Flutter** (Dart)
- **Riverpod** (State Management)
- **Dio** (HTTP Client)
- **GoRouter** (Navigation)
- **Hive** (Local Caching)
- **Material 3** (UI Design)

## Project Structure
- `lib/core`: ApiClient, Theme, Navigation, Storage, Utilities
- `lib/features`: Feature-based modules (Auth, Dashboard, Attendance, etc.)
- `lib/shared`: Shared widgets and providers
- `lib/config`: App configuration and environment variables

## Setup
1. Ensure Flutter is installed.
2. Run `flutter pub get` to install dependencies.
3. Configure `lib/config/app_config.dart` with your server IP.
4. Run the app using `flutter run`.

## Features Implemented
- Authentication (Login, Token Refresh, Splash)
- Dashboard (Student info, Stats, Today's Schedule, Recent Attendance)
- Navigation Shell (Bottom Navigation)
- Theme System (Deep Purple / Material 3)
- Secure Storage for Tokens
- Base Repositories for Attendance and Results
