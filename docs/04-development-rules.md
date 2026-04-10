# 04 - Development Rules

Dokumen ini menetapkan aturan ketat dan standar operasional dalam menulis kode untuk proyek **Money Management Mobile**. Setiap pengembang wajib mematuhi aturan ini untuk menjaga konsistensi dan kualitas kode.

## 1. Dumb UI: Strict Separation of Concerns

Kita menerapkan prinsip **Dumb UI**. Widget hanya boleh bertanggung jawab atas representasi visual dan interaksi pengguna, tanpa memiliki pengetahuan tentang *business logic*.

- **Tanggung Jawab Widget**:
    - Memicu fungsi pada `Cubit` saat ada interaksi pengguna (contoh: `onPressed`).
    - Melakukan *render* berdasarkan *state* yang dikirim oleh `Cubit`.
    - Logika UI sederhana seperti *layout* berdasarkan ukuran layar atau *toggle* visibilitas sederhana (menggunakan *flag* dari *state*).
- **Larangan Ketat**:
    - **Dilarang** melakukan pemanggilan API secara langsung di dalam Widget.
    - **Dilarang** melakukan kalkulasi data mentah (misal: menjumlahkan total transaksi) di dalam Widget. Lakukan ini di `UseCase` atau `Cubit`.
    - **Dilarang** menyalin logika bisnis ke dalam blok `if-else` di dalam metode `build`. Gunakan *state* yang sudah diolah.

## 2. Theming & Styling: No Hardcoded Values

Untuk menjaga konsistensi desain dan kemudahan kustomisasi, dilarang keras menggunakan nilai *hardcoded* untuk warna, ukuran, dan gaya teks.

- **AppColors**: Gunakan kelas `AppColors` untuk semua kebutuhan warna. Jangan gunakan `Color(0xFF...)` atau `Colors.blue` secara langsung.
    - Contoh: `color: AppColors.primary`.
- **AppSizes**: Gunakan `AppSizes` untuk *spacing*, *padding*, *margin*, dan *radius*.
    - Contoh: `SizedBox(height: AppSizes.spacing4)` atau `borderRadius: BorderRadius.circular(AppSizes.radiusMd)`.
- **AppTextStyles**: Gunakan gaya teks yang sudah didefinisikan untuk semua komponen label atau teks.
    - Contoh: `style: AppTextStyles.h1`.
    - Jika perlu mengubah warna teks, gunakan metode `.copyWith(color: ...)` daripada membuat gaya baru.

## 3. Logging & Debugging: Print() is Forbidden

Penggunaan `print()` atau `debugPrint()` secara sembarangan dapat mengotori konsol dan membocorkan informasi sensitif di lingkungan rilis.

- **Aturan**: Dilarang menggunakan `print()`.
- **Solusi**: Gunakan kelas `AppLogger` yang telah disediakan. `AppLogger` secara otomatis mengintegrasikan log ke dalam konsol *developer* dan mengirimkan *error* level tinggi ke **Sentry** saat di lingkungan produksi.
- **Level Log**:
    - `Logger.root.info(...)`: Untuk informasi alur aplikasi.
    - `Logger.root.warning(...)`: Untuk kejadian yang tidak diharapkan tapi tidak merusak aplikasi.
    - `Logger.root.severe(...)`: Untuk *error* fatal yang harus ditangkap oleh Sentry.

## 4. Dependency Injection & Code Generation

Proyek ini sangat bergantung pada otomatisasi kode untuk meminimalkan kesalahan manusia.

- **Build Runner**: Setiap kali menambah atau mengubah anotasi `@injectable`, `@lazySingleton`, atau `@singleton`, Anda **harus** menjalankan *build_runner*.
    - Perintah: `dart run build_runner build --delete-conflicting-outputs`.
- **GetIt**: Gunakan `getIt<T>()` untuk mengambil *instance* dari *repository*, *usecase*, atau *cubit* (sesuai aturan siklus hidup di dokumen 03).

## 5. Async/Await & Error Handling

- **Asynchrony**: Selalu pilih `async/await` daripada menggunakan `.then()` untuk menjaga keterbacaan kode.
- **Error Mapping**: Setiap *exception* yang terjadi di layer `Data` (Remote/Local) harus ditangkap dan dikonversi menjadi objek `Failure` sebelum dikirim ke layer `Presentation`.
- **Rethrow**: Gunakan kata kunci `rethrow` hanya jika Anda perlu menangkap *error* di blok `catch` tetapi tetap ingin meneruskannya ke pemanggil di atasnya.

## 6. Naming Convention (Standard Suffix)

Gunakan akhiran (*suffix*) yang konsisten untuk nama file dan kelas sesuai dengan perannya:
- Halaman UI: `...Page` (Contoh: `LoginPage`).
- Komponen UI: `...Widget` atau nama deskriptif (Contoh: `AppButton`).
- State: `...Cubit` dan `...State`.
- Kontrak Data: `...Repository`.
- Aksi Bisnis: `...UseCase`.