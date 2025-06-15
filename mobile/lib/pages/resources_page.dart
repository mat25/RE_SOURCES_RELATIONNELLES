import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../repositories/resource_repository.dart';
import '../models/resource.dart';
import '../core/api/api_client.dart';
import '../widgets/favorites/resource_card.dart';
import 'login_page.dart';
import 'create_resource.dart';
import 'detail_resource.dart';
import '../widgets/resources/search_bar.dart';
import '../widgets/resources/category_filter_bar.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final resourceRepository = ResourceRepository(ApiClient());
  late Future<List<Resource>> resourcesFuture;
  List<Resource> allResources = [];
  String searchQuery = '';
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    resourcesFuture = resourceRepository.getResources().then((list) {
      allResources = list;
      return list;
    });
  }

  List<Resource> get filteredResources {
    return allResources.where((r) {
      final matchesSearch = r.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory.isEmpty || r.category.toLowerCase() == selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);
    if (!session.isLoggedIn) return const LoginPage();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<List<Resource>>(
        future: resourcesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else {
            final categories = allResources.map((r) => r.category.toLowerCase()).toSet().toList()..sort();

            return Column(
              children: [
                ResourceSearchBar(onChanged: (value) {
                  setState(() => searchQuery = value);
                }),
                CategoryFilterBar(
                  categories: categories,
                  selected: selectedCategory,
                  onSelected: (cat) {
                    setState(() => selectedCategory = selectedCategory == cat ? '' : cat);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: filteredResources.isEmpty
                        ? const Center(child: Text("Aucune ressource trouvée."))
                        : ListView.builder(
                      itemCount: filteredResources.length,
                      itemBuilder: (context, index) {
                        final res = filteredResources[index];
                        return ResourceCard(
                          resource: res,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResourceDetailPage(resource: res, token: session.token),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateResource()));
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Créer une ressource", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
