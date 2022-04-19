import 'dart:convert';

import 'package:positioning/data/model/user.dart';
import 'package:positioning/helpers/exception/memory_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocal {
  late SharedPreferences _preferences;

  UserLocal(SharedPreferences preferences) {
    _preferences = preferences;
  }

  Future<bool> save(Map<String, dynamic> body) async {
    try {
     return _preferences.setString('user', jsonEncode(body));
    } catch (error) {
      rethrow;
    }
  }

  Future<User> get() async {
    try {
     return User.fromJson(jsonDecode(_preferences.getString('user') ?? ''));
    } catch (error) {
      throw MemoryException('User not found');
    }
  }
}
