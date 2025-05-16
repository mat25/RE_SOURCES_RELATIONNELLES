import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../repositories/ressource_repository.dart';
import '../repositories/category_repository.dart';
import '../core/api/api_client.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();

  String _visibility = 'PUBLIC';
  String _type = 'ARTICLE';
  int? _selectedCategoryId;

  bool _isSubmitting = false;
  bool _isLoadingCategories = true;

  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final session = Provider.of<SessionProvider>(context, listen: false);
      final categoryRepository = CategoryRepository(ApiClient());

      final categories = await categoryRepository.getCategories(token: session.token);
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      debugPrint('Erreur chargement catégories : $e');
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);
    final repository = RessourceRepository(ApiClient());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une ressource'),
      ),
      body: session.isLoggedIn
          ? _isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Contenu'),
                validator: (value) => value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _videoLinkController,
                decoration: const InputDecoration(labelText: 'Lien vidéo (optionnel)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: _categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat['id'],
                    child: Text(cat['label'] ?? 'Sans nom'),
                  );
                }).toList(),
                validator: (value) =>
                value == null ? 'Veuillez choisir une catégorie' : null,
                onChanged: (value) {
                  setState(() => _selectedCategoryId = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'ARTICLE', child: Text('Article')),
                  DropdownMenuItem(value: 'VIDEO', child: Text('Vidéo')),
                  DropdownMenuItem(value: 'LIEN', child: Text('Lien')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _visibility,
                decoration: const InputDecoration(labelText: 'Visibilité'),
                items: const [
                  DropdownMenuItem(value: 'PUBLIC', child: Text('Public')),
                  DropdownMenuItem(value: 'PRIVEE', child: Text('Privée')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _visibility = value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isSubmitting = true);

                    try {
                      await repository.createRessource(
                        token: session.token!,
                        data: {
                          'title': _titleController.text,
                          'content': _contentController.text,
                          'videoLink': _videoLinkController.text.isNotEmpty ? _videoLinkController.text : '',
                          'visibility': _visibility,
                          'type': _type,
                          'categoryId': _selectedCategoryId,
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Ressource créée avec succès')
                        ),
                      );
                      _formKey.currentState!.reset();
                      setState(() => _selectedCategoryId = null);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur : $e')),
                      );
                    } finally {
                      setState(() => _isSubmitting = false);
                    }
                  }
                },
                child: const Text('Créer'),
              ),
            ],
          ),
        ),
      )
          : const Center(child: Text('Veuillez vous connecter.')),
    );
  }
}
