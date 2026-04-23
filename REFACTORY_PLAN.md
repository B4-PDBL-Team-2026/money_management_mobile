# Rencana Refactoring & Penyederhanaan

- [x] Mengonfigurasi library `injectable` dan mengubah `injection_container.dart` menjadi berbasis _code generation_.
- [x] Membuat file `.vscode/money_management.code-snippets` untuk _template_ Entity, Model, Cubit, dan State.
- [x] Membuat _Export Barrels_ untuk folder-folder utilitas dan _widgets_ utama (`lib/core/widgets/widgets.dart`, dll).
- [x] Menghapus _Use Case passthrough_ pada fitur-fitur yang sudah ada (Auth, Profile, Transaction, Dashboard) dan menghubungkan Cubit langsung ke Repository.
- [ ] Mengonfigurasi _strong-typed routing_ pada `app_router.dart` menggunakan _code generation_.
- [ ] Mengubah Repository utama (terutama `TransactionRepository` dan `DashboardRepository`) agar memancarkan `Stream` untuk data yang sering berubah.
- [ ] Menyesuaikan Cubit terkait agar men-_listen_ `Stream` dari Repository, menghapus komunikasi Cubit-ke-Cubit.
- [ ] Membuat kelas sentralisasi `ErrorHandler` / _Base Cubit_ untuk menangani _Exceptions_.
- [ ] Mengonversi _Cubit State_ yang masih manual menjadi menggunakan `freezed`.
- [ ] Memastikan seluruh penguraian JSON di layer _Data Model_ sudah menggunakan `json_serializable`.