import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../core/api/api_client.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> loadUser(int id) async {
    final userRepository = UserRepository(ApiClient());
    _user = await userRepository.getUser(3);
    notifyListeners();
  }
}
