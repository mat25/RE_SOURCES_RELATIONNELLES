class Resource {
  final int id;
  final String title;
  final String content;
  final String? videoLink;
  final DateTime creationDate;
  final String visibility;
  final String status;
  final String? type;
  final bool active;
  final String category;
  final int creatorId;
  final bool isFavorite;
  final bool isSetAside;
  final bool isExploited;

  Resource({
    required this.id,
    required this.title,
    required this.content,
    this.videoLink,
    required this.creationDate,
    required this.visibility,
    required this.status,
    this.type,
    required this.active,
    required this.category,
    required this.creatorId,
    required this.isFavorite,
    required this.isSetAside,
    required this.isExploited,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      title: json['title'] ?? 'Sans titre',
      content: json['content'] ?? '',
      videoLink: json['videoLink'],
      creationDate: DateTime.parse(json['creationDate']),
      visibility: json['visibility'] ?? 'PRIVEE',
      status: json['status'] ?? 'EN_ATTENTE',
      type: json['type'],
      active: json['active'] ?? true,
      category: json['category'] ?? 'Autre',
      creatorId: json['creatorId'],
      isFavorite: json['isFavorite'] ?? false,
      isSetAside: json['isSetAside'] ?? false,
      isExploited: json['isExploited'] ?? false,
    );
  }
}
