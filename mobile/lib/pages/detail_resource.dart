import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/resource.dart';
import '../repositories/resource_repository.dart';
import '../core/api/api_client.dart';

class ResourceDetailPage extends StatefulWidget {
  final Resource resource;
  final String? token;

  const ResourceDetailPage({Key? key, required this.resource, this.token}) : super(key: key);

  @override
  State<ResourceDetailPage> createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  late bool isFavorite;
  late bool isBookmarked;
  late bool isUsed;
  late bool isLoading;
  final TextEditingController _commentController = TextEditingController();
  late ResourceRepository _repository;

  @override
  void initState() {
    super.initState();

    isFavorite = false;
    isBookmarked = false;
    isUsed = false;
    isLoading = true;

    _repository = ResourceRepository(ApiClient());
    _fetchStatuses(); // Appel essentiel
  }

  Future<void> _fetchStatuses() async {
    try {
      final id = widget.resource.id;
      final favorites = await _repository.fetchFavorites(token: widget.token);
      final setAside = await _repository.fetchSetAside(token: widget.token);
      final exploited = await _repository.fetchExploited(token: widget.token);

      setState(() {
        isFavorite = favorites.any((r) => r.id == id);
        isBookmarked = setAside.any((r) => r.id == id);
        isUsed = exploited.any((r) => r.id == id);
        isLoading = false;
      });
    } catch (e) {
      _showError('Erreur lors du chargement des statuts : $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await _repository.toggleFavorite(widget.resource.id, token: widget.token);
      setState(() => isFavorite = !isFavorite);
    } catch (e) {
      _showError('Échec du changement d’état "favori"');
    }
  }

  Future<void> _toggleSetAside() async {
    try {
      await _repository.toggleSetAside(widget.resource.id, token: widget.token);
      setState(() => isBookmarked = !isBookmarked);
    } catch (e) {
      _showError('Échec du changement d’état "mis de côté"');
    }
  }

  Future<void> _toggleExploited() async {
    try {
      await _repository.toggleExploited(widget.resource.id, token: widget.token);
      setState(() => isUsed = !isUsed);
    } catch (e) {
      _showError('Échec du changement d’état "exploité"');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;

    return Scaffold(
      appBar: AppBar(
        title: Text(resource.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    _infoTile(Icons.calendar_today, 'Créée le', resource.creationDate.toLocal().toString().split(' ')[0]),
                    _infoTile(Icons.category, 'Catégorie', resource.category),
                    _infoTile(Icons.label, 'Type', resource.type ?? 'Null'),
                    _infoTile(Icons.check_circle_outline, 'Statut', resource.status),
                    _infoTile(Icons.visibility, 'Visibilité', resource.visibility),
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
                      resource.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (resource.videoLink?.isNotEmpty == true) ...[
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          final url = Uri.tryParse(resource.videoLink!);
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
                                resource.videoLink!,
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
                  onTap: _toggleSetAside,
                ),
                _actionButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: 'Favori',
                  color: Colors.red,
                  onTap: _toggleFavorite,
                ),
                _actionButton(
                  icon: isUsed ? Icons.check_box : Icons.check_box_outline_blank,
                  label: 'Exploité',
                  color: Colors.green,
                  onTap: _toggleExploited,
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
