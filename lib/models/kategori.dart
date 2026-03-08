import 'package:flutter/material.dart';

class Kategori {
  final String id;
  final String nama;
  final IconData icon;
  final Color warna;
  final bool isPengeluaran;

  Kategori({
    required this.id,
    required this.nama,
    required this.icon,
    required this.warna,
    required this.isPengeluaran,
  });
}
