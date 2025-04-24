import '../core/api/api_client.dart';
import '../models/user.dart';

class UserRepository {
  final ApiClient _client;

  UserRepository(this._client);

  Future<User> getUser(int id) async {
    final response = await _client.get('/users/$id');
    print('reponse : ${response.data}');
    return User.fromJson(response.data);
  }
}
