# Senioren App

Eine Flutter-App für Seniorinnen und Senioren mit sprachgesteuertem Assistenten, Check-in-Erinnerungen, Kontaktverwaltung und barrierearmer Gestaltung.

## Projektstruktur
```
lib/
  app.dart
  main.dart
  core/
  data/
  features/
  services/
  theme/
  widgets/
  l10n/
firebase/
  firestore.rules
  rules_tests/
```

## Setup

### Voraussetzungen
- Flutter (stable, >=3.16)
- Dart SDK >=3.2
- Firebase CLI
- Node.js (für Rules-Tests)

### Flutter-Projekt initialisieren
1. `flutter pub get`
2. Optional: Fonts bauen `flutter gen-l10n`

### Firebase einrichten
1. Projekt in der Firebase Console erstellen (`senioren_app`).
2. Android-App hinzufügen
   - Package Name: `com.example.senioren_app`
   - `google-services.json` nach `android/app/` legen.
3. iOS-App hinzufügen
   - Bundle Identifier: `com.example.seniorenApp`
   - `GoogleService-Info.plist` nach `ios/Runner/` legen.
4. App Check vorbereiten
   - Android: Play Integrity / Debug-Token registrieren.
   - iOS: DeviceCheck oder App Attest aktivieren.
   - In `main.dart` wird `FirebaseAppCheck.instance.activate()` bereits aufgerufen.
5. Firestore, Authentication (E-Mail/Passwort) und Cloud Messaging aktivieren.
6. Lokale Benachrichtigungen: keine zusätzliche Firebase-Konfiguration notwendig.

### Debug Build
```
flutter run --debug
```

### Release Build
```
flutter build apk --release
flutter build ios --release
```

## Tests & Qualität

### Flutter Analyse & Tests
```
flutter analyze
flutter test
flutter test --update-goldens   # bei Änderungen am Design
```

### Integrationstests
```
flutter test integration_test
```

### Firebase Rules Tests
```
cd firebase
npm install
npm test
```

## Barrierefreiheit (A11y)
- Mindest-Touchfläche 44×44 dp.
- Alle interaktiven Elemente mit Semantics-Label.
- Farbkontraste ≥ 7:1 für Primärtext, ≥ 4.5:1 für Sekundärtext.
- Dynamische Schriftgrößen (100/150/200 %).
- Fokus- und Aktivzustände visuell erkennbar.
- Keine Farb-allein-Kodierung (Icon + Text + Farbe).
- Screenreader-freundliche Reihenfolge.

## Lokalisierung
- Standard: Deutsch (`lib/l10n/app_de.arb`).
- Englisch und Türkisch vorbereitet.
- Sprache kann im Einstellungsbereich live gewechselt werden.

## Services
- `CheckinService`: verwaltet Fälligkeiten & lokale Erinnerungen.
- `TtsService` / `SttService`: Text-zu-Sprache & Sprache-zu-Text mit Berechtigungsabfragen.
- `NotificationsService`: lokale Benachrichtigungsberechtigungen.
- `LocalizationService`: Locale-Provider für die App.
- `FirebaseInitializer`: aktiviert App Check & Messaging.

## Firestore-Datenmodell
```
users/{uid} { displayName, preferredLanguage, textScale, notificationsEnabled }
contacts/{uid}/items/{contactId} { name, phone, isEmergency, createdAt }
checkins/{uid} { frequency, nextDueAt, enabled }
help/videos/{id} { title, url }
emergency/{uid}/events/{eventId} { createdAt, acknowledged }
```

## Sicherheit
- `firebase/firestore.rules` beschränken Zugriff auf eigene Dokumente.
- Notfallkontakte auf max. drei pro Nutzer begrenzt.
- Tests unter `firebase/rules_tests`.

## Design Tokens
- Primärfarbe `#1976D2`, Gradienten gemäß `lib/theme/tokens.dart`.
- Radius: 8/16/24/28.
- Schatten: 12–16 px Versatz, Blur 32–40 px.
- Typografie: Roboto, Body ≥16 sp, Buttons 18 sp fett.
- Spacing: 8/12/16/24/32.

## Checks
- Visuelle Golden-Tests (Home, Bottom Nav, Check-in Karte, Warning Modal, RadioTileLarge).
- Unit-Tests für Check-in Logik & Kontaktlimit.
- Integrationstest für Schrift- & Sprachwechsel.

## Support
- `Kontakt & Support` Button führt zu `mailto:support@senioren-app.de`.

