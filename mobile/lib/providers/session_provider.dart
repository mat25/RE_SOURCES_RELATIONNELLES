import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_result.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../core/api/api_client.dart';

class SessionProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository(ApiClient());

  User? _user;
  String? _token;
  int? _userId;
  int _currentIndex = 2;
  bool _isLoading = false;

  String? _username;
  String? _password;

  // Getters
  User? get user => _user;
  String? get token => _token;
  int? get userId => _userId;
  int get currentIndex => _currentIndex;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  // Méthode appelée au démarrage de l'app
  Future<void> checkSession() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      if (_token != null) {
        await _loadCurrentUser();
      }
    } catch (e) {
      debugPrint('Erreur checkSession : $e');
    } finally {
      _setLoading(false);
    }
  }

  void goToTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void setCredentials(String username, String password) {
    _username = username.trim();
    _password = password.trim();
  }

  Future<LoginResult> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return LoginResult(message: "Veuillez remplir tous les champs.", isError: true);
    }

    try {
      final loginResponse = await _userRepository.login(
        username: username,
        password: password,
      );

      _token = loginResponse.token;
      _userId = loginResponse.userId;
      _username = username;
      _password = password;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      await _loadCurrentUser();
      notifyListeners();

      return LoginResult(message: "Connexion réussie !", isError: false);
    } catch (e) {
      debugPrint("Erreur login : $e");
      return LoginResult(message: "Identifiants incorrects ou erreur réseau.", isError: true);
    }
  }

  Future<void> _loadCurrentUser() async {
    if (_token == null) return;

    try {
      _user = await _userRepository.getCurrentUser(_token!);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur récupération utilisateur : $e");
      await logout();
    }
  }

  Future<bool> updateProfileField(String field, String newValue) async {
    if (_token == null || _user == null) return false;

    try {
      final updatedUser = await _userRepository.updateUser(_token!, {field: newValue});
      _user = updatedUser;

      if (field == 'username' && _password != null) {
        _username = newValue;
        await login(_username!, _password!);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur MAJ profil : $e');
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _username = null;
    _password = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
  }

  Future<String> deleteAccount() async {
    if (_token == null) throw Exception("Token manquant");
    final message = await _userRepository.deleteUser(_token!);
    await logout();
    return message;
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      Future.microtask(() => notifyListeners());
    }
  }
}
