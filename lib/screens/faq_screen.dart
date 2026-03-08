import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('FAQ / Bantuan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pertanyaan Sering Diajukan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Temukan jawaban cepat untuk pertanyaan umum mengenai FinTrack.',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(context, '💡 Pertanyaan Umum', [
              _buildFaqItem('Apa itu FinTrack?', 'FinTrack adalah aplikasi pencatatan keuangan pribadi yang ringan, cepat, dan 100% offline. Aplikasi ini memungkinkan Anda mencatat semua pemasukan dan pengeluaran tanpa terhubung ke internet.'),
              _buildFaqItem('Berapa biaya penggunaannya?', 'Gratis selamanya! FinTrack sepenuhnya gratis dan dikembangkan untuk membantu manajemen keuangan pribadi secara mandiri.'),
              _buildFaqItem('Perlu koneksi internet?', 'Tidak! FinTrack bekerja 100% offline. Data Anda tersimpan di memori internal perangkat Anda sendiri.'),
            ]),

            _buildSection(context, '🚀 Instalasi & Setup', [
              _buildFaqItem('Cara menginstal FinTrack?', '1. Download APK dari GitHub.\n2. Buka file APK dan izinkan instalasi.\n3. Luncurkan aplikasi dan mulai gunakan!'),
              _buildFaqItem('Harus membuat akun?', 'Tidak! FinTrack tidak memerlukan registrasi. Begitu instal, Anda bisa langsung mencatat.'),
            ]),

            _buildSection(context, '📖 Penggunaan Dasar', [
              _buildFaqItem('Di mana menu Pengaturan?', 'Menu Pengaturan dapat diakses melalui ikon gerigi (Settings) di pojok kanan atas halaman Dashboard.'),
              _buildFaqItem('Cara mengubah tema?', 'Buka halaman Profil, terdapat tombol switch Mode Gelap yang bisa Anda aktifkan sesuai selera.'),
            ]),

            _buildSection(context, '💳 Dashboard & Akun', [
              _buildFaqItem('Apa itu "MAIN ACCOUNT"?', '"MAIN ACCOUNT" adalah akun utama pencatatan Anda. Nomor di bawahnya adalah ID Akun unik berdasarkan tanggal instalasi.'),
              _buildFaqItem('Saldo otomatis dihitung?', 'Ya! Dashboard menampilkan Total Balance yang dihitung real-time dari Pemasukan dikurangi Pengeluaran.'),
            ]),

            _buildSection(context, '🔍 Filter & Pencarian', [
              _buildFaqItem('Cara mencari transaksi?', 'Buka halaman Riwayat, gunakan kotak Pencarian di bagian atas untuk menyaring daftar secara instan.'),
              _buildFaqItem('Bisa filter tanggal?', 'Bisa! Klik ikon Kalender di pojok kanan atas halaman Riwayat untuk memilih tanggal spesifik.'),
            ]),

            _buildSection(context, '💾 Backup & Restore', [
              _buildFaqItem('Di mana fitur Backup?', 'Fitur Backup kini berada di halaman Pengaturan (ikon gerigi di Dashboard).'),
              _buildFaqItem('Cara pindah HP?', '1. Export Data di HP lama.\n2. Kirim file ke HP baru.\n3. Import Data di HP baru melalui menu Pengaturan.'),
            ]),

            _buildSection(context, '🔒 Keamanan & Privasi', [
              _buildFaqItem('Di mana data saya disimpan?', 'Data disimpan di Local Storage perangkat Anda. Kami tidak menggunakan server cloud, data Anda 100% privat.'),
            ]),

            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Support by www.somatechno.com',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kontak: setopratama@gmail.com',
                    style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
