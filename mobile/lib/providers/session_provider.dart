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
  bool _isLoginError = false;

  String? get loginMessage => _loginMessage;
  bool get isLoginError => _isLoginError;

  User? get user => _user;
  String? get token => _token;
  bool get isLoggedIn => _user != null;
  int? get userId => _user?.id; // <- ID exposé ici

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
      _isLoginError = true;
      notifyListeners();
      return;
    }

    try {
      final token = await _userRepository.login(
        username: username!,
        password: password!,
      );

      _token = token;
      await loadCurrentUser();

      _loginMessage = "Connexion réussie !";
      _isLoginError = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 3), () {
        clearLoginMessage();
      });

    } catch (e) {
      debugPrint('Erreur de connexion : $e');
      _loginMessage = "Identifiants incorrects";
      _isLoginError = true;
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

  Future<bool> updateProfileField(String field, String newValue) async {
    if (_token == null || _user == null) return false;

    try {
      final bool isUsernameChange = field == 'username';
      final oldUsername = _user!.username;

      final updatedUser = await _userRepository.updateUser(_token!, {field: newValue});
      _user = updatedUser;

      if (isUsernameChange && password != null) {
        username = newValue;
        await login();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur mise à jour profil : $e');
      return false;
    }
  }

  void clearLoginMessage() {
    _loginMessage = null;
    _isLoginError = false;
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
