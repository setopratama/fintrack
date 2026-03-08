import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaksi.dart';
import '../services/storage_service.dart';

class TransaksiProvider extends ChangeNotifier {
  List<Transaksi> _daftarTransaksi = [];
  bool _isLoading = true;

  List<Transaksi> get daftarTransaksi => _daftarTransaksi;
  bool get isLoading => _isLoading;

  // Constructor: Load data immediately
  TransaksiProvider() {
    muatData();
  }

  // Load from Storage
  Future<void> muatData() async {
    _isLoading = true;
    notifyListeners();
    
    _daftarTransaksi = await StorageService.ambilSemua();
    
    // Sort by newest date
    _daftarTransaksi.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    
    _isLoading = false;
    notifyListeners();
  }

  // Create
  Future<void> tambahTransaksi({
    required String jenis,
    required String kategori,
    required double jumlah,
    required String keterangan,
    required DateTime tanggal,
  }) async {
    final baru = Transaksi(
      id: const Uuid().v4(),
      jenis: jenis,
      kategori: kategori,
      jumlah: jumlah,
      keterangan: keterangan,
      tanggal: tanggal,
      createdAt: DateTime.now(),
    );

    await StorageService.tambah(baru);
    await muatData(); // Refresh list
  }

  // Update
  Future<void> perbaruiTransaksi(Transaksi transaksi) async {
    await StorageService.perbarui(transaksi);
    await muatData();
  }

  // Delete
  Future<void> hapusTransaksi(String id) async {
    await StorageService.hapus(id);
    await muatData();
  }

  // Summary Logic
  double get totalSaldo {
    return totalPemasukan - totalPengeluaran;
  }

  double get totalPemasukan {
    return _daftarTransaksi
        .where((t) => t.jenis == 'pemasukan')
        .fold(0, (sum, t) => sum + t.jumlah);
  }

  double get totalPengeluaran {
    return _daftarTransaksi
        .where((t) => t.jenis == 'pengeluaran')
        .fold(0, (sum, t) => sum + t.jumlah);
  }

  // Stats for Profile
  int get totalTransaksiCount => _daftarTransaksi.length;
  
  int get uniqueKategoriCount {
    final categories = _daftarTransaksi.map((t) => t.kategori).toSet();
    return categories.length;
  }
}
