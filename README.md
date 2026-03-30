# Money Management Mobile

Aplikasi Flutter untuk manajemen keuangan pribadi yang membantu pengguna melacak pengeluaran, mengategorikan transaksi, mengelola biaya tetap, dan melihat dashboard keuangan mereka.

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10.8+
- **State Management**: Flutter Bloc (Cubit)
- **Networking**: Dio
- **Dependency Injection**: GetIt
- **Routing**: Go Router
- **Database/Storage**: SharedPreferences
- **Logger**: Logging package
- **UI Components**: Flutter Material Design, Phosphor Icons
- **Fonts**: Google Fonts
- **SVG Support**: flutter_svg
- **Timezone Support**: flutter_timezone

## 📦 Prasyarat

Sebelum memulai, pastikan Anda memiliki:

- **Flutter SDK**: 3.10.8 atau lebih tinggi
  - [Instalasi Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: 3.10.8 atau lebih tinggi (included dalam Flutter)
- **Android Studio** atau **Xcode** (untuk emulator/device)
- **Git** untuk version control
- Minimal **8GB RAM** untuk development

Verifikasi instalasi:
```bash
flutter doctor
```

## 🚀 Setup Awal

### 1. Clone Repository
```bash
git clone <repository-url>
cd money_management_mobile
```

### 2. Install Dependencies
```bash
flutter pub get
```

## 🏃 Menjalankan Aplikasi

### Menjalankan dengan Environment Variables (--dart-define)

Gunakan `--dart-define` untuk mengatur endpoint API dan konfigurasi lainnya:

#### Development Environment
```bash
flutter run --dart-define=API_BASE_URL="http://10.0.2.2:8080/api"
```

#### Staging Environment
```bash
flutter run --dart-define=API_BASE_URL="https://staging-api.example.com/api"
```
### Hot Reload & Hot Restart
Saat aplikasi sedang berjalan, gunakan:
- **Hot Reload** (Type `r`): Reload code tanpa restart aplikasi
- **Hot Restart** (Type `R`): Restart aplikasi lengkap
- **Quit** (Type `q`): Hentikan aplikasi

#### Production Build
```bash
flutter build apk --release --dart-define=API_BASE_URL="https://api.example.com/api"
flutter build ios --release --dart-define=API_BASE_URL="https://api.example.com/api"
flutter build appbundle --release --dart-define=API_BASE_URL="https://api.example.com/api"
```

**Catatan**: 
- Gunakan `10.0.2.2` untuk localhost pada Android emulator
- Gunakan `localhost` atau `127.0.0.1` pada iOS simulator
- Definisikan variabel di `lib/core/constants/` atau akses di runtime dengan `const String.fromEnvironment('API_BASE_URL')`

## 🏗️ Build untuk Production

### Android Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (untuk Google Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS Release Build
```bash
# Build untuk device
flutter build ios --release

# Build untuk simulator
flutter build ios --simulator --release
```
Output: `build/ios/iphoneos/Runner.app`

### Web Release Build
```bash
flutter build web --release
```
Output: `build/web/`

## 🏛️ Arsitektur Proyek

Proyek mengikuti **Clean Architecture** dengan struktur feature-based:

```
lib/
├── core/              # Shared utilities, themes, routing
│   ├── constants/
│   ├── data/
│   ├── domain/
│   ├── error/
│   ├── network/
│   ├── routes/
│   ├── theme/
│   ├── utils/
│   └── widgets/       # Reusable UI components
├── features/          # Feature modules
│   ├── auth/          # Authentication & Session
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── category/      # Transaction Categories
│   ├── dashboard/     # Dashboard & Insights
│   ├── profile/       # User Profile & Fixed Costs
│   └── transaction/   # Transaction Management
├── injection_container.dart  # Dependency Injection Setup
├── main.dart          # Application Entry Point
└── outer_shell.dart   # Root Widget Configuration
```

### Lapisan Arsitektur

- **Presentation**: Cubit (state management), Pages, dan Widgets
- **Domain**: Entities, Repositories (interfaces), dan Use Cases
- **Data**: Data Sources, Models, dan Repository Implementations

## 📝 Development Guidelines

### State Management
- Gunakan **Cubit** untuk screen-level state
- Global state (Session, Theme) di atas MaterialApp
- Satu Cubit per screen untuk menghindari kompleksitas

### Styling & Theme
- Gunakan `AppColors` untuk warna
- Gunakan `AppSizes` untuk spacing dan radius
- Gunakan `Theme.of(context).textTheme` untuk typography
- Hindari hardcoded values

### Logging
- Gunakan `Logger` package, jangan `print()`
- Level: `fine`, `info`, `warning`, `severe`

### Error Handling
- Tangani errors di layer Data dan map ke Failure
- Emit state Error di Cubit dengan pesan user-friendly
- Tampilkan SnackBar untuk error feedback

### Cross-Feature Communication
- Gunakan Router untuk navigasi antar feature
- Gunakan DI untuk dependency resolution
- Share data via domain contracts (UseCase), bukan implementation classes

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Bloc Library](https://bloclibrary.dev)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)

---

**Last Updated**: 31 March 2026, 05:55 AM UTC+7
