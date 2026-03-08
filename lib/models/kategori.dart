import 'package:flutter/material.dart';

class Kategori {
  final String id;
  final String nama;
  final int iconCode;
  final String? iconFontFamily;
  final String? iconFontPackage;
  final String jenis; // 'pemasukan' or 'pengeluaran'
  final int colorValue;
  final String? imagePath;

  Kategori({
    required this.id,
    required this.nama,
    required this.iconCode,
    this.iconFontFamily,
    this.iconFontPackage,
    required this.jenis,
    required this.colorValue,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'iconCode': iconCode,
    'iconFontFamily': iconFontFamily,
    'iconFontPackage': iconFontPackage,
    'jenis': jenis,
    'colorValue': colorValue,
    'imagePath': imagePath,
  };

  factory Kategori.fromJson(Map<String, dynamic> json) => Kategori(
    id: json['id'],
    nama: json['nama'],
    iconCode: json['iconCode'],
    iconFontFamily: json['iconFontFamily'],
    iconFontPackage: json['iconFontPackage'],
    jenis: json['jenis'],
    colorValue: json['colorValue'],
    imagePath: json['imagePath'],
  );

  IconData get iconData => IconData(
    iconCode,
    fontFamily: iconFontFamily,
    fontPackage: iconFontPackage,
  );

  Color get color => Color(colorValue);

  Kategori copyWith({
    String? nama,
    int? iconCode,
    String? iconFontFamily,
    String? iconFontPackage,
    String? jenis,
    int? colorValue,
    String? imagePath,
  }) {
    return Kategori(
      id: id,
      nama: nama ?? this.nama,
      iconCode: iconCode ?? this.iconCode,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      iconFontPackage: iconFontPackage ?? this.iconFontPackage,
      jenis: jenis ?? this.jenis,
      colorValue: colorValue ?? this.colorValue,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
