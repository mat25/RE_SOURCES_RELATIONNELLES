import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../core/api/api_client.dart';

class SessionProvider with ChangeNotifier {
  User? _user;
  String? email;
  String? password;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> checkSession() async {
    if (_user == null) {
      // pas connecté
    }
  }

  Future<void> login() async {
    if (email == null || password == null) return;

    final userRepository = UserRepository(ApiClient());
    try {
      _user = await userRepository.getUser(3);
      notifyListeners();
    } catch (e) {
      print("Erreur de login : $e");
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
