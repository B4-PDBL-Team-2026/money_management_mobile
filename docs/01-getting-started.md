# 01 - Getting Started

Panduan ini berisi langkah-langkah untuk melakukan _setup_ dan menjalankan proyek **Money Management Mobile** di _local environment_ Anda.

## 1. Persyaratan Sistem & Instalasi

Sebelum memulai, pastikan sistem Anda memenuhi spesifikasi berikut:

- **Flutter SDK**: Versi `3.10.8` atau yang lebih baru.
- **RAM**: Minimal 8GB (direkomendasikan untuk kelancaran _build_ dan emulator).
- **IDE**: VS Code atau Android Studio dengan ekstensi/plugin Flutter dan Dart yang sudah terinstal.

Untuk memverifikasi versi Flutter Anda, jalankan:

```bash
flutter --version
```

## 2. Generate Code (Build Runner)

Proyek ini menggunakan `injectable` (beserta `get_it`) untuk _Dependency Injection_. Karena itu, Anda **wajib** menjalankan _code generator_ sebelum melakukan _compile_ atau menjalankan aplikasi pertama kali.

Jalankan perintah berikut di terminal pada _root directory_ proyek:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

_(Catatan: Anda juga bisa menggunakan `dart run build_runner build --delete-conflicting-outputs`)_

Jika Anda sedang dalam proses _development_ dan sering mengubah _dependencies_ atau _module_, gunakan perintah `watch` agar _code generator_ berjalan otomatis setiap ada perubahan file:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 3. Konfigurasi Environment

Aplikasi ini membaca konfigurasi _environment_ menggunakan `fromEnvironment` pada saat proses _build_ atau _run_.

Berikut adalah daftar variabel _environment_ yang tersedia beserta nilai _default_-nya:

| Variabel                    | Tipe     | Default Value                 | Deskripsi                                                                       |
| :-------------------------- | :------- | :---------------------------- | :------------------------------------------------------------------------------ |
| `USE_MOCK_API`              | `bool`   | `false`                       | Set ke `true` untuk menggunakan data _mock_ alih-alih memanggil API asli.       |
| `API_BASE_URL`              | `String` | `http://localhost:8000/api`   | Base URL untuk _endpoint_ backend.                                              |
| `SENTRY_DSN`                | `String` | `''` (kosong)                 | DSN url untuk _error tracking_ menggunakan Sentry.                              |
| `APP_ENV`                   | `String` | `development`                 | Status _environment_ saat ini (contoh: `development`, `staging`, `production`). |
| `APP_RELEASE`               | `String` | `money_management_mobile@dev` | Identifier versi rilis untuk Sentry/Analytics.                                  |
| `SENTRY_TRACES_SAMPLE_RATE` | `String` | `0.0`                         | Persentase _tracing_ Sentry (dari `0.0` hingga `1.0`).                          |

### Cara Menjalankan Aplikasi

Untuk memasukkan variabel-variabel di atas saat menjalankan aplikasi, gunakan _flag_ `--dart-define`. Berikut adalah contoh perintah `flutter run` lengkap:

```bash
flutter run \
  --dart-define=USE_MOCK_API=false \
  --dart-define=API_BASE_URL="[https://api.domain-anda.com/api](https://api.domain-anda.com/api)" \
  --dart-define=SENTRY_DSN="[https://examplePublicKey@o0.ingest.sentry.io/0](https://examplePublicKey@o0.ingest.sentry.io/0)" \
  --dart-define=APP_ENV="development"
```

**Tips untuk VS Code:**
Agar tidak perlu mengetik panjang setiap kali menjalankan aplikasi, Anda dapat membuat file `.vscode/launch.json` dan memasukkan argumen _environment_ tersebut di dalam `toolArgs`:

```json
{
	"version": "0.2.0",
	"configurations": [
		{
			"name": "Money Management (Dev)",
			"request": "launch",
			"type": "dart",
			"toolArgs": [
				"--dart-define=USE_MOCK_API=false",
				"--dart-define=API_BASE_URL=http://localhost:8000/api",
				"--dart-define=APP_ENV=development"
			]
		}
	]
}
```
