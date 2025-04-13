import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../repositories/ressource_repository.dart';
import '../models/ressource.dart';
import '../core/api/api_client.dart';
import '../widgets/login_form.dart';

class RessourcesPage extends StatefulWidget {
  const RessourcesPage({Key? key}) : super(key: key);

  @override
  State<RessourcesPage> createState() => _RessourcesPageState();
}

class _RessourcesPageState extends State<RessourcesPage> {
  final ressourceRepository = RessourceRepository(ApiClient());
  late Future<List<Ressource>> ressources;

  @override
  void initState() {
    super.initState();
    ressources = ressourceRepository.getRessources();
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return session.isLoggedIn
        ? Scaffold(
      body: FutureBuilder<List<Ressource>>(
        future: ressources,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final ressource = snapshot.data![index];
                    return Card(
                      color: Color(int.parse(
                          ressource.color.replaceFirst('#', '0xff'))),
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
                                  fontSize: 18, color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pantone : ${ressource.pantoneValue}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible'));
          }
        },
      ),
    )
        : const LoginForm();
  }
}
