import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../repositories/resource_repository.dart';
import '../models/resource.dart';
import '../core/api/api_client.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final resourceRepository = ResourceRepository(ApiClient());
  late Future<List<Resource>> resources;

  @override
  void initState() {
    super.initState();
    resources = resourceRepository.getResources();
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: FutureBuilder<List<Resource>>(
        future: resources,
        builder: (context, snapshot) {
          print('Has data: ${snapshot.hasData}');
          print('Data: ${snapshot.data}');
          print('Runtime type: ${snapshot.data?.runtimeType}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Aucune donnée reçue'));
          } else if (snapshot.data is! List<Resource>) {
            return const Center(child: Text('Données invalides'));
          } else if (snapshot.hasData) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bienvenue !',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Découvrez les différentes ressources disponibles dans notre base. '
                          'Faites défiler pour explorer !',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 300,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        viewportFraction: 0.8,
                      ),
                      items: snapshot.data!.map((resource) {
                        return Card(
                          color: Colors.deepPurple.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  resource.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Catégorie : ${resource.category}',
                                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Type : ${resource.type}',
                                  style: const TextStyle(fontSize: 16, color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.view_list),
                        label: const Text('Voir toutes les ressources'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final session = Provider.of<SessionProvider>(context, listen: false);
                          session.goToTab(0);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => MainPage(session: session),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    );
  }
}
