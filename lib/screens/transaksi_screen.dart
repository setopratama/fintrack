import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../providers/transaksi_provider.dart';
import '../models/transaksi.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;

    // Remove all non-numeric characters (including existing dots)
    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) return newValue.copyWith(text: '');

    double value = double.parse(cleanText);
    final formatter = NumberFormat.decimalPattern('id_ID');
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class TransaksiScreen extends StatefulWidget {
  final Transaksi? transaksi;
  const TransaksiScreen({super.key, this.transaksi});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  late String _transactionType;
  String? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late DateTime _selectedDate;

  bool get _isEditing => widget.transaksi != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _transactionType = widget.transaksi!.jenis;
      _selectedCategory = widget.transaksi!.kategori;
      // Format initial amount with thousands separator
      final formatter = NumberFormat.decimalPattern('id_ID');
      _amountController.text = formatter.format(widget.transaksi!.jumlah);
      _noteController.text = widget.transaksi!.keterangan;
      _selectedDate = widget.transaksi!.tanggal;
    } else {
      _transactionType = 'pengeluaran';
      _selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(_isEditing ? 'Edit Transaksi' : 'Tambah Transaksi'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Type Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTypeToggleItem(
                      label: 'Pemasukan',
                      isActive: _transactionType == 'pemasukan',
                      activeColor: AppTheme.primaryColor,
                      onTap: () => setState(() => _transactionType = 'pemasukan'),
                    ),
                  ),
                  Expanded(
                    child: _buildTypeToggleItem(
                      label: 'Pengeluaran',
                      isActive: _transactionType == 'pengeluaran',
                      activeColor: AppTheme.expenseColor,
                      onTap: () => setState(() => _transactionType = 'pengeluaran'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Amount Input
            const Text('Jumlah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Rp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: '0',
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              ),
            ),
            const SizedBox(height: 24),

            // Category Picker
            const Text('Kategori', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.category_outlined, color: AppTheme.primaryColor),
                hintText: 'Pilih Kategori',
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              ),
              items: ['Gaji', 'Makan & Minum', 'Transportasi', 'Belanja', 'Hiburan']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 24),

            // Date Picker
            const Text('Tanggal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context, initialDate: _selectedDate,
                  firstDate: DateTime(2020), lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notes
            const Text('Keterangan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan (opsional)',
                prefixIcon: const Column(children: [Padding(padding: EdgeInsets.only(top: 16.0), child: Icon(Icons.description_outlined, color: AppTheme.primaryColor))]),
                fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
        ),
        child: Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Batal'))),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(_isEditing ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mohon isi jumlah dan kategori')));
      return;
    }

    // Remove dots before parsing double
    final cleanAmountString = amountText.replaceAll('.', '');
    final amount = double.tryParse(cleanAmountString) ?? 0.0;
    if (amount <= 0) return;

    final provider = Provider.of<TransaksiProvider>(context, listen: false);

    if (_isEditing) {
      final updated = widget.transaksi!.copyWith(
        jenis: _transactionType,
        kategori: _selectedCategory!,
        jumlah: amount,
        keterangan: _noteController.text.trim(),
        tanggal: _selectedDate,
        updatedAt: DateTime.now(),
      );
      await provider.perbaruiTransaksi(updated);
    } else {
      await provider.tambahTransaksi(
        jenis: _transactionType,
        kategori: _selectedCategory!,
        jumlah: amount,
        keterangan: _noteController.text.trim(),
        tanggal: _selectedDate,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _buildTypeToggleItem({required String label, required bool isActive, required Color activeColor, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? (isDark ? const Color(0xFF334155) : Colors.white) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? activeColor : Colors.grey)),
      ),
    );
  }
}

