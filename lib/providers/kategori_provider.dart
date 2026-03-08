import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/kategori.dart';
import '../utils/app_theme.dart';

class KategoriProvider with ChangeNotifier {
  List<Kategori> _daftarKategori = [];
  bool _isLoading = true;

  List<Kategori> get daftarKategori => _daftarKategori;
  bool get isLoading => _isLoading;

  KategoriProvider() {
    muatData();
  }

  static const String _storageKey = 'categories_list';

  Future<void> muatData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final List decoded = jsonDecode(data);
      _daftarKategori = decoded.map((e) => Kategori.fromJson(e)).toList();
    } else {
      // Default Categories
      _daftarKategori = [
        _createDefault('Gaji', Icons.payments_outlined, 'pemasukan', AppTheme.primaryColor.value),
        _createDefault('Makan & Minum', Icons.restaurant_outlined, 'pengeluaran', Colors.orange.value),
        _createDefault('Transportasi', Icons.commute_outlined, 'pengeluaran', Colors.blue.value),
        _createDefault('Belanja', Icons.shopping_bag_outlined, 'pengeluaran', Colors.purple.value),
        _createDefault('Hiburan', Icons.sports_esports_outlined, 'pengeluaran', Colors.pink.value),
        _createDefault('Kesehatan', Icons.medical_services_outlined, 'pengeluaran', Colors.red.value),
        _createDefault('Pajak', Icons.receipt_long_outlined, 'pengeluaran', Colors.brown.value),
        _createDefault('Lain-lain', Icons.category_outlined, 'pengeluaran', Colors.grey.value),
      ];
      _saveData();
    }

    _isLoading = false;
    notifyListeners();
  }

  Kategori _createDefault(String nama, IconData icon, String jenis, int color) {
    return Kategori(
      id: const Uuid().v4(),
      nama: nama,
      iconCode: icon.codePoint,
      iconFontFamily: icon.fontFamily,
      iconFontPackage: icon.fontPackage,
      jenis: jenis,
      colorValue: color,
    );
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_daftarKategori.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, data);
  }

  Future<void> tambahKategori(Kategori kategori) async {
    _daftarKategori.add(kategori);
    notifyListeners();
    await _saveData();
  }

  Future<void> hapusKategori(String id) async {
    final index = _daftarKategori.indexWhere((item) => item.id == id);
    if (index != -1) {
      final name = _daftarKategori[index].nama;
      // Protect 'Lain-lain' category
      if (name.toLowerCase() == 'lain-lain') return;

      _daftarKategori.removeAt(index);
      notifyListeners();
      await _saveData();
    }
  }

  Future<void> editKategori(Kategori updated) async {
    final index = _daftarKategori.indexWhere((item) => item.id == updated.id);
    if (index != -1) {
      _daftarKategori[index] = updated;
      notifyListeners();
      await _saveData();
    }
  }

  List<Kategori> filterByJenis(String jenis) {
    return _daftarKategori.where((element) => element.jenis == jenis).toList();
  }
}
