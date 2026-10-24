# 🔋 Battery Monitor (flbatteryloadfull)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Android](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://www.android.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An Android background service application built with Flutter to preserve smartphone battery health and longevity. It monitors battery level and charging state in real time, alerting you when charging reaches **80%** (to prevent heat and overcharging degradation) and when battery drops to **22%** (to prevent deep discharge).

---

## 📋 Table of Contents

- [Features](#-features)
- [How It Works](#-how-it-works)
- [Screenshots & UI Overview](#-ui-overview)
- [Supported Languages](#-supported-languages)
- [OEM & Manufacturer Settings (Important)](#-oem--manufacturer-settings-important)
- [Permissions](#-permissions)
- [Tech Stack & Architecture](#-tech-stack--architecture)
- [Getting Started](#-getting-started)
- [Testing & Validation](#-testing--validation)
- [License](#-license)

---

## ✨ Features

- **⚡ 80% Full Charge Alarm (Plugged In):**
  - Continuous audible alarm loop triggered as soon as the battery reaches 80% while connected to a charger.
  - Ongoing high-priority notification with a dedicated **"Stop alarm"** action button.
  - Alarm automatically stops immediately when the charging cable is disconnected or stopped manually.
  - Adjustable alarm volume slider with real-time test preview.

- **🪫 22% Low Battery Warning (Unplugged):**
  - Discrete, single-play notification with an alert chime when battery drops to exactly 22% while in use.
  - Can be toggled on/off in the app settings.

- **🔄 Background Foreground Service:**
  - Powered by `flutter_background_service` and compliant with modern Android Foreground Service requirements (`specialUse` type).
  - Listens to system battery state broadcast streams and performs periodic checks (every 60 seconds) even when screen is off or app is closed.
  - Displays persistent notification showing real-time battery percentage and charging state.

- **🚀 Quick Navigation ("Before use"):**
  - Convenient AppBar button on the top left that smoothly scrolls directly down to the OEM power-saving and background configuration instructions.

- **🧪 In-App Testing Suite:**
  - One-tap buttons to test the 22% notification and test the 80% alarm audio without having to wait for battery levels to change.
  - One-tap button to request exemption from Android battery optimizations (`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`).

---

## ⚙️ How It Works

Modern Lithium-ion smartphone batteries degrade fastest when held at 100% charge voltage or when drained completely below 20%. The optimal cycle for battery longevity is between **20% and 80%**.

```
  0% ──────── 22% ──────────────────────── 80% ──────── 100%
  [ Deep Draining ]      Optimal Range       [ Stress & Heat ]
          ▲                                       ▲
   Notify: Plug in!                        Alarm: Unplug!
```

1. **When charging:** The app monitors the charging level. When it reaches 80%, a continuous alarm plays and a notification with a "Stop alarm" button appears.
2. **When unplugged:** The 80% alarm automatically silences. If the battery later drains down to 22%, a gentle notification alerts you to plug in soon.

---

## 📱 UI Overview

- **Top Bar (AppBar):**
  - Left button: **"Before use"** / **"Ennen käyttöä"** (smooth-scrolls to setup instructions).
  - Center: Localized App title.
- **Header Card:**
  - Dynamic battery visualizer with color states (green when charging, cyan/orange/red depending on level).
  - Real-time battery percentage and status indicator.
- **Alarm Banner:**
  - Prominent banner displayed whenever an alarm is ringing, featuring an instant **"Stop alarm"** button.
- **Settings Card:**
  - Switch: Enable/disable the 22% low battery notification.
  - Slider: Adjust 80% alarm volume (0% to 100%).
- **Testing Card:**
  - Test 22% notification & test 80% alarm sound.
  - Battery optimization bypass shortcut.
- **Instructions Section ("Before Use"):**
  - Manufacturer-specific guides for Samsung, Xiaomi/Redmi, OnePlus/Oppo, and Android 13/14+ APK restrictions.

---

## 🌐 Supported Languages

The application automatically adapts to the device's system language:

| Language | Locale Code | "Before use" Button | App Title |
|---|---|---|---|
| **English (Default)** | `en` | *Before use* | Battery Monitor |
| **Finnish** | `fi` | *Ennen käyttöä* | Akkuvahti |
| **Swedish** | `sv` | *Före användning* | Batterivakt |
| **German** | `de` | *Vor der Nutzung* | Batteriewächter |

Translations are defined in [`lib/app_strings.dart`](lib/app_strings.dart).

---

## ⚠️ OEM & Manufacturer Settings (Important)

Many Android manufacturers (e.g. Samsung, Xiaomi, OnePlus) aggressively kill background processes when the phone enters deep sleep. To ensure notifications and alarms always fire reliably:

### 📱 Samsung (One UI)
> **Settings** ➔ **Battery** ➔ **Background usage limits** ➔ **Never auto-sleeping apps** ➔ Add **flbatteryfull** (or `fsavenotifications`).

### 📱 Xiaomi / Redmi / POCO (MIUI / HyperOS)
> **App info** ➔ **Autostart** ➔ Turn **ON**.  
> **App info** ➔ **Battery saver** ➔ Select **No restrictions**.

### 📱 OnePlus / Oppo / Realme (OxygenOS / ColorOS)
> **App info** ➔ **Battery usage** ➔ Allow **Background activity**.

### 📱 Android 13 & 14+ (Sideloaded / APK installations)
> If installed directly from an APK:  
> Open **App info** ➔ tap the three dots in the top-right corner (**⋮**) ➔ **Allow restricted settings** ➔ then enable Notification permissions.

*(For detailed device-by-device guides, visit [dontkillmyapp.com](https://dontkillmyapp.com)).*

---

## 🔐 Permissions

The app requests the following Android permissions defined in [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml):

| Permission | Purpose |
|---|---|
| `POST_NOTIFICATIONS` | Displays foreground service status, 22% alerts, and 80% alarm notifications (Android 13+). |
| `FOREGROUND_SERVICE` & `FOREGROUND_SERVICE_SPECIAL_USE` | Runs continuous background service to track battery status when app is minimized. |
| `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Requests exclusion from aggressive Android battery saving limits. |
| `WAKE_LOCK` | Keeps CPU awake during audio alarms and battery state transitions. |
| `RECEIVE_BOOT_COMPLETED` | Automatically restarts the background monitoring service when the phone reboots. |

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) (Dart 3)
- **State Management & Communication:**
  - `FlutterBackgroundService`: Decoupled background isolate communicating with the UI via stream events (`invoke` / `on`).
  - `SharedPreferences`: Persists user volume preference and toggle states.
- **Hardware & Native Integrations:**
  - `battery_plus`: System battery broadcast receiver and level reader.
  - `flutter_local_notifications`: Native notification channels and background action callbacks (`ActionBroadcastReceiver`).
  - `audioplayers`: Native audio engine playing asset sounds (`alarm_80.mp3`, `notify_22.mp3`).
  - `permission_handler`: Manages Android runtime permission requests.

### Project Directory Structure

```
flbatteryloadfull/
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml          # Background service & notification permissions
│       └── res/raw/                     # Notification sound resources (notify_22.mp3)
├── assets/
│   └── sounds/                          # Audio assets (alarm_80.mp3, notify_22.mp3)
├── lib/
│   ├── app_strings.dart                 # Multi-language translations (EN, FI, SV, DE)
│   ├── battery_monitor_service.dart     # Background service & alarm logic
│   └── main.dart                        # Main application UI & Scroll controller
├── test/
│   └── widget_test.dart                 # Widget tests and UI validation
└── pubspec.yaml                         # Dependencies and assets
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.13` or newer)
- Android SDK (API level 24 or newer, tested up to Android 14 / API 34)
- Java 17+ / Gradle

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/flbatteryloadfull.git
   cd flbatteryloadfull
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on a connected Android device:**
   ```bash
   flutter run
   ```

4. **Build APK:**
   - Debug APK:
     ```bash
     flutter build apk --debug
     ```
   - Release APK:
     ```bash
     flutter build apk --release
     ```
   The generated APK will be located at:
   `build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Testing & Validation

Run code analysis and widget tests:

```bash
# Run static analysis
flutter analyze

# Run widget tests
flutter test
```

---

## 📄 License

This project is open-source under the [MIT License](LICENSE).
