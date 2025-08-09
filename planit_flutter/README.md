# PlanIt Flutter (skeleton)

A Flutter rewrite skeleton for the PlanIt app. Includes tabs for Planner, Grocery List, and AI Chat with simple local state.

## Requirements
- Flutter SDK (3.3+)

## Getting Started
```bash
# If you do not see android/ ios/ web/ folders yet, generate them first:
flutter create .

flutter pub get
flutter run
```

## Structure
- `lib/main.dart`: App entry, bottom navigation
- `lib/screens/*`: Screens
- `lib/providers/*`: State providers using Provider
- `lib/models/*`: Data models

## Notes
- AI Chat is stubbed locally. Wire your backend later in `ChatProvider`.
- Add assets under `assets/` and register in `pubspec.yaml`.