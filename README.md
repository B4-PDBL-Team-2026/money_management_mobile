# Moco: Money Control

Aplikasi manajemen keuangan pribadi yang dibangun menggunakan Flutter dengan fokus pada arsitektur yang bersih (_Clean Architecture_), skalabilitas, dan kemudahan pemeliharaan. Proyek ini menggunakan paket ID `com.moco.moneycontrol`.

## 🚀 Gambaran Umum

**Moco** dirancang untuk membantu pengguna mengelola transaksi, memantau kesehatan finansial melalui dashboard, dan mengatur pengeluaran tetap (_fixed costs_). Kode program mengikuti standar pengembangan industri dengan pemisahan logika bisnis dan UI yang ketat.

## 🛠️ Tech Stack

- **Framework**: Flutter.
- **State Management**: Bloc/Cubit.
- **Dependency Injection**: Get It & Injectable.
- **Networking**: Dio.
- **Error Tracking**: Sentry.
- **Local Storage**: Shared Preferences

## 📂 Dokumentasi Proyek

Informasi detail mengenai cara memulai, arsitektur, dan aturan pengembangan dapat ditemukan pada tautan berikut:

1.  **[01 - Getting Started](https://github.com/B4-PDBL-Team-2026/money_management_mobile/blob/dev/docs/01-getting-started.md)**: Langkah-langkah _setup_ lingkungan lokal, instalasi SDK, penggunaan _build runner_, dan konfigurasi _environment variables_.
2.  **[02 - Architecture Flow](https://github.com/B4-PDBL-Team-2026/money_management_mobile/blob/dev/docs/02-architecture-flow.md)**: Penjelasan mengenai struktur folder (`core` & `features`), penerapan Clean Architecture, serta aturan akses repositori secara pragmatis.
3.  **[03 - State Management](https://github.com/B4-PDBL-Team-2026/money_management_mobile/blob/dev/docs/03-state-management.md)**: Standar penggunaan Cubit, siklus hidup _provider_ (Long-lived vs Temporary), dan komunikasi antar modul menggunakan _Event Bus_.
4.  **[04 - Development Rules](https://github.com/B4-PDBL-Team-2026/money_management_mobile/blob/dev/docs/04-development-rules.md)**: Prinsip _Dumb UI_, standarisasi _theming_ (AppColors, AppSizes), penanganan _error_, serta konvensi penamaan kelas.
