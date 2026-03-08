import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaksi.dart';
import '../services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupService {
  static const String _catStorageKey = 'categories_list';

  static Future<void> exportData() async {
    try {
      final transactions = await StorageService.ambilSemua();
      
      final prefs = await SharedPreferences.getInstance();
      final catData = prefs.getString(_catStorageKey);
      List categories = [];
      if (catData != null) {
        categories = jsonDecode(catData);
      }

      final Map<String, dynamic> backupData = {
        'version': '1.0.0',
        'export_date': DateTime.now().toIso8601String(),
        'transactions': transactions.map((t) => t.toMap()).toList(),
        'categories': categories,
      };

      final String jsonString = jsonEncode(backupData);
      
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/fintrack_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([XFile(file.path)], text: 'Backup Data FinTrack');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> importData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final Map<String, dynamic> backupData = jsonDecode(content);

        if (!backupData.containsKey('transactions') || !backupData.containsKey('categories')) {
          throw Exception('Format file backup tidak valid');
        }

        // Import Transactions
        final List transList = backupData['transactions'];
        final List<Transaksi> transactions = transList.map((e) => Transaksi.fromMap(e)).toList();
        await StorageService.simpanSemua(transactions);

        // Import Categories
        final List catList = backupData['categories'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_catStorageKey, jsonEncode(catList));

        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
