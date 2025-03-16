import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../repositories/ressource_repository.dart';
import '../models/ressource.dart';
import '../core/api/api_client.dart';
import '../widgets/app_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ressourceRepository = RessourceRepository(ApiClient());
  late Future<List<Ressource>> ressources;

  @override
  void initState() {
    super.initState();
    ressources = ressourceRepository.getRessources();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '(RE)SOURCES RELATIONNELLES',
      body: FutureBuilder<List<Ressource>>(
        future: ressources,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    viewportFraction: 0.8,
                  ),
                  items: snapshot.data!.map((ressource) {
                    return Builder(
                      builder: (context) {
                        return Card(
                          color: Color(
                            int.parse(ressource.color.replaceFirst('#', '0xff')),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                const SizedBox(height: 8),
                                Text(
                                  'Année : ${ressource.year}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pantone : ${ressource.pantoneValue}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }
}
