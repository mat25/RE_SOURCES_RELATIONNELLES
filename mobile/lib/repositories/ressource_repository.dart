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



}
