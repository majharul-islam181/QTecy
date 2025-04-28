import 'package:shared_preferences/shared_preferences.dart';
import '../../feature/auth/domain/entities/user.dart';
import 'dart:convert';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode({
      '_id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.mobile,
    });
    await prefs.setString(_userKey, userJson);
  }

  Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User(
        id: userMap['_id'],
        name: userMap['name'],
        email: userMap['email'],
        mobile: userMap['phone'],
        token: userMap['token'] ?? '', 
      );
    }
    return null;
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}