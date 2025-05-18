import '../core/api/api_client.dart';
import '../models/resource.dart';

class ResourceRepository {
  final ApiClient _client;

  ResourceRepository(this._client);

  Future<List<Resource>> getResources() async {
    final response = await _client.get('/resources');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> toggleSetAside(int id, {String? token}) async {
    final response = await _client.post('/resources/$id/toggle-set-aside', {}, token: token);

    if (response.statusCode != 200) {
      throw Exception(response.data['message']);
    }
  }

  Future<void> toggleFavorite(int id, {String? token}) async {
    final response = await _client.post('/resources/$id/toggle-favorite', {}, token: token);

    if (response.statusCode != 200) {
      throw Exception('Échec du changement d’état "favori"');
    }
  }

  Future<void> toggleExploited(int id, {String? token}) async {
    final response = await _client.post('/resources/$id/toggle-exploited', {}, token: token);

    if (response.statusCode != 200) {
      throw Exception('Échec du changement d’état "exploité"');
    }
  }

  Future<void> createResource({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final response = await _client.post('/resources', data, token: token);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Échec de la création de la ressource');
    }
  }

  Future<List<Resource>> fetchFavorites({String? token}) async {
    final response = await _client.get('/resources/favorites', token: token);
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les favoris');
    }
  }

  Future<List<Resource>> fetchSetAside({String? token}) async {
    final response = await _client.get('/resources/set-aside', token: token);
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les ressources mises de côté');
    }
  }

  Future<List<Resource>> fetchExploited({String? token}) async {
    final response = await _client.get('/resources/exploited', token: token);
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Resource.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les ressources exploitées');
    }
  }

}
