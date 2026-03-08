import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../providers/transaksi_provider.dart';
import '../providers/kategori_provider.dart';
import '../widgets/transaksi_card.dart';
import '../models/transaksi.dart';
import '../models/kategori.dart';
import 'transaksi_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _selectedType = 'Semua';
  String _searchQuery = '';
  DateTime? _selectedDate;
  final List<String> _filters = ['Semua', 'Pemasukan', 'Pengeluaran'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showOptions(BuildContext context, Transaksi t) {
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
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
        actions: [
          if (_selectedDate != null)
            IconButton(
              icon: const Icon(Icons.event_busy, color: Colors.red),
              onPressed: () => setState(() => _selectedDate = null),
              tooltip: 'Hapus filter tanggal',
            ),
          IconButton(
            icon: Icon(Icons.calendar_month, color: _selectedDate != null ? AppTheme.primaryColor : Colors.grey),
            onPressed: () => _selectDate(context),
            tooltip: 'Filter Tanggal',
          ),
        ],
      ),
      body: Consumer2<TransaksiProvider, KategoriProvider>(
        builder: (context, provider, kategoriProvider, child) {
          final allDocs = provider.daftarTransaksi;
          
          // Apply filter
          final filteredDocs = allDocs.where((t) {
            // Type Filter
            bool typeMatch = _selectedType == 'Semua' || t.jenis.toLowerCase() == _selectedType.toLowerCase();
            
            // Search Filter
            bool searchMatch = _searchQuery.isEmpty || t.keterangan.toLowerCase().contains(_searchQuery.toLowerCase()) || t.kategori.toLowerCase().contains(_searchQuery.toLowerCase());
            
            // Date Filter
            bool dateMatch = _selectedDate == null || 
              (t.tanggal.year == _selectedDate!.year && 
               t.tanggal.month == _selectedDate!.month && 
               t.tanggal.day == _selectedDate!.day);

            return typeMatch && searchMatch && dateMatch;
          }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Cari transaksi atau kategori...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ) 
                      : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  ),
                ),
              ),

              // Filter Chips
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedType == filter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() => _selectedType = filter);
                      },
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryColor : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_selectedDate != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.event, size: 14, color: AppTheme.primaryColor.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        'Tanggal: ${DateFormat('dd MMMM yyyy').format(_selectedDate!)}',
                        style: TextStyle(fontSize: 12, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

              // Transaction List
              Expanded(
                child: filteredDocs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty || _selectedDate != null
                                ? 'Hasil tidak ditemukan'
                                : 'Tidak ada riwayat transaksi',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final t = filteredDocs[index];
                          
                          // Find category data for icon & color
                          final catData = kategoriProvider.daftarKategori.firstWhere(
                            (c) => c.nama == t.kategori,
                            orElse: () => Kategori(
                              id: '', nama: t.kategori, iconCode: Icons.category.codePoint, 
                              jenis: t.jenis, colorValue: Colors.grey.value
                            ),
                          );

                          return TransaksiCard(
                            category: t.kategori,
                            dateDesc: '${t.keterangan}${t.keterangan.isNotEmpty ? ' • ' : ''}${DateFormat('dd MMM yyyy').format(t.tanggal)}',
                            amount: NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 2).format(t.jumlah).trim(),
                            icon: catData.iconData,
                            iconColor: Color(catData.colorValue),
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
}
