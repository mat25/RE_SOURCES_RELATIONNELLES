import '../core/api/api_client.dart';
import '../models/ressource.dart';

class RessourceRepository {
  final ApiClient _client;

  RessourceRepository(this._client);

  Future<List<Ressource>> getRessources() async {
    final response = await _client.get('/unknown');

    print('Réponse : ${response.data}');

    if (response.data != null && response.data['data'] is List) {
      return Ressource.fromJsonList(response.data['data']);
    } else {
      throw Exception('Format de réponse inattendu');
    }
  }



}
