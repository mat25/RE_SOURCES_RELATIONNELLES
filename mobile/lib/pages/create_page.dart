import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../repositories/resource_repository.dart';
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
      debugPrint('Catégories chargées : $_categories');
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
    final repository = ResourceRepository(ApiClient());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une ressource'),
        backgroundColor: Colors.deepPurple,
      ),
      body: session.isLoggedIn
          ? _isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Nouvelle ressource',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Contenu',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _videoLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Lien vidéo (optionnel)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie',
                      border: OutlineInputBorder(),
                    ),
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ARTICLE', child: Text('Article')),
                      DropdownMenuItem(value: 'VIDEO', child: Text('Vidéo')),
                      DropdownMenuItem(value: 'LIEN', child: Text('Lien')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _type = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _visibility,
                    decoration: const InputDecoration(
                      labelText: 'Visibilité',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'PUBLIC', child: Text('Public')),
                      DropdownMenuItem(value: 'PRIVEE', child: Text('Privée')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _visibility = value);
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isSubmitting = true);

                        try {
                          await repository.createResource(
                            token: session.token!,
                            data: {
                              'title': _titleController.text,
                              'content': _contentController.text,
                              'videoLink': _videoLinkController.text.isNotEmpty
                                  ? _videoLinkController.text
                                  : '',
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
                    icon: const Icon(Icons.add),
                    label: const Text('Créer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16,),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          : const Center(child: Text('Veuillez vous connecter.')),
    );
  }
}
