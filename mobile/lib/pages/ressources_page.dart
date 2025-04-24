import 'package:flutter/material.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../repositories/ressource_repository.dart';
import '../models/ressource.dart';
import '../core/api/api_client.dart';
import '../widgets/login_form.dart';
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
  String selectedColor = '';
  List<Ressource> allRessources = [];

  @override
  void initState() {
    super.initState();
    ressourcesFuture = ressourceRepository.getRessources().then((list) {
      allRessources = list;
      return list;
    });
  }

  List<Ressource> get filteredRessources {
    return allRessources.where((r) {
      final matchSearch = r.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchColor = selectedColor.isEmpty || r.color.toLowerCase() == selectedColor.toLowerCase();
      return matchSearch && matchColor;
    }).toList();
  }

  List<String> get availableColors {
    final colors = allRessources.map((r) => r.color.toLowerCase()).toSet().toList();
    colors.sort();
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return session.isLoggedIn
        ? Scaffold(
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
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Rechercher une ressource...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableColors.length,
                    itemBuilder: (context, index) {
                      final colorHex = availableColors[index];
                      final isSelected = selectedColor == colorHex;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ChoiceChip(
                          label: Text(
                            colorHex.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          selectedColor: Color(int.parse(colorHex.replaceFirst('#', '0xff'))),
                          backgroundColor: Color(int.parse(colorHex.replaceFirst('#', '0xff'))).withOpacity(0.4),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedColor = isSelected ? '' : colorHex;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: filteredRessources.length,
                      itemBuilder: (context, index) {
                        final ressource = filteredRessources[index];
                        return Card(
                          color: Color(int.parse(
                              ressource.color.replaceFirst('#', '0xff'))
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ressource.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Année : ${ressource.year}',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white70
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Pantone : ${ressource.pantoneValue}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white60
                                  ),
                                ),
                              ],
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
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePage()),
            );
          },
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add, size: 36),
        ),
      ),
    )
        : const LoginPage();
  }
}
