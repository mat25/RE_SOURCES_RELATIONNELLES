import '../core/api/api_client.dart';
import '../models/ressource.dart';

class RessourceRepository {
  final ApiClient _client;

  RessourceRepository(this._client);

  Future<List<Ressource>> getRessources() async {
    final response = await _client.get('/resources');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Ressource.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> createRessource({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final response = await _client.post('/resources', data, token: token);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Échec de la création');
    }
  }

}
