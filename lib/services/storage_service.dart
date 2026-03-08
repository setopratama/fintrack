import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaksi.dart';

class StorageService {
  static const String _storageKey = 'fintrack_transactions';

  // Save all transactions
  static Future<void> simpanSemua(List<Transaksi> daftarTransaksi) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dataJson = daftarTransaksi
        .map((t) => jsonEncode(t.toMap()))
        .toList();
    await prefs.setStringList(_storageKey, dataJson);
  }

  // Get all transactions
  static Future<List<Transaksi>> ambilSemua() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? dataJson = prefs.getStringList(_storageKey);
    
    if (dataJson == null) return [];

    return dataJson
        .map((item) => Transaksi.fromMap(jsonDecode(item)))
        .toList();
  }

  // Create (Add single)
  static Future<void> tambah(Transaksi transaksi) async {
    final daftar = await ambilSemua();
    daftar.add(transaksi);
    await simpanSemua(daftar);
  }

  // Update (Edit single)
  static Future<void> perbarui(Transaksi transaksi) async {
    final daftar = await ambilSemua();
    final index = daftar.indexWhere((t) => t.id == transaksi.id);
    if (index != -1) {
      daftar[index] = transaksi;
      await simpanSemua(daftar);
    }
  }

  // Delete (Remove single)
  static Future<void> hapus(String id) async {
    final daftar = await ambilSemua();
    daftar.removeWhere((t) => t.id == id);
    await simpanSemua(daftar);
  }

  // Clear all data (optional)
  static Future<void> hapusSemua() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
