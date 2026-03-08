import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../services/backup_service.dart';
import '../providers/transaksi_provider.dart';
import '../providers/kategori_provider.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Data & Backup'),
            _buildMenuItem(
              Icons.cloud_upload_outlined, 
              'Export Data (JSON)', 
              Colors.teal, 
              onTap: () => _handleExport(context)
            ),
            _buildMenuItem(
              Icons.cloud_download_outlined, 
              'Import Data (JSON)', 
              Colors.indigo, 
              onTap: () => _handleImport(context)
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Lainnya'),
            _buildMenuItem(
              Icons.info_outline, 
              'Tentang Aplikasi', 
              Colors.blue, 
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'FinTrack',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.account_balance_wallet, color: AppTheme.primaryColor),
                  children: [
                    const Text('Aplikasi Pencatatan Keuangan Pribadi yang aman dan offline.'),
                  ],
                );
              }
            ),

            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Text(
                    'Powered by',
                    style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 10),
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
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, {VoidCallback? onTap}) {
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
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    try {
      await BackupService.exportData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diekspor! 📁')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal ekspor: $e')),
      );
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    try {
      final success = await BackupService.importData();
      if (success) {
        if (!context.mounted) return;
        Provider.of<TransaksiProvider>(context, listen: false).muatData();
        Provider.of<KategoriProvider>(context, listen: false).muatData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diimpor! ✅')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal impor: $e')),
      );
    }
  }
}
