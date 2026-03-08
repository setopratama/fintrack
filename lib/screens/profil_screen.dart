import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/transaksi_provider.dart';
import 'faq_screen.dart';
import '../providers/kategori_provider.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer3<UserProvider, TransaksiProvider, KategoriProvider>(
        builder: (context, userProvider, transaksiProvider, kategoriProvider, child) {
          final hasPhoto = userProvider.photoPath != null &&
              userProvider.photoPath!.isNotEmpty;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Avatar & Name Section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.primaryColor, width: 3),
                              image: hasPhoto
                                  ? DecorationImage(
                                      image: FileImage(
                                          File(userProvider.photoPath!)),
                                      fit: BoxFit.cover)
                                  : const DecorationImage(
                                      image: NetworkImage(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDTYUxbu7jhnVQV4U-zLKLIfXeoj5q-yBltyUVrUbWly5hIvVU83D8JbFTRKYGmlbUj5vB1VKnu8_rdXLcT29JdjF_SwBAwcOjHkc0jR3ONU4I9eHrOsvVkdmsRM4qAXnUXCLSYK7pF0n5vEE2Cf0lqWcIMVQ4bb89eSKfXTxBCtx5PSJaVIGHS2dvHU3_n3enOZByeKXuBafhPBTwrs9XHI27ywaA4axee6TleB9tE3EZoGzBLR2DKHu4s2DExAyY2vU671HokYE9s'),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () => _pickImage(context, userProvider),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _editProfile(context, userProvider),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userProvider.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        userProvider.email,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Stats Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Transaksi',
                            transaksiProvider.totalTransaksiCount.toString()),
                        Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.withOpacity(0.2)),
                        _buildStatItem('Kategori',
                            kategoriProvider.daftarKategori.length.toString()),
                        Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.withOpacity(0.2)),
                        _buildStatItem('Member', 'Pro'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Settings List
                _buildSectionTitle('Pengaturan Aplikasi'),
                _buildMenuItem(
                  Icons.dark_mode_outlined,
                  'Mode Gelap',
                  Colors.purple,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) => themeProvider.toggleTheme(val),
                    activeThumbColor: AppTheme.primaryColor,
                  ),
                ),
                _buildMenuItem(Icons.person_outline, 'Edit Profil', Colors.blue,
                    onTap: () => _editProfile(context, userProvider)),
                _buildMenuItem(
                    Icons.notifications_none, 'Notifikasi', Colors.orange,
                    onTap: () => _showComingSoon(context)),
                _buildMenuItem(
                    Icons.security_outlined, 'Keamanan', Colors.green,
                    onTap: () => _showComingSoon(context)),

                const SizedBox(height: 24),

                _buildSectionTitle('Riwayat Pembaruan (Changelog)'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildChangelogItem(
                            '🕒 Detail Waktu (HH:mm) di Transaksi (2026-03-08)'),
                        _buildChangelogItem(
                            '👋 Sapaan Dinamis Berbasis Waktu (2026-03-08)'),
                        _buildChangelogItem(
                            '📅 Grouping Hari di Dashboard (2026-03-08)'),
                        _buildChangelogItem(
                            '📆 Batasan 30 Hari Terakhir di Home (2026-03-08)'),
                        _buildChangelogItem(
                            '🖼️ Logo Aplikasi di Onboarding (2026-03-08)'),
                        _buildChangelogItem(
                            '⚖️ Berkas LICENSI MIT Project (2026-03-08)'),
                        _buildChangelogItem(
                            '🖼️ Perbaikan Foto Kategori & Fallback (2026-03-08)'),
                        _buildChangelogItem(
                            '📅 Grouping & Filter Riwayat Baru (2026-03-08)'),
                        _buildChangelogItem(
                            '🗑️ Hilangkan Ikon Edit Nama (2026-03-08)'),
                        _buildChangelogItem(
                            '📊 Logika Hitung Kategori diperbarui (2026-03-08)'),
                        _buildChangelogItem(
                            '❓ Halaman FAQ / Bantuan Interaktif (2026-03-08)'),
                        _buildChangelogItem(
                            '👋 Deskripsi Onboarding Baru (2026-03-08)'),
                        _buildChangelogItem(
                            '📘 Integrasi FAQ_FINTRACK.md (2026-03-08)'),
                        _buildChangelogItem(
                            '⚙️ Halaman Pengaturan Baru (2026-03-08)'),
                        _buildChangelogItem(
                            '💳 Nomor Akun Dashboard (YYYY MMDD) (2026-03-08)'),
                        _buildChangelogItem(
                            '🌐 Atribusi Powered by SomaTechno (2026-03-08)'),
                        _buildChangelogItem(
                            '🛠️ Relokasi Menu Backup Data (2026-03-08)'),
                        _buildChangelogItem(
                            '🔍 Pencarian & Filter Riwayat (2026-03-08)'),
                        _buildChangelogItem(
                            '💾 Export & Import Data (Backup) (2026-03-08)'),
                        _buildChangelogItem(
                            '🔄 Filter Cerdas Jenis Transaksi (2026-03-08)'),
                        _buildChangelogItem(
                            '🌈 Ikon & Warna di Dropdown (2026-03-08)'),
                        _buildChangelogItem(
                            '🎨 Kelola Kategori (Ikon & Warna) (2026-03-08)'),
                        _buildChangelogItem(
                            '📸 Unggah Foto & Edit Nama Profil (2026-03-08)'),
                        _buildChangelogItem(
                            '🌗 Dukungan Full Mode Gelap (2026-03-08)'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _buildSectionTitle('Lainnya'),
                _buildMenuItem(
                    Icons.help_outline, 'FAQ / Bantuan', Colors.purple,
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqScreen()),
                  );
                }),
                _buildMenuItem(Icons.logout, 'Keluar', Colors.red,
                    isLast: true),

                const SizedBox(height: 48),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Powered by',
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.5), fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'www.somatechno.com',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'v1.0.0+1',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, UserProvider provider) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      provider.updatePhoto(result.files.single.path);
    }
  }

  void _editProfile(BuildContext context, UserProvider provider) {
    final nameController = TextEditingController(text: provider.name);
    final emailController = TextEditingController(text: provider.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'Masukkan nama',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'email@email.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                provider.updateName(nameController.text.trim());
                provider.updateEmail(emailController.text.trim());
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama tidak boleh kosong')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildChangelogItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              color: AppTheme.primaryColor, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color,
      {bool isLast = false, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                trailing ??
                    const Icon(Icons.chevron_right,
                        color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur Segera Hadir! 🏗️'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF059669), // Warna hijau emerald
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
