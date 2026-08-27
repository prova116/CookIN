# CookIN

A Flutter app for ordering home-cooked food from local home chefs.

**Live demo:** https://prova116.github.io/CookIN/ (deploys automatically from `main`)

## Screens

- Splash → on-boarding (3 intro pages) → welcome
- Login / sign up / OTP / forgot password
- Home feed: categories, popular restaurants, most popular, recently viewed
- Bottom tab shell (Menu / Offer / Home / Profile / More)

## Getting started

Requires the Flutter SDK (stable channel, 3.24+).

```bash
flutter pub get
flutter run -d chrome   # or an emulator / connected device
```

### Tests

```bash
flutter test
```

## Deployment

Pushing to `main` triggers [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml), which runs the
test suite, builds the web app, and publishes it to GitHub Pages.

To build the same artifact locally:

```bash
flutter build web --release --base-href /CookIN/
```
