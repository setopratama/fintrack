class Transaksi {
  final String id;
  final String jenis; // 'pemasukan' | 'pengeluaran'
  final String kategori;
  final DateTime tanggal;
  final String keterangan;
  final double jumlah;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Transaksi({
    required this.id,
    required this.jenis,
    required this.kategori,
    required this.tanggal,
    required this.keterangan,
    required this.jumlah,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert to Map for JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenis': jenis,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'keterangan': keterangan,
      'jumlah': jumlah,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // From Map for JSON
  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      jenis: map['jenis'],
      kategori: map['kategori'],
      tanggal: DateTime.parse(map['tanggal']),
      keterangan: map['keterangan'] ?? '',
      jumlah: map['jumlah']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // CopyWith Method
  Transaksi copyWith({
    String? id,
    String? jenis,
    String? kategori,
    DateTime? tanggal,
    String? keterangan,
    double? jumlah,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaksi(
      id: id ?? this.id,
      jenis: jenis ?? this.jenis,
      kategori: kategori ?? this.kategori,
      tanggal: tanggal ?? this.tanggal,
      keterangan: keterangan ?? this.keterangan,
      jumlah: jumlah ?? this.jumlah,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
