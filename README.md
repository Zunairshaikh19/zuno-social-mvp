# ZUNO Social AI

A Flutter MVP project for the Week 1 launch plan, focused on the authentication and dashboard experience for creators managing multiple social segments.

## Week 1 MVP structure

The app is organized to support the first milestone of the roadmap:

- `lib/app.dart` — application entry and route setup
- `lib/core/constants` — shared text and app constants
- `lib/core/theme` — branding and base theme
- `lib/features/auth` — sign-in and onboarding flows
- `lib/features/dashboard` — summary and management dashboard
- `lib/features/segments` — future segment creation flow and wizard setup

## Current screens

- Login screen with email/password fields and CTA to enter the app
- Dashboard screen with stat cards and segment preview list
- Segment wizard placeholder to support the next week of feature work

## Getting started

```bash
flutter pub get
flutter run
```

## MVP roadmap

- Week 1: auth flow + dashboard foundation
- Week 2: segment onboarding and persona definition
- Week 3: content generation and review workflow
