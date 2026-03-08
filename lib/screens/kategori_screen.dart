import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final List<Map<String, dynamic>> _kategoriList = [
    {'nama': 'Gaji', 'icon': Icons.payments_outlined, 'color': AppTheme.primaryColor, 'type': 'pemasukan'},
    {'nama': 'Makan & Minum', 'icon': Icons.restaurant_outlined, 'color': Colors.orange, 'type': 'pengeluaran'},
    {'nama': 'Transportasi', 'icon': Icons.commute_outlined, 'color': Colors.blue, 'type': 'pengeluaran'},
    {'nama': 'Belanja', 'icon': Icons.shopping_bag_outlined, 'color': Colors.purple, 'type': 'pengeluaran'},
    {'nama': 'Hiburan', 'icon': Icons.sports_esports_outlined, 'color': Colors.pink, 'type': 'pengeluaran'},
    {'nama': 'Kesehatan', 'icon': Icons.medical_services_outlined, 'color': Colors.red, 'type': 'pengeluaran'},
    {'nama': 'Pajak', 'icon': Icons.receipt_long_outlined, 'color': Colors.brown, 'type': 'pengeluaran'},
    {'nama': 'Lain-lain', 'icon': Icons.category_outlined, 'color': Colors.grey, 'type': 'pengeluaran'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: AppTheme.primaryColor)),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Pilih kategori untuk melihat statistik atau mengubahnya.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _kategoriList.length,
                itemBuilder: (context, index) {
                  final cat = _kategoriList[index];
                  return _buildCategoryCard(
                    cat['nama'], 
                    cat['icon'], 
                    cat['color'], 
                    cat['type'],
                    isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color, String type, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type[0].toUpperCase() + type.substring(1),
                  style: TextStyle(
                    fontSize: 10,
                    color: type == 'pemasukan' ? AppTheme.primaryColor : AppTheme.expenseColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
