import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';
import '../core/api/api_client.dart';
import '../models/user.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/header.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userRepository = UserRepository(ApiClient());
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    user = userRepository.getUser(2);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Accueil',
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  SizedBox(height: 12),
                  Text('Nom : ${user.name}', style: TextStyle(fontSize: 20)),
                  Text('Email : ${user.email}', style: TextStyle(fontSize: 16)),
                ],
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
