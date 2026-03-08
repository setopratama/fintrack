import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Pengguna';
  String _email = 'email@email.com';
  String? _photoPath;
  DateTime _createdAt = DateTime.now();
  bool _isLoaded = false;
  bool _isFirstTime = true;
  
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _photoPathKey = 'user_photo_path';
  static const String _createdAtKey = 'user_created_at';

  UserProvider() {
    _loadUserData();
  }

  String get name => _name;
  String get email => _email;
  String? get photoPath => _photoPath;
  DateTime get createdAt => _createdAt;
  bool get isLoaded => _isLoaded;
  bool get isFirstTime => _isFirstTime;

  Future<void> updateName(String newName) async {
    _name = newName;
    _isFirstTime = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, newName);
  }

  Future<void> updateEmail(String newEmail) async {
    _email = newEmail.isEmpty ? 'email@email.com' : newEmail;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, _email);
  }

  Future<void> updatePhoto(String? path) async {
    _photoPath = path;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString(_photoPathKey, path);
    } else {
      await prefs.remove(_photoPathKey);
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_createdAtKey)) {
      _createdAt = DateTime.parse(prefs.getString(_createdAtKey)!);
    } else {
      _createdAt = DateTime.now();
      await prefs.setString(_createdAtKey, _createdAt.toIso8601String());
    }

    if (prefs.containsKey(_nameKey)) {
      _name = prefs.getString(_nameKey)!;
      _isFirstTime = false;
    }
    _email = prefs.getString(_emailKey) ?? 'email@email.com';
    _photoPath = prefs.getString(_photoPathKey);
    _isLoaded = true;
    notifyListeners();
  }
}
