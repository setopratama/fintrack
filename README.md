# 💰 FinTrack — Aplikasi Pencatatan Keuangan Pribadi

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Storage-Local%20Storage-green?style=for-the-badge&logo=databricks&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=apple&logoColor=white"/>
</p>

<p align="center">
  Aplikasi pencatatan keuangan pribadi yang ringan, cepat, dan bekerja sepenuhnya secara <strong>offline</strong>. 
  Data tersimpan langsung di perangkat Anda, dengan fitur backup & restore via file JSON.
</p>

---

## 📋 Daftar Isi

- [Fitur Utama](#-fitur-utama)
- [Screenshot](#-screenshot)
- [Teknologi](#-teknologi)
- [Struktur Data](#-struktur-data)
- [Instalasi & Setup](#-instalasi--setup)
- [Cara Penggunaan](#-cara-penggunaan)
- [Edit & Hapus Transaksi](#-edit--hapus-transaksi)
- [Fitur Backup & Restore](#-fitur-backup--restore)
- [Filter & Pencarian](#-filter--pencarian)
- [Struktur Proyek](#-struktur-proyek)
- [Kontribusi](#-kontribusi)
- [Lisensi](#-lisensi)

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 📂 **Kategori** | Kelompokkan transaksi berdasarkan kategori kustom (Makan, Transport, Gaji, dll.) |
| 📅 **Tanggal Transaksi** | Catat tanggal tepat setiap transaksi |
| 📝 **Keterangan** | Tambahkan catatan/deskripsi detail setiap transaksi |
| ➕ **Pemasukan** | Catat semua sumber pemasukan |
| ➖ **Pengeluaran** | Catat semua jenis pengeluaran |
| 🔍 **Filter Tanggal** | Tampilkan transaksi berdasarkan tanggal spesifik |
| 🗓️ **Filter Bulan** | Tampilkan transaksi per bulan |
| 📆 **Filter Tahun** | Tampilkan transaksi per tahun |
| ✏️ **Edit Transaksi** | Ubah jenis, kategori, tanggal, keterangan, atau jumlah transaksi yang sudah dicatat |
| 🗑️ **Hapus Transaksi** | Hapus transaksi pemasukan atau pengeluaran dengan konfirmasi |
| 📤 **Export JSON** | Backup semua data ke file `.json` |
| 📥 **Import JSON** | Restore data dari file backup `.json` |
| 📱 **Offline First** | Semua data tersimpan lokal di perangkat, tanpa internet |

---

## 📸 Screenshot

```
┌─────────────────────┐   ┌─────────────────────┐   ┌─────────────────────┐
│   Dashboard         │   │  Tambah / Edit      │   │   Riwayat / Filter  │
│                     │   │  Transaksi          │   │                     │
│  Saldo: Rp 2.500.000│   │  Jenis: ● Pemasukan │   │  Filter: Bulan ▼   │
│                     │   │         ○ Pengeluaran│   │  Maret 2026        │
│  Pemasukan  Keluar  │   │                     │   │                     │
│  3.000.000  500.000 │   │  Kategori: [Gaji ▼] │   │  03/03 Gaji        │
│                     │   │  Tanggal: [03/03/26]│   │  +Rp 3.000.000  ✏️ │
│  Transaksi Terbaru  │   │  Jumlah: [Rp ...... ]│   │                     │
│  ──────────────     │   │  Ket:    [.........]│   │  05/03 Makan       │
│  Gaji    +3.000.000 │   │                     │   │  -Rp 50.000     ✏️ │
│  Makan     -50.000  │   │  [Batal] [  Simpan] │   │                     │
│  Transport  -25.000 │   │                     │   │  [Export] [Import]  │
└─────────────────────┘   └─────────────────────┘   └─────────────────────┘
```

---

## 🛠 Teknologi

### Tech Stack

```
Flutter (SDK ≥ 3.0.0)
├── Dart (≥ 3.0.0)
├── shared_preferences       → Penyimpanan data lokal (Local Storage)
├── path_provider            → Akses direktori file sistem perangkat
├── share_plus               → Berbagi file export ke aplikasi lain
├── file_picker              → Memilih file JSON saat import
├── intl                     → Format tanggal dan mata uang (Rupiah)
├── uuid                     → Generate ID unik setiap transaksi
└── flutter_bloc / provider  → State management
```

### Mengapa Local Storage?
- ✅ **Privasi penuh** — data tidak dikirim ke server manapun
- ✅ **Bekerja 100% offline** — tidak butuh koneksi internet
- ✅ **Performa cepat** — tidak ada latensi jaringan
- ✅ **Gratis selamanya** — tidak ada biaya berlangganan cloud

---

## 📦 Struktur Data

### Model Transaksi

```dart
class Transaksi {
  final String id;           // UUID unik
  final String jenis;        // 'pemasukan' | 'pengeluaran'
  final String kategori;     // Nama kategori (contoh: 'Makan', 'Gaji')
  final DateTime tanggal;    // Tanggal transaksi
  final String keterangan;   // Deskripsi/catatan
  final double jumlah;       // Nominal (dalam Rupiah)
  final DateTime createdAt;  // Waktu pencatatan dibuat
  final DateTime? updatedAt; // Waktu terakhir diedit (null jika belum pernah diedit)
}
```

### Contoh Format JSON Backup

```json
{
  "versi": "1.0.0",
  "tanggal_export": "2026-03-08T10:30:00.000Z",
  "total_transaksi": 3,
  "data": [
    {
      "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "jenis": "pemasukan",
      "kategori": "Gaji",
      "tanggal": "2026-03-03T00:00:00.000Z",
      "keterangan": "Gaji bulan Maret 2026",
      "jumlah": 3000000.0,
      "createdAt": "2026-03-03T08:00:00.000Z"
    },
    {
      "id": "b2c3d4e5-f6a7-8901-bcde-f12345678901",
      "jenis": "pengeluaran",
      "kategori": "Makan",
      "tanggal": "2026-03-05T00:00:00.000Z",
      "keterangan": "Makan siang di warung",
      "jumlah": 50000.0,
      "createdAt": "2026-03-05T12:30:00.000Z"
    },
    {
      "id": "c3d4e5f6-a7b8-9012-cdef-123456789012",
      "jenis": "pengeluaran",
      "kategori": "Transport",
      "tanggal": "2026-03-05T00:00:00.000Z",
      "keterangan": "Ojek ke kantor",
      "jumlah": 25000.0,
      "createdAt": "2026-03-05T07:45:00.000Z"
    }
  ]
}
```

---

## 🚀 Instalasi & Setup

### Prasyarat

Pastikan sudah terinstal:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.0.0
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/)
- Android Emulator / perangkat fisik

### Langkah Instalasi

```bash
# 1. Clone repositori
git clone https://github.com/username/fintrack.git
cd fintrack

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run

# 4. Build APK untuk distribusi
flutter build apk --release
```

### Konfigurasi `pubspec.yaml`

```yaml
name: fintrack
description: Aplikasi pencatatan keuangan pribadi

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
  path_provider: ^2.1.2
  share_plus: ^7.2.1
  file_picker: ^6.1.1
  intl: ^0.19.0
  uuid: ^4.3.3
  provider: ^6.1.1         # atau flutter_bloc jika pakai BLoC

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## 📖 Cara Penggunaan

### Menambah Transaksi Baru

1. Tap tombol **"+"** di halaman utama
2. Pilih jenis: **Pemasukan** atau **Pengeluaran**
3. Pilih atau buat **Kategori** (contoh: Gaji, Makan, Transport, Hiburan)
4. Pilih **Tanggal** transaksi
5. Isi **Keterangan** / catatan
6. Masukkan **Jumlah** (Rupiah)
7. Tap **"Simpan"**

### Mengedit / Menghapus Transaksi

- **Edit**: Tap item transaksi → Edit → Simpan
- **Hapus**: Swipe kiri pada item → Konfirmasi hapus

---

## ✏️ Edit & Hapus Transaksi

### Mengedit Transaksi

Semua field transaksi dapat diubah setelah disimpan:

1. Buka halaman **Riwayat Transaksi**
2. Tap item transaksi yang ingin diedit
3. Tap ikon ✏️ **Edit** (pojok kanan atas atau tombol di bawah detail)
4. Form edit akan terbuka dengan data yang sudah terisi:

```
┌─────────────────────────────┐
│  ✏️  Edit Transaksi          │
│                             │
│  Jenis:  ● Pemasukan        │
│          ○ Pengeluaran      │  ← bisa diubah jenis
│                             │
│  Kategori:  [Gaji       ▼]  │  ← bisa ganti kategori
│  Tanggal:   [03/03/2026  ]  │  ← bisa ubah tanggal
│  Keterangan:[Gaji Maret  ]  │  ← bisa ubah keterangan
│  Jumlah:    [Rp 3.000.000]  │  ← bisa ubah nominal
│                             │
│  [  Batal  ]  [  Simpan  ]  │
└─────────────────────────────┘
```

5. Ubah field yang diperlukan
6. Tap **"Simpan"** — data langsung terupdate di local storage
7. Saldo & ringkasan dashboard otomatis diperbarui ✅

> 💡 **Tip**: Perubahan jenis transaksi (misal dari Pengeluaran → Pemasukan) akan langsung mempengaruhi perhitungan saldo.

### Menghapus Transaksi

**Cara 1 — Swipe to Delete:**
1. Swipe item transaksi ke **kiri** di halaman Riwayat
2. Tombol 🗑️ merah muncul
3. Tap tombol merah → Dialog konfirmasi muncul
4. Tap **"Hapus"** untuk konfirmasi

**Cara 2 — Dari Halaman Detail:**
1. Tap item transaksi untuk buka detail
2. Tap ikon 🗑️ **Hapus** di pojok kanan atas
3. Dialog konfirmasi: *"Yakin ingin menghapus transaksi ini?"*
4. Tap **"Hapus"** → transaksi dihapus permanen

```
⚠️  Konfirmasi Hapus
─────────────────────────────
Transaksi ini akan dihapus
secara permanen dan tidak
dapat dikembalikan.

Makan siang di warung
Rp 50.000 · 05/03/2026

[ Batal ]        [ 🗑️ Hapus ]
```

> ⚠️ **Perhatian**: Hapus bersifat **permanen**. Gunakan fitur **Export Backup** secara rutin untuk menghindari kehilangan data.

### Logika Update Saldo Otomatis

```
Setelah Edit atau Hapus:
  Saldo = Total Pemasukan - Total Pengeluaran (dihitung ulang)
  Dashboard diperbarui real-time
  Tidak perlu refresh manual
```

### Melihat Ringkasan

- Halaman **Dashboard** menampilkan:
  - Total saldo (pemasukan - pengeluaran)
  - Total pemasukan periode aktif
  - Total pengeluaran periode aktif
  - Daftar transaksi terbaru

---

## 🔍 Filter & Pencarian

Akses menu **Filter** dari halaman Riwayat Transaksi:

```
Filter Tersedia:
├── 📅 Filter Tanggal   → Tampilkan transaksi pada tanggal tertentu
│                          Contoh: 05 Maret 2026
│
├── 🗓️ Filter Bulan    → Tampilkan semua transaksi dalam 1 bulan
│                          Contoh: Maret 2026
│
├── 📆 Filter Tahun     → Tampilkan semua transaksi dalam 1 tahun
│                          Contoh: 2026
│
└── 📂 Filter Kategori  → Tampilkan berdasarkan kategori tertentu
                           Contoh: hanya 'Makan'
```

Filter dapat **dikombinasikan**, misalnya: Bulan Maret + Kategori Makan.

---

## 💾 Fitur Backup & Restore

### Export (Backup ke JSON)

1. Buka menu **Pengaturan** atau halaman **Riwayat**
2. Tap **"Export Backup"**
3. File `fintrack_backup_YYYYMMDD.json` akan dibuat
4. Pilih lokasi simpan atau bagikan via aplikasi lain (WhatsApp, Google Drive, Email, dll.)

```
📁 Nama file otomatis:
   fintrack_backup_20260308.json
```

### Import (Restore dari JSON)

1. Buka menu **Pengaturan**
2. Tap **"Import Backup"**
3. Pilih file `.json` dari penyimpanan perangkat
4. Konfirmasi: **Gabungkan** data baru dengan yang ada, atau **Ganti** semua data
5. Data berhasil di-restore ✅

> ⚠️ **Perhatian**: Pilih opsi **"Ganti"** hanya jika Anda ingin menghapus seluruh data yang ada dan menggantinya dengan data dari backup.

---

## 📁 Struktur Proyek

```
fintrack/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── transaksi.dart          # Model data transaksi
│   │   └── kategori.dart           # Model data kategori
│   ├── screens/
│   │   ├── dashboard_screen.dart        # Halaman utama / ringkasan
│   │   ├── transaksi_screen.dart        # Form tambah transaksi baru
│   │   ├── edit_transaksi_screen.dart   # Form edit transaksi yang ada
│   │   ├── detail_transaksi_screen.dart # Detail + tombol edit & hapus
│   │   ├── riwayat_screen.dart          # Daftar & filter transaksi
│   │   └── pengaturan_screen.dart       # Export, import, kelola kategori
│   ├── providers/
│   │   └── transaksi_provider.dart # State management
│   ├── services/
│   │   ├── storage_service.dart    # CRUD ke shared_preferences
│   │   └── backup_service.dart     # Export & import JSON
│   ├── widgets/
│   │   ├── transaksi_card.dart     # Kartu item transaksi
│   │   ├── filter_widget.dart      # Widget filter tanggal/bulan/tahun
│   │   └── ringkasan_card.dart     # Kartu ringkasan saldo
│   └── utils/
│       ├── currency_formatter.dart # Format Rupiah
│       └── date_helper.dart        # Helper format tanggal
├── android/
├── ios/
├── test/
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

---

## 🗺️ Roadmap

- [x] Pencatatan pemasukan & pengeluaran
- [x] Edit transaksi (ubah jenis, kategori, tanggal, keterangan, jumlah)
- [x] Hapus transaksi dengan konfirmasi
- [x] Kategori transaksi
- [x] Filter tanggal, bulan, tahun
- [x] Export & import backup JSON
- [ ] Grafik pengeluaran per kategori (pie chart)
- [ ] Notifikasi pengingat pencatatan harian
- [ ] Multiple akun/dompet
- [ ] Pencatatan dalam mata uang asing
- [ ] Export ke format CSV / Excel
- [ ] Widget home screen (Android)
- [ ] Dark mode

---

## 🤝 Kontribusi

Kontribusi sangat terbuka! Berikut cara berkontribusi:

```bash
# 1. Fork repositori ini
# 2. Buat branch fitur baru
git checkout -b fitur/nama-fitur-baru

# 3. Commit perubahan
git commit -m "feat: tambah fitur nama-fitur-baru"

# 4. Push ke branch
git push origin fitur/nama-fitur-baru

# 5. Buat Pull Request
```

### Konvensi Commit

```
feat:     Fitur baru
fix:      Perbaikan bug
docs:     Perubahan dokumentasi
style:    Perubahan format/style kode
refactor: Refaktor kode
test:     Tambah atau perbaiki test
```

---

## 📄 Lisensi

```
MIT License

Copyright (c) 2026 FinTrack

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

Lihat file [LICENSE](LICENSE) untuk detail lengkap.

---

<p align="center">
  Dibuat dengan ❤️ menggunakan Flutter
  <br/>
  <sub>Semua data Anda tersimpan aman di perangkat Anda sendiri 🔒</sub>
</p>
