import 'package:flutter/material.dart';
import 'package:mobile/pages/detail_ressource.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../repositories/ressource_repository.dart';
import '../models/ressource.dart';
import '../core/api/api_client.dart';
import 'create_page.dart';

class RessourcesPage extends StatefulWidget {
  const RessourcesPage({Key? key}) : super(key: key);

  @override
  State<RessourcesPage> createState() => _RessourcesPageState();
}

class _RessourcesPageState extends State<RessourcesPage> {
  final ressourceRepository = RessourceRepository(ApiClient());
  late Future<List<Ressource>> ressourcesFuture;

  String searchQuery = '';
  String selectedCategorie = '';
  List<Ressource> allRessources = [];

  @override
  void initState() {
    super.initState();
    ressourcesFuture = ressourceRepository.getRessources().then((list) {
      allRessources = list;
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

  List<Ressource> get filteredRessources {
    return allRessources.where((r) {
      final matchSearch = r.titre.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCategorie = selectedCategorie.isEmpty || r.categorie.toLowerCase() == selectedCategorie.toLowerCase();
      return matchSearch && matchCategorie;
    }).toList();
  }

  List<String> get availableCategories {
    final categories = allRessources.map((r) => r.categorie.toLowerCase()).toSet().toList();
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
      body: FutureBuilder<List<Ressource>>(
        future: ressourcesFuture,
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
                    child: filteredRessources.isEmpty
                        ? const Center(child: Text("Aucune ressource trouvée."))
                        : ListView.builder(
                      itemCount: filteredRessources.length,
                      itemBuilder: (context, index) {
                        final ressource = filteredRessources[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RessourceDetailPage(ressource: ressource),
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
                                          ressource.titre,
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
                                          ressource.categorie,
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
                                    ressource.contenu.length > 100
                                        ? "${ressource.contenu.substring(0, 100)}..."
                                        : ressource.contenu,
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
