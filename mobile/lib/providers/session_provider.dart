import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../core/api/api_client.dart';

class SessionProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository(ApiClient());

  User? _user;
  String? _token;

  String? username;
  String? password;

  String? _loginMessage;
  String? get loginMessage => _loginMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _user != null;

  int _currentIndex = 2;
  int get currentIndex => _currentIndex;

  void goToTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> checkSession() async {
    if (_token != null) {
      await loadCurrentUser();
    }
  }

  Future<void> login() async {
    if (username == null || username!.trim().isEmpty ||
        password == null || password!.trim().isEmpty) {
      _loginMessage = "Veuillez remplir tous les champs.";
      notifyListeners();
      return;
    }

    try {
      final token = await _userRepository.login(
        username: username!,
        password: password!,
      );

      _token = token as String;
      await loadCurrentUser();

      _loginMessage = "Connexion réussie !";
      notifyListeners();

      Future.delayed(const Duration(seconds: 3), () {
        clearLoginMessage();
      });

    } catch (e) {
      debugPrint('Erreur de connexion : $e');
      _loginMessage = "Identifiants incorrects";
      notifyListeners();
    }
  }

  Future<void> loadCurrentUser() async {
    if (_token == null) return;

    try {
      _user = await _userRepository.getCurrentUser(_token!);
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'utilisateur : $e');
    }
  }

  Future<void> updateProfileField(String field, String newValue) async {
    if (_token == null) return;

    try {
      final updatedUser = await _userRepository.updateUser(_token!, {field: newValue});
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur mise à jour profil : $e');
    }
  }

  void clearLoginMessage() {
    _loginMessage = null;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _token = null;
    username = null;
    password = null;
    notifyListeners();
  }

}
