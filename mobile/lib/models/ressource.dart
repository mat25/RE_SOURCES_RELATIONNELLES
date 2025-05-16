class Ressource {
  final int id;
  final String titre;
  final String contenu;
  final String? lienVideo;
  final DateTime dateCreation;
  final String visibilite;
  final String statut;
  final String? type;
  final String categorie;
  final int createurId;

  Ressource({
    required this.id,
    required this.titre,
    required this.contenu,
    this.lienVideo,
    required this.dateCreation,
    required this.visibilite,
    required this.statut,
    this.type,
    required this.categorie,
    required this.createurId,
  });

  factory Ressource.fromJson(Map<String, dynamic> json) {
    return Ressource(
      id: json['id'],
      titre: json['title'] ?? 'Sans titre',
      contenu: json['content'] ?? '',
      lienVideo: json['videoLink'],
      dateCreation: DateTime.parse(json['creationDate']),
      visibilite: json['visibility'] ?? 'PRIVEE',
      statut: json['status'] ?? 'EN_ATTENTE',
      type: json['type'],
      categorie: json['category'] ?? 'Autre',
      createurId: json['creatorId'],
    );
  }
}
