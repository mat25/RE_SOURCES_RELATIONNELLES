import 'package:flutter/material.dart';
import 'package:mobile/pages/detail_resource.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../repositories/resource_repository.dart';
import '../models/resource.dart';
import '../core/api/api_client.dart';
import 'create_page.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final resourceRepository = ResourceRepository(ApiClient());
  late Future<List<Resource>> resourcesFuture;

  String searchQuery = '';
  String selectedCategorie = '';
  List<Resource> allResources = [];

  @override
  void initState() {
    super.initState();
    resourcesFuture = resourceRepository.getResources().then((list) {
      allResources = list;
      return list;
    });
  }

  void _showLoginSnackbar(BuildContext context, String message, bool isError) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  List<Resource> get filteredResources {
    return allResources.where((r) {
      final matchSearch = r.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCategorie = selectedCategorie.isEmpty || r.category.toLowerCase() == selectedCategorie.toLowerCase();
      return matchSearch && matchCategorie;
    }).toList();
  }

  List<String> get availableCategories {
    final categories = allResources.map((r) => r.category.toLowerCase()).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    if (session.loginMessage != null) {
      _showLoginSnackbar(context, session.loginMessage!, session.isLoginError);
      session.clearLoginMessage();
    }

    return session.isLoggedIn
        ? Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<List<Resource>>(
        future: resourcesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: "Rechercher une ressource...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableCategories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final cat = availableCategories[index];
                      final isSelected = selectedCategorie == cat;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(cat.toUpperCase()),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.deepPurple,
                          ),
                          selectedColor: Colors.deepPurple,
                          backgroundColor: Colors.deepPurple.shade100,
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedCategorie = isSelected ? '' : cat;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: filteredResources.isEmpty
                        ? const Center(child: Text("Aucune ressource trouvée."))
                        : ListView.builder(
                      itemCount: filteredResources.length,
                      itemBuilder: (context, index) {
                        final resource = filteredResources[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResourceDetailPage(resource: resource, token: session.token),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          resource.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          resource.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    resource.content.length > 100
                                        ? "${resource.content.substring(0, 100)}..."
                                        : resource.content,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePage()),
          );
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(
            Icons.add,
            color: Colors.white
        ),
        label: const Text(
          "Créer une ressource",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    )
        : const LoginPage();
  }
}
