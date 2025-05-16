import '../core/api/api_client.dart';

class CategoryRepository {
  final ApiClient _client;

  CategoryRepository(this._client);

  Future<List<Map<String, dynamic>>> getCategories({String? token}) async {
    final response = await _client.get('/category', token: token);

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map<Map<String, dynamic>>((item) => {
        'id': item['id'],
        'label': item['label'],
      }).toList();
    } else {
      throw Exception('Échec de récupération des catégories');
    }
  }
}
