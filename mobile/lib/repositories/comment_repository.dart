import '../core/api/api_client.dart';
import '../models/comment.dart';

class CommentRepository {
  final ApiClient _client;

  CommentRepository(this._client);

  Future<List<Comment>> fetchComments(int resourceId, {String? token}) async {
    final response = await _client.get('/resources/$resourceId/comments', token: token);

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des commentaires');
    }
  }

  Future<void> postComment({
    required int resourceId,
    required String content,
    int? parentId,
    required String token,
  }) async {
    final body = {
      'content': content,
      if (parentId != null) 'parentId': parentId,
    };

    final response = await _client.post('/resources/$resourceId/comments', body, token: token);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur lors de l’envoi du commentaire');
    }
  }
}
