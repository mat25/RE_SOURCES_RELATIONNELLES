import '../core/api/api_client.dart';
import '../models/login_response.dart';
import '../models/user.dart';

class UserRepository {
  final ApiClient _client;

  UserRepository(this._client);

  Future<User> getCurrentUser(String token) async {
    final response = await _client.get('/users/me', token: token);
    return User.fromJson(response.data);
  }

  Future<User> updateUser(String token, Map<String, dynamic> updatedData) async {
    final response = await _client.patch('/users/me', updatedData, token: token);

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Erreur lors de la mise à jour : ${response.data['message']}');
    }
  }

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _client.post('/register', {
      "name": lastName,
      "firstName": firstName,
      "username": username,
      "email": email,
      "password": password,
    });

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception(response.data['message']);
    }
  }

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _client.post('/login', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200 &&
        response.data['token'] != null &&
        response.data['id'] != null) {
      return LoginResponse.fromJson(response.data);
    } else {
      throw Exception('Échec de la connexion');
    }
  }

  Future<String> deleteUser(String token) async {
    final response = await _client.delete('/users/me', token: token);

    if (response.statusCode == 200 && response.data['message'] != null) {
      return response.data['message'];
    } else {
      throw Exception("Erreur lors de la suppression du compte");
    }
  }

}
