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
  String _selectedMonth = 'Semua';
  String _searchQuery = '';
  bool _isSearching = false;
  final List<String> _types = ['Semua', 'Pemasukan', 'Pengeluaran'];
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
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.edit_outlined, color: Colors.blue),
              ),
              title: const Text('Edit Transaksi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransaksiScreen(transaksi: t)));
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.delete_outline, color: Colors.red),
              ),
              title: const Text('Hapus Transaksi',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
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

  void _confirmDelete(
      BuildContext context, TransaksiProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi?'),
        content: const Text('Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
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
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Cari transaksi...',
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : const Text('Riwayat Transaksi'),
        centerTitle: !_isSearching,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Consumer2<TransaksiProvider, KategoriProvider>(
        builder: (context, provider, kategoriProvider, child) {
          final allDocs = provider.daftarTransaksi;

          // Get available months for dropdown
          final monthDates = allDocs
              .map((t) => DateTime(t.tanggal.year, t.tanggal.month))
              .toSet()
              .toList();
          monthDates.sort((a, b) => b.compareTo(a));
          final monthOptions = ['Semua'] +
              monthDates.map((d) => DateFormat('MMMM yyyy').format(d)).toList();

          // Apply filter
          final filteredDocs = allDocs.where((t) {
            // Type Filter
            bool typeMatch = _selectedType == 'Semua' ||
                t.jenis.toLowerCase() == _selectedType.toLowerCase();

            // Search Filter
            bool searchMatch = _searchQuery.isEmpty ||
                t.keterangan
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                t.kategori.toLowerCase().contains(_searchQuery.toLowerCase());

            // Month Filter
            bool monthMatch = _selectedMonth == 'Semua' ||
                DateFormat('MMMM yyyy').format(t.tanggal) == _selectedMonth;

            return typeMatch && searchMatch && monthMatch;
          }).toList();

          // Performance optimization: Group by day
          final Map<String, List<Transaksi>> grouped = {};
          for (var t in filteredDocs) {
            final dayKey = DateFormat('EEEE, dd MMM yyyy').format(t.tanggal);
            if (!grouped.containsKey(dayKey)) grouped[dayKey] = [];
            grouped[dayKey]!.add(t);
          }
          final sortedDays = grouped.keys.toList();

          return Column(
            children: [
              // Filter Toolbar
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Month Dropdown
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedMonth != 'Semua'
                                ? AppTheme.primaryColor
                                : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedMonth,
                            items: monthOptions
                                .map((m) => DropdownMenuItem(
                                      value: m,
                                      child: Text(m,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _selectedMonth == m
                                                ? AppTheme.primaryColor
                                                : Colors.grey,
                                            fontWeight: _selectedMonth == m
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          )),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedMonth = val);
                              }
                            },
                            icon: Icon(Icons.keyboard_arrow_down,
                                size: 18,
                                color: _selectedMonth != 'Semua'
                                    ? AppTheme.primaryColor
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // Type Chips
                    ..._types.map((filter) {
                      final isSelected = _selectedType == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Center(
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (val) {
                              setState(() => _selectedType = filter);
                            },
                            selectedColor:
                                AppTheme.primaryColor.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            Text(
                              'Hasil tidak ditemukan',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sortedDays.length,
                        itemBuilder: (context, dayIndex) {
                          final day = sortedDays[dayIndex];
                          final dayTransactions = grouped[day]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 12, top: 8),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ...dayTransactions.map((t) {
                                final catData = kategoriProvider.daftarKategori
                                    .firstWhere(
                                  (c) => c.nama == t.kategori,
                                  orElse: () => Kategori(
                                      id: '',
                                      nama: t.kategori,
                                      iconCode: Icons.category.codePoint,
                                      jenis: t.jenis,
                                      colorValue: Colors.grey.value),
                                );

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: TransaksiCard(
                                    category: t.kategori,
                                    dateDesc:
                                        '${t.keterangan}${t.keterangan.isNotEmpty ? ' • ' : ''}${DateFormat('HH:mm').format(t.tanggal)}',
                                    amount: NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: '',
                                            decimalDigits: 2)
                                        .format(t.jumlah)
                                        .trim(),
                                    icon: catData.iconData,
                                    iconColor: Color(catData.colorValue),
                                    isIncome: t.jenis == 'pemasukan',
                                    onTap: () => _showOptions(context, t),
                                    imagePath: catData.imagePath,
                                  ),
                                );
                              }),
                              const SizedBox(height: 16), // Jarak antar hari
                            ],
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
