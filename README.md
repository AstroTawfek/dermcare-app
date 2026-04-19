# 🏥 DermCare — Dermatology Doctor Appointment App
 
> A cross-platform Flutter mobile application connecting patients
> with certified dermatology specialists.
 
---
 
## 🛠️ Tech Stack
 
- **Flutter (Dart)** — Cross-platform mobile (Android + iOS)
- **Firebase Auth** — Email/Password authentication
- **Cloud Firestore** — Real-time database
- **Go Router** — Declarative navigation with auth guard
- **Provider** — State management
 
---
 
## ⚙️ Installation
 
### Prerequisites
- Flutter SDK 3.x installed and added to PATH
- VS Code with Flutter + Dart extensions
- Android phone with USB Debugging enabled (for Android)
- Xcode (macOS only, for iOS Simulator)
 
### Steps
 
```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/dermcare-app.git
cd dermcare-app
 
# 2. Install packages
flutter pub get
 
# 3. Configure Firebase (each member does this locally)
dart pub global activate flutterfire_cli
flutterfire configure   # select: dermcare-app project
 
# 4. Run on connected Android phone
flutter run
```
 
---
 
## 📱 Features
 
- ✅ Firebase Email/Password Authentication
- ✅ Browse Male and Female Dermatologists (Gender Filter)
- ✅ Doctor Profiles with Full Details
- ✅ Schedule Appointments (Calendar Date Picker + Time Slots)
- ✅ View Appointment History with Status Badges
- ✅ Profile Management + Secure Logout
- ✅ Notifications Screen
- 🔜 Chat (Coming Soon)
- 🔜 Payment Integration (Coming Soon)
 
---
 
## 📁 Project Structure
 
```
lib/
├── core/constants/        # App colours and text styles
├── models/                # Data models (User, Doctor, Appointment)
├── services/              # Firebase Auth and Firestore services
├── screens/               # All feature screens by module
├── widgets/               # Reusable UI components
└── routes/app_routes.dart # All GoRouter navigation routes
```
 
---
 
## 🔐 Security Note
 
Firebase configuration files are excluded from this repo via .gitignore.
Run `flutterfire configure` after cloning to generate your local config.
