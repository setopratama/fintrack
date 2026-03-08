# ❓ FAQ — FinTrack Aplikasi Pencatatan Keuangan Pribadi

Berikut adalah pertanyaan yang sering diajukan mengenai FinTrack. Jika pertanyaan Anda tidak ada di sini, silakan hubungi kami via email atau buka **Issue** di repositori GitHub kami.

---

## 📋 Daftar Pertanyaan

1. [Pertanyaan Umum](#-pertanyaan-umum)
2. [Instalasi & Setup](#-instalasi--setup)
3. [Penggunaan Dasar](#-penggunaan-dasar)
4. [Dashboard & Akun](#-dashboard--akun)
5. [Edit & Hapus Transaksi](#-edit--hapus-transaksi)
6. [Filter & Pencarian](#-filter--pencarian)
7. [Backup & Restore](#-backup--restore)
8. [Keamanan & Privasi](#-keamanan--privasi)
9. [Performa & Penyimpanan](#-performa--penyimpanan)

---

## 💡 Pertanyaan Umum

### P: Apa itu FinTrack?
**J:** FinTrack adalah aplikasi pencatatan keuangan pribadi yang ringan, cepat, dan 100% offline. Aplikasi ini memungkinkan Anda mencatat semua pemasukan dan pengeluaran tanpa terhubung ke internet.

### P: Biaya berapa untuk menggunakan FinTrack?
**J:** **Gratis selamanya!** FinTrack sepenuhnya gratis dan dikembangkan untuk membantu manajemen keuangan pribadi secara mandiri.

### P: Apakah FinTrack memerlukan koneksi internet?
**J:** **Tidak!** FinTrack bekerja 100% offline. Data Anda tersimpan di memori internal perangkat Anda sendiri.

### P: Siapa pengembang aplikasi ini?
**J:** FinTrack dikembangkan oleh tim di **www.somatechno.com** untuk memberikan solusi pencatatan keuangan yang simpel dan privat.

---

## 🚀 Instalasi & Setup

### P: Bagaimana cara menginstal FinTrack?
**J:** 
1. **Download APK** dari [GitHub Releases](https://github.com/setopratama/fintrack.git)
2. **Buka file APK** dan izinkan instalasi dari sumber tidak dikenal jika diminta.
3. **Luncurkan aplikasi** dan mulai gunakan!

### P: Apakah saya harus membuat akun?
**J:** **Tidak!** FinTrack tidak memerlukan registrasi. Begitu instal, Anda bisa langsung mencatat. Identitas Anda (Nama & Email) bisa diatur di halaman Profil hanya untuk personalisasi tampilan.

---

## 📖 Penggunaan Dasar

### P: Di mana saya bisa menemukan menu Pengaturan?
**J:** Menu Pengaturan kini dapat diakses melalui **ikon gerigi (Settings)** yang terletak di pojok kanan atas halaman **Dashboard**.

### P: Apa saja yang ada di menu Pengaturan?
**J:** Di halaman Pengaturan, Anda dapat menemukan:
- **Export Data (JSON)**: Mencadangkan data ke file.
- **Import Data (JSON)**: Mengembalikan data dari file cadangan.
- **Tentang Aplikasi**: Informasi versi dan pengembang.

### P: Bagaimana cara mengubah tema (Mode Gelap)?
**J:** Buka halaman **Profil**, terdapat tombol switch **Mode Gelap** yang bisa Anda aktifkan sesuai selera.

---

## 💳 Dashboard & Akun

### P: Apa itu "MAIN ACCOUNT" dan nomor di bawahnya?
**J:** "MAIN ACCOUNT" adalah akun utama pencatatan Anda. Nomor di bawahnya (contoh: `2026 0308`) adalah **ID Akun** unik yang dibuat otomatis berdasarkan tanggal pertama kali Anda menginstal aplikasi FinTrack (`YYYY MMDD`).

### P: Apakah saldo saya otomatis dihitung?
**J:** **Ya!** Dashboard menampilkan **Total Balance** yang dihitung real-time dari seluruh Pemasukan dikurangi Pengeluaran.

---

## 🔍 Filter & Pencarian

### P: Bagaimana cara mencari transaksi tertentu?
**J:** Buka halaman **Riwayat**, di bagian atas terdapat kotak **Pencarian**. Ketik keterangan transaksi atau nama kategori (misal: "Makan") untuk menyaring daftar secara instan.

### P: Bisakah saya mencari berdasarkan tanggal?
**J:** **Bisa!** Klik ikon **Kalender** di pojok kanan atas halaman Riwayat untuk memilih tanggal spesifik. Hanya transaksi pada tanggal tersebut yang akan ditampilkan.

### P: Bagaimana cara mereset filter?
**J:** Klik tanda **"x"** di kotak pencarian atau klik ikon **Hapus Kalender (Event Busy)** di pojok kanan atas untuk kembali menampilkan semua data.

---

## 💾 Backup & Restore

### P: Di mana fitur Backup sekarang?
**J:** Fitur Backup kini sudah direlokasi ke halaman **Pengaturan** (ikon gerigi di Dashboard) agar halaman Profil tetap rapi.

### P: Bagaimana cara memindahkan data ke HP baru?
**J:** 
1. Di HP lama: Masuk ke Pengaturan → **Export Data (JSON)** → Simpan file.
2. Kirim file tersebut ke HP baru.
3. Di HP baru: Install FinTrack → Masuk ke Pengaturan → **Import Data (JSON)** → Pilih file tadi.
4. Data Anda akan langsung kembali lengkap sesuai backup terakhir.

---

## 🔒 Keamanan & Privasi

### P: Di mana data saya disimpan?
**J:** Data Anda disimpan di **Local Storage** perangkat Anda. Kami tidak menggunakan server cloud, sehingga tidak ada orang lain (termasuk kami) yang bisa melihat data keuangan Anda.

---

## ⚡ Performa & Penyimpanan

### P: Bagaimana metode penyimpanan data FinTrack?
**J:** FinTrack menggunakan sistem penyimpanan lokal yang menyimpan data dalam format teks JSON di memori internal perangkat Anda.

### P: Seberapa cepat aplikasi meload data jika sudah banyak?
**J:** FinTrack dirancang untuk tetap instan pada penggunaan normal (ribuan transaksi). Seluruh data akan dimuat ke dalam memori RAM saat aplikasi dibuka agar proses pencarian dan filter berjalan secepat kilat tanpa jeda loading.

### P: Apakah data ribuan transaksi akan membuat HP berat?
**J:** Tidak. Karena data transaksi berupa teks, penggunaan RAM sangatlah kecil. Untuk 5.000 transaksi hanya memakan sedikit ruang di RAM. Performa akan tetap stabil bahkan setelah bertahun-tahun penggunaan aktif.

---

<p align="center">
  <strong>Support by www.somatechno.com</strong>
  <br/>
  <sub>Kontak: setopratama@gmail.com</sub>
  <br/>
  <sub>Terakhir diupdate: 8 Maret 2026</sub>
</p>
