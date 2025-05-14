import 'package:flutter/material.dart';
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
        title: Text(ressource.name),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(int.parse(ressource.color.replaceFirst('#', '0xff'))).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ressource.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Année : ${ressource.year}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Text('Valeur Pantone : ${ressource.pantoneValue}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("Couleur : "),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(int.parse(ressource.color.replaceFirst('#', '0xff'))),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Action Buttons with Labels
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

            // Comment Section
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
