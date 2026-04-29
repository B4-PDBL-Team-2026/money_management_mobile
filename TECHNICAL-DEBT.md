# Technical Debt

Tuliskan semua technical debt yang ada di proyek ini, termasuk alasan mengapa technical debt tersebut ada. Jika memungkinkan, sertakan juga rencana untuk mengatasi technical debt tersebut di masa depan.

## List

### Mengubah Try-catch dengan Either

- **Alasan**: Saat ini, kita menggunakan try-catch untuk menangani error di beberapa bagian kode. Namun, kode menjadi sulit untuk dibaca dan dipelihara karena banyaknya try-catch yang bersarang.
- **Rencana**: Kita berencana untuk mengganti try-catch dengan Either, yang akan membuat kode lebih bersih dan mudah dipahami. Either akan memungkinkan kita untuk menangani error dengan cara yang lebih terstruktur dan konsisten di seluruh proyek.

### Konsistensi Tipe Kategori

- **Alasan**: Saat ini, kita memiliki beberapa tipe kategori yang berbeda di berbagai bagian kode dengan format string yang tidak konsisten. Hal ini menyebabkan kebingungan dan kesulitan dalam pemeliharaan kode.
- **Rencana**: Kita berencana untuk membuat tipe kategori yang konsisten di seluruh proyek. Ini akan meningkatkan keterbacaan kode dan memudahkan pengelolaan kategori di masa depan.

### Parsing Timezone

- **Alasan**: Saat ini, masih ada beberapa bagian kode pengiriman tanggal atau waktu ke backend tanpa parsing ke ISO8601. Hal ini dapat menyebabkan masalah kompatibilitas dan kesalahan dalam penanganan tanggal di backend. Begitu juga saat penerimaan tanggal dari backend, kita belum melakukan parsing ke format yang konsisten, yang dapat menyebabkan masalah dalam penggunaan tanggal di frontend.
- **Rencana**: Kita berencana untuk memastikan bahwa semua tanggal yang dikirim ke backend diparsing ke format ISO8601, dan semua tanggal yang diterima dari backend diparsing ke format yang konsisten di frontend. Ini akan meningkatkan kompatibilitas dan mengurangi risiko kesalahan dalam penanganan tanggal di seluruh proyek.
