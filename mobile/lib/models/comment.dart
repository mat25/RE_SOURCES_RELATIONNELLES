class Comment {
  final int id;
  final String content;
  final String authorUsername;
  final DateTime createdAt;
  final int? parentId;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.content,
    required this.authorUsername,
    required this.createdAt,
    this.parentId,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      authorUsername: json['authorUsername'],
      createdAt: DateTime.parse(json['createdAt']),
      parentId: json['parentId'],
      replies: (json['replies'] as List)
          .map((e) => Comment.fromJson(e))
          .toList(),
    );
  }
}
