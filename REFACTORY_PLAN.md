# Rencana Refactoring & Penyederhanaan Proyek (Sprint 2)

Dokumen ini menguraikan inisiatif penyederhanaan _codebase_ agar pengembangan fitur di Sprint 2 menjadi lebih cepat, minim _boilerplate_, dan lebih mudah dipahami oleh seluruh anggota tim.

## 🎯 Tujuan Utama

1. **Mengurangi Beban Kognitif:** Mengurangi kompleksitas arsitektur agar anggota tim bisa fokus pada logika bisnis dan UI.
2. **Mempercepat Development:** Menyiapkan _template_, _generator_, dan utilitas dasar untuk memangkas waktu _setup_ fitur baru.
3. **Mencegah Spaghetti Code:** Menyediakan alur komunikasi data yang jelas dan _type-safe_.

---

## 🛠️ Fokus Perubahan (The "What")

### 1. Penyederhanaan Arsitektur (Pragmatic Clean Architecture)

- **Penghapusan Use Case Passthrough:** _Use Case_ yang hanya bertugas mengoper pemanggilan dari _Repository_ ke _Cubit_ (tanpa logika bisnis tambahan) akan dihapus. _Cubit_ diizinkan memanggil _Repository_ secara langsung untuk kasus CRUD standar.
- **Reactive Repository:** Menggantikan komunikasi antar-Cubit dengan _Reactive Repository_ menggunakan `Stream` (misal: `BehaviorSubject` dari `rxdart`). _Repository_ akan menjadi _single source of truth_, dan _Cubit_ cukup men-_listen_ perubahan datanya.

### 2. Automasi & Dependency Injection

- **Implementasi `injectable`:** Konfigurasi `get_it` di `injection_container.dart` akan diotomatisasi menggunakan anotasi `@injectable` / `@lazySingleton` dan _build_runner_.
- **Code Generation:** Memaksimalkan penggunaan `freezed` untuk _Cubit State_ dan `json_serializable` untuk _Model_, menghindari pembuatan fungsi `copyWith` dan `fromJson/toJson` secara manual.

### 3. Utilitas & Standardisasi Tim

- **Sentralisasi Error Handling:** Membuat _Base Cubit_ atau utilitas _Error Handler_ global yang otomatis memetakan `Exception` dari API menjadi pesan _error_ UI yang ramah pengguna.
- **Strong-Typed Routing:** Menggunakan ekstensi _code generation_ untuk `go_router` agar navigasi menggunakan _Object_ (contoh: `HomeRoute().go(context)`), bukan _String path_ yang rawan _typo_.
- **Export Barrels:** Menggunakan `index.dart` atau nama _file_ jamak (contoh: `widgets.dart`) untuk membungkus banyak _file_ menjadi satu _import_ yang ringkas.
- **VS Code Snippets:** Menyediakan _file_ `.vscode/money_management.code-snippets` agar tim bisa men-generate kerangka _file_ secara otomatis.

---

## 📅 Rencana Eksekusi 1 Minggu (The "When")

Jadwal ini dirancang agar refactoring dasar selesai di sebelum Sprint 2, sehingga tim bisa fokus pada pengembangan fitur dengan _codebase_ yang sudah diperbarui.

### Hari 1: Fondasi & Automasi Dasar

- [x] Mengonfigurasi library `injectable` dan mengubah `injection_container.dart` menjadi berbasis _code generation_.
- [ ] Membuat file `.vscode/money_management.code-snippets` untuk _template_ Entity, Model, Cubit, dan State.
- [ ] Membuat _Export Barrels_ untuk folder-folder utilitas dan _widgets_ utama (`lib/core/widgets/widgets.dart`, dll).

### Hari 2: Pemangkasan Arsitektur & Routing

- [ ] Menghapus _Use Case passthrough_ pada fitur-fitur yang sudah ada (Auth, Profile, Transaction, Dashboard) dan menghubungkan Cubit langsung ke Repository.
- [ ] Mengonfigurasi _strong-typed routing_ pada `app_router.dart` menggunakan _code generation_.

### Hari 3: Reactive State & Error Handling

- [ ] Mengubah Repository utama (terutama `TransactionRepository` dan `DashboardRepository`) agar memancarkan `Stream` untuk data yang sering berubah.
- [ ] Menyesuaikan Cubit terkait agar men-_listen_ `Stream` dari Repository, menghapus komunikasi Cubit-ke-Cubit.
- [ ] Membuat kelas sentralisasi `ErrorHandler` / _Base Cubit_ untuk menangani _Exceptions_.

### Hari 4: Refactoring Data Model & State

- [ ] Mengonversi _Cubit State_ yang masih manual menjadi menggunakan `freezed`.
- [ ] Memastikan seluruh penguraian JSON di layer _Data Model_ sudah menggunakan `json_serializable`.
- [ ] Menjalankan `flutter pub run build_runner build --delete-conflicting-outputs` secara menyeluruh.

### Hari 5: Migrasi Keseluruhan & Testing Internal

- [ ] Menyelesaikan sisa-sisa migrasi kode lama ke struktur baru yang sudah disederhanakan.
- [ ] Melakukan _testing_ aplikasi secara menyeluruh (aplikasi berjalan normal, tidak ada _dependency_ yang gagal di-inject, navigasi berjalan baik).
- [ ] Menangani _bug_ atau _error_ kompilasi akibat refactoring.

### Hari 6: Dokumentasi & Transfer Knowledge

- [ ] Merapikan kode dan menghapus komentar/kode mati (_dead code_) sisa refactoring.
- [ ] Mengadakan sinkronisasi singkat dengan tim (sekitar 30-45 menit) untuk mendemokan cara menggunakan _snippet_, _injectable_, dan _Reactive Repository_.
- [ ] Membagikan _branch_ refactoring untuk di-_review_ (PR) dan di-_merge_ ke `dev`.

### Hari 7: Buffer & Sprint 2 Kick-off

- [ ] Cadangan waktu jika ada perbaikan tambahan dari hasil _code review_.
- [ ] Anggota tim mulai mengambil _task_ untuk Sprint 2 dengan _codebase_ yang sudah diperbarui.

---

## 💡 Panduan Cepat untuk Tim (TL;DR)

1. **Butuh buat Cubit/Model baru?** Gunakan perintah _snippet_ di VS Code (ketik awalan snippet-nya).
2. **Menambahkan Dependency baru?** Cukup tambahkan anotasi `@injectable` di atas kelasnya, lalu jalankan `flutter pub run build_runner build`.
3. **Navigasi halaman?** Jangan gunakan `context.go('/path')`, gunakan _Typed Route_ (misal: `const DashboardRoute().go(context)`).
4. **Menangani Error API?** Gunakan utilitas `ErrorHandler` yang sudah disediakan, jangan buat _try-catch_ pesan _error_ manual di setiap UI.
