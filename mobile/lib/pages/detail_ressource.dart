import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ressource.dart';

class RessourceDetailPage extends StatefulWidget {
  final Ressource ressource;

  const RessourceDetailPage({Key? key, required this.ressource}) : super(key: key);

  @override
  State<RessourceDetailPage> createState() => _RessourceDetailPageState();
}

class _RessourceDetailPageState extends State<RessourceDetailPage> {
  bool isFavorite = false;
  bool isBookmarked = false;
  bool isUsed = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ressource = widget.ressource;

    return Scaffold(
      appBar: AppBar(
        title: Text(ressource.titre),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoTile(Icons.calendar_today, 'Créée le', ressource.dateCreation.toLocal().toString().split(' ')[0]),
                    _infoTile(Icons.category, 'Catégorie', ressource.categorie),
                    _infoTile(Icons.label, 'Type', ressource.type ?? 'Null'),
                    _infoTile(Icons.check_circle_outline, 'Statut', ressource.statut),
                    _infoTile(Icons.visibility, 'Visibilité', ressource.visibilite),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contenu',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ressource.contenu,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (ressource.lienVideo?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.tryParse(ressource.lienVideo!);
                          if (url != null && await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_fill, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ressource.lienVideo!,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionButton(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  label: 'Mettre de côté',
                  color: Colors.deepPurple,
                  onTap: () => setState(() => isBookmarked = !isBookmarked),
                ),
                _actionButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: 'Favori',
                  color: Colors.red,
                  onTap: () => setState(() => isFavorite = !isFavorite),
                ),
                _actionButton(
                  icon: isUsed ? Icons.check_box : Icons.check_box_outline_blank,
                  label: 'Exploité',
                  color: Colors.green,
                  onTap: () => setState(() => isUsed = !isUsed),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Ajouter un commentaire',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _commentController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Votre commentaire...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  final message = _commentController.text;
                  if (message.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Commentaire ajouté : "$message"')),
                    );
                    _commentController.clear();
                  }
                },
                child: const Text('Envoyer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
