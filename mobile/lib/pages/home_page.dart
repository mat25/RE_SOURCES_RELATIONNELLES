import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/resource.dart';
import '../repositories/resource_repository.dart';
import '../core/api/api_client.dart';
import '../providers/session_provider.dart';
import '../pages/main_page.dart';
import '../widgets/home/welcome_header.dart';
import '../widgets/home/resource_carousel.dart';
import '../widgets/home/explore_button.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data is! List<Resource>) {
            return const Center(child: Text('Aucune donnée reçue'));
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WelcomeHeader(),
                  const SizedBox(height: 50),
                  ResourceCarousel(resources: snapshot.data!),
                  const SizedBox(height: 100),
                  ExploreButton(session: session),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
