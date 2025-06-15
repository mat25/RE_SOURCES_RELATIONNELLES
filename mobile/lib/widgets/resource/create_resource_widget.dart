import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../repositories/resource_repository.dart';
import '../../repositories/category_repository.dart';
import '../../core/api/api_client.dart';

class ResourceForm extends StatefulWidget {
  const ResourceForm({super.key});

  @override
  State<ResourceForm> createState() => _ResourceFormState();
}

class _ResourceFormState extends State<ResourceForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _videoLinkController = TextEditingController();

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
      setState(() => _isLoadingCategories = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement catégories : $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _videoLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context, listen: false);
    final repository = ResourceRepository(ApiClient());

    if (_isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Nouvelle ressource',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 30),

                _buildTextField(
                  controller: _titleController,
                  label: 'Titre',
                  icon: Icons.title,
                  validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _contentController,
                  label: 'Contenu',
                  icon: Icons.description,
                  maxLines: 5,
                  validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _videoLinkController,
                  label: 'Lien vidéo (optionnel)',
                  icon: Icons.link,
                ),
                const SizedBox(height: 16),

                _buildDropdown<int>(
                  label: 'Catégorie',
                  value: _selectedCategoryId,
                  icon: Icons.category,
                  items: _categories.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(cat['label'] ?? 'Sans nom'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (val) => val == null ? 'Sélection requise' : null,
                ),
                const SizedBox(height: 16),

                _buildDropdown<String>(
                  label: 'Type',
                  value: _type,
                  icon: Icons.bookmark,
                  items: const [
                    DropdownMenuItem(value: 'ARTICLE', child: Text('Article')),
                    DropdownMenuItem(value: 'VIDEO', child: Text('Vidéo')),
                    DropdownMenuItem(value: 'LIEN', child: Text('Lien')),
                  ],
                  onChanged: (val) => setState(() => _type = val ?? 'ARTICLE'),
                ),
                const SizedBox(height: 16),

                _buildDropdown<String>(
                  label: 'Visibilité',
                  value: _visibility,
                  icon: Icons.visibility,
                  items: const [
                    DropdownMenuItem(value: 'PUBLIC', child: Text('Public')),
                    DropdownMenuItem(value: 'PRIVEE', child: Text('Privée')),
                  ],
                  onChanged: (val) => setState(() => _visibility = val ?? 'PUBLIC'),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
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
                              'videoLink': _videoLinkController.text,
                              'visibility': _visibility,
                              'type': _type,
                              'categoryId': _selectedCategoryId,
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ressource créée avec succès')),
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
                    icon: const Icon(Icons.send),
                    label: Text(_isSubmitting ? 'Création...' : 'Créer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    IconData? icon,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
