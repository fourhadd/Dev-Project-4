import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  @override
  Future<void> save({required String token, required User user}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(UserModel.fromEntity(user).toJson()));
  }

  @override
  Future<SessionData?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) return null;
    final user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>).toEntity();
    return SessionData(token: token, user: user);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
