import 'package:flutter/material.dart';
import 'package:mobile/models/resource.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/repositories/resource_repository.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/providers/session_provider.dart';
import 'package:mobile/widgets/favorites/resource_list.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ResourceRepository _repository;

  List<Resource> favorites = [];
  List<Resource> setAside = [];
  List<Resource> exploited = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _repository = ResourceRepository(ApiClient());
    _loadResources();
  }

  Future<void> _loadResources() async {
    final session = Provider.of<SessionProvider>(context, listen: false);
    final token = session.token;
    try {
      final favs = await _repository.fetchFavorites(token: token);
      final aside = await _repository.fetchSetAside(token: token);
      final exp = await _repository.fetchExploited(token: token);

      setState(() {
        favorites = favs;
        setAside = aside;
        exploited = exp;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    if (!session.isLoggedIn) return const LoginPage();
    if (session.token == null) return const Center(child: Text("Non connecté"));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Favoris'),
            Tab(text: 'Mis de côté'),
            Tab(text: 'Exploités'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text('Erreur : $error'))
          : TabBarView(
        controller: _tabController,
        children: [
          ResourceList(resources: favorites, onRefresh: _loadResources),
          ResourceList(resources: setAside, onRefresh: _loadResources),
          ResourceList(resources: exploited, onRefresh: _loadResources),
        ],
      ),
    );
  }
}
