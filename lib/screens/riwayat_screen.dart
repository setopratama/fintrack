import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../providers/transaksi_provider.dart';
import '../widgets/transaksi_card.dart';

import 'transaksi_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Pemasukan', 'Pengeluaran'];

  void _showOptions(BuildContext context, dynamic t) {
    final provider = Provider.of<TransaksiProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.edit_outlined, color: Colors.blue),
              ),
              title: const Text('Edit Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransaksiScreen(transaksi: t)));
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.delete_outline, color: Colors.red),
              ),
              title: const Text('Hapus Transaksi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, provider, t.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TransaksiProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              provider.hapusTransaksi(id);
              Navigator.pop(context);
            }, 
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<TransaksiProvider>(
        builder: (context, provider, child) {
          final allDocs = provider.daftarTransaksi;
          
          // Apply filter
          final filteredDocs = allDocs.where((t) {
            if (_selectedFilter == 'Semua') return true;
            return t.jenis.toLowerCase() == _selectedFilter.toLowerCase();
          }).toList();

          return Column(
            children: [
              // Filter Chips
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() => _selectedFilter = filter);
                      },
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryColor : Colors.black.withOpacity(0.05),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Transaction List
              Expanded(
                child: filteredDocs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            const Text('Tidak ada riwayat transaksi', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final t = filteredDocs[index];
                          return TransaksiCard(
                            category: t.kategori,
                            dateDesc: '${t.keterangan} • ${DateFormat('dd MMM yyyy').format(t.tanggal)}',
                            amount: NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 2).format(t.jumlah).trim(),
                            icon: _getIconForCategory(t.kategori),
                            iconColor: _getColorForCategory(t.kategori),
                            isIncome: t.jenis == 'pemasukan',
                            onTap: () => _showOptions(context, t),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }


  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Gaji': return Icons.payments_outlined;
      case 'Makan & Minum': return Icons.restaurant_outlined;
      case 'Transportasi': return Icons.commute_outlined;
      case 'Belanja': return Icons.shopping_bag_outlined;
      case 'Hiburan': return Icons.sports_esports_outlined;
      default: return Icons.category_outlined;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Gaji': return AppTheme.primaryColor;
      case 'Makan & Minum': return Colors.orange;
      case 'Transportasi': return Colors.blue;
      case 'Belanja': return Colors.purple;
      case 'Hiburan': return Colors.pink;
      default: return Colors.grey;
    }
  }
}
