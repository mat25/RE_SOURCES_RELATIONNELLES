import '../core/api/api_client.dart';
import '../models/user.dart';

class UserRepository {
  final ApiClient _client;

  UserRepository(this._client);

  Future<User> getUser(int id) async {
    final response = await _client.get('/users/$id');
    return User.fromJson(response.data);
  }

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String pseudo,
    required String email,
    required String password,
  }) async {
    final response = await _client.post('/register', {
      "name": lastName,
      "firstName": firstName,
      "pseudo": pseudo,
      "email": email,
      "password": password,
    });

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erreur lors de l’inscription');
    }
  }


}
