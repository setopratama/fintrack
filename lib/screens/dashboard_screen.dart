import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_theme.dart';
import '../widgets/ringkasan_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaksi_card.dart';
import '../providers/transaksi_provider.dart';
import 'transaksi_screen.dart';
import 'riwayat_screen.dart';
import 'profil_screen.dart';
import 'kategori_screen.dart';
import 'pengaturan_screen.dart';
import 'package:intl/intl.dart';
import '../providers/user_provider.dart';
import '../providers/kategori_provider.dart';
import '../models/kategori.dart';
import '../models/transaksi.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  void _navigateToRiwayat() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _navigateToProfil() {
    setState(() {
      _currentIndex = 3;
    });
  }

  final List<Widget> _pages = [
    const DashboardContent(),
    const RiwayatScreen(),
    const KategoriScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: 'Kategori'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final hasPhoto = userProvider.photoPath != null &&
                userProvider.photoPath!.isNotEmpty;
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final state = context
                        .findAncestorStateOfType<_DashboardScreenState>();
                    state?._navigateToProfil();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppTheme.primaryColor, width: 2),
                      image: hasPhoto
                          ? DecorationImage(
                              image: FileImage(File(userProvider.photoPath!)),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDTYUxbu7jhnVQV4U-zLKLIfXeoj5q-yBltyUVrUbWly5hIvVU83D8JbFTRKYGmlbUj5vB1VKnu8_rdXLcT29JdjF_SwBAwcOjHkc0jR3ONU4I9eHrOsvVkdmsRM4qAXnUXCLSYK7pF0n5vEE2Cf0lqWcIMVQ4bb89eSKfXTxBCtx5PSJaVIGHS2dvHU3_n3enOZByeKXuBafhPBTwrs9XHI27ywaA4axee6TleB9tE3EZoGzBLR2DKHu4s2DExAyY2vU671HokYE9s'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(() {
                      final hour = DateTime.now().hour;
                      if (hour < 11) {
                        return 'Selamat Pagi,';
                      } else if (hour < 15) {
                        return 'Selamat Siang,';
                      } else if (hour < 18) {
                        return 'Selamat Sore,';
                      } else {
                        return 'Selamat Malam,';
                      }
                    }(),
                        style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white60 : Colors.black54)),
                    Text(userProvider.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PengaturanScreen()),
                );
              },
              icon: const Icon(Icons.settings_outlined, size: 20)),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer3<TransaksiProvider, UserProvider, KategoriProvider>(
        builder: (context, provider, userProvider, kategoriProvider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final daftar = provider.daftarTransaksi;
          final accNumber =
              DateFormat('yyyy MMdd').format(userProvider.createdAt);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                RingkasanCard(
                  balance: provider.totalSaldo,
                  accountNumber: accNumber,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        label: 'INCOME',
                        amount: currencyFormat.format(provider.totalPemasukan),
                        icon: Icons.arrow_downward,
                        color: AppTheme.incomeColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SummaryCard(
                        label: 'EXPENSE',
                        amount:
                            currencyFormat.format(provider.totalPengeluaran),
                        icon: Icons.arrow_upward,
                        color: AppTheme.expenseColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Transactions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        // Navigate to Riwayat tab
                        final state = context
                            .findAncestorStateOfType<_DashboardScreenState>();
                        state?._navigateToRiwayat();
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (daftar.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text('Belum ada transaksi',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ...() {
                  // Filter 30 hari terakhir
                  final thirtyDaysAgo =
                      DateTime.now().subtract(const Duration(days: 30));
                  final recentList = daftar
                      .where((t) => t.tanggal.isAfter(thirtyDaysAgo))
                      .toList();

                  // Group by day
                  final Map<String, List<Transaksi>> grouped = {};
                  for (final Transaksi t in recentList) {
                    final dayKey =
                        DateFormat('EEEE, dd MMM yyyy').format(t.tanggal);
                    if (!grouped.containsKey(dayKey)) grouped[dayKey] = [];
                    grouped[dayKey]!.add(t);
                  }

                  final sortedDays = grouped.keys.toList();

                  return sortedDays.map((day) {
                    final List<Transaksi> dayTransactions = grouped[day]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, top: 8),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ...dayTransactions.map((Transaksi t) {
                          final catData = kategoriProvider.daftarKategori
                              .firstWhere((c) => c.nama == t.kategori,
                                  orElse: () => Kategori(
                                      id: '',
                                      nama: t.kategori,
                                      iconCode: Icons.category.codePoint,
                                      jenis: t.jenis,
                                      colorValue: Colors.grey.value));

                          return TransaksiCard(
                            category: t.kategori,
                            dateDesc:
                                '${t.keterangan}${t.keterangan.isNotEmpty ? ' • ' : ''}${DateFormat('HH:mm').format(t.tanggal)}',
                            amount: currencyFormat
                                .format(t.jumlah)
                                .replaceAll('Rp ', ''),
                            icon: catData.iconData,
                            iconColor: Color(catData.colorValue),
                            isIncome: t.jenis == 'pemasukan',
                            onTap: () => _showOptions(context, t),
                            imagePath: catData.imagePath,
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    );
                  });
                }(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TransaksiScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
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
}
