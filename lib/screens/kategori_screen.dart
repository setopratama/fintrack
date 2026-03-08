import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/app_theme.dart';
import '../providers/kategori_provider.dart';
import '../providers/transaksi_provider.dart';
import '../models/kategori.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final List<IconData> _availableIcons = [
    Icons.payments_outlined,
    Icons.restaurant_outlined,
    Icons.commute_outlined,
    Icons.shopping_bag_outlined,
    Icons.sports_esports_outlined,
    Icons.medical_services_outlined,
    Icons.receipt_long_outlined,
    Icons.category_outlined,
    Icons.home_outlined,
    Icons.school_outlined,
    Icons.directions_car_outlined,
    Icons.movie_outlined,
    Icons.coffee_outlined,
    Icons.fastfood_outlined,
    Icons.shopping_cart_outlined,
    Icons.work_outline,
    Icons.security_outlined,
    Icons.star_outline,
    Icons.favorite_outline,
    Icons.lightbulb_outline,
    Icons.fitness_center,
    Icons.pets,
    Icons.flight,
    Icons.card_giftcard,
  ];

  final List<Color> _availableColors = [
    AppTheme.primaryColor,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.brown,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.lime,
  ];

  void _showAddEditDialog({Kategori? kategori}) {
    final isEditing = kategori != null;
    final nameController = TextEditingController(text: isEditing ? kategori.nama : '');
    String selectedType = isEditing ? kategori.jenis : 'pengeluaran';
    IconData selectedIcon = isEditing 
        ? IconData(kategori.iconCode, fontFamily: kategori.iconFontFamily, fontPackage: kategori.iconFontPackage)
        : Icons.category_outlined;
    Color selectedColor = isEditing ? Color(kategori.colorValue) : AppTheme.primaryColor;
    String? pickedImagePath = isEditing ? kategori.imagePath : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isEditing ? 'Edit Kategori' : 'Tambah Kategori Baru',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // Name Input
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Kategori',
                    hintText: 'Misal: Makan Makan',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Type Picker
                const Text('Jenis Transaksi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Pemasukan')),
                        selected: selectedType == 'pemasukan',
                        onSelected: (val) => setModalState(() => selectedType = 'pemasukan'),
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: selectedType == 'pemasukan' ? AppTheme.primaryColor : Colors.grey,
                          fontWeight: selectedType == 'pemasukan' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Pengeluaran')),
                        selected: selectedType == 'pengeluaran',
                        onSelected: (val) => setModalState(() => selectedType = 'pengeluaran'),
                        selectedColor: Colors.red.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: selectedType == 'pengeluaran' ? Colors.red : Colors.grey,
                          fontWeight: selectedType == 'pengeluaran' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Icon & Image Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pilih Ikon atau Foto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                    TextButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                        if (result != null) {
                          setModalState(() => pickedImagePath = result.files.single.path);
                        }
                      },
                      icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                      label: const Text('Gunakan Foto', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Display Current Selection
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: selectedColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: selectedColor, width: 2),
                      image: pickedImagePath != null 
                        ? DecorationImage(image: FileImage(File(pickedImagePath!)), fit: BoxFit.cover)
                        : null,
                    ),
                    child: pickedImagePath == null 
                      ? Icon(selectedIcon, color: selectedColor, size: 40)
                      : null,
                  ),
                ),
                if (pickedImagePath != null) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => setModalState(() => pickedImagePath = null),
                      child: const Text('Hapus Foto', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Icons Grid
                const Text('Pilih Ikon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _availableIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _availableIcons[index];
                      return InkWell(
                        onTap: () => setModalState(() {
                          selectedIcon = icon;
                          pickedImagePath = null;
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIcon == icon && pickedImagePath == null ? selectedColor.withOpacity(0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selectedIcon == icon && pickedImagePath == null ? selectedColor : Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(icon, color: selectedIcon == icon && pickedImagePath == null ? selectedColor : Colors.grey, size: 20),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Colors Grid
                const Text('Pilih Warna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _availableColors.length,
                    itemBuilder: (context, index) {
                      final color = _availableColors[index];
                      return InkWell(
                        onTap: () => setModalState(() => selectedColor = color),
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color ? Colors.white : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: selectedColor == color ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 4)] : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama kategori tidak boleh kosong')));
                        return;
                      }

                      final provider = Provider.of<KategoriProvider>(context, listen: false);
                      final newCat = Kategori(
                        id: isEditing ? kategori.id : const Uuid().v4(),
                        nama: nameController.text.trim(),
                        iconCode: selectedIcon.codePoint,
                        iconFontFamily: selectedIcon.fontFamily,
                        iconFontPackage: selectedIcon.fontPackage,
                        jenis: selectedType,
                        colorValue: selectedColor.value,
                        imagePath: pickedImagePath,
                      );

                      if (isEditing) {
                        provider.editKategori(newCat);
                      } else {
                        provider.tambahKategori(newCat);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(isEditing ? 'Simpan Perubahan' : 'Tambah Kategori', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                if (isEditing && kategori.nama.toLowerCase() != 'lain-lain') ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        final tp = Provider.of<TransaksiProvider>(context, listen: false);
                        tp.gantiKategori(kategori.nama, 'Lain-lain');
                        Provider.of<KategoriProvider>(context, listen: false).hapusKategori(kategori.id);
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus Kategori', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAddEditDialog(), 
            icon: const Icon(Icons.add, color: AppTheme.primaryColor)
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<KategoriProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = provider.daftarKategori;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Kelola kategori untuk memudahkan pencatatan transaksi Anda.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final cat = list[index];
                      return _buildCategoryCard(cat, isDark);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(Kategori kategori, bool isDark) {
    final color = kategori.color;
    final hasImage = kategori.imagePath != null && kategori.imagePath!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAddEditDialog(kategori: kategori),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    image: hasImage 
                      ? DecorationImage(image: FileImage(File(kategori.imagePath!)), fit: BoxFit.cover)
                      : null,
                  ),
                  child: !hasImage 
                    ? Icon(kategori.iconData, color: color, size: 28)
                    : null,
                ),
                const SizedBox(height: 12),
                Text(
                  kategori.nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kategori.jenis[0].toUpperCase() + kategori.jenis.substring(1),
                  style: TextStyle(
                    fontSize: 10,
                    color: kategori.jenis == 'pemasukan' ? AppTheme.primaryColor : AppTheme.expenseColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
