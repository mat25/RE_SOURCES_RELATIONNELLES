import 'package:flutter/material.dart';
import 'package:mobile/models/resource.dart';
import 'package:mobile/pages/login_page.dart';
import 'package:mobile/pages/detail_resource.dart';
import 'package:mobile/repositories/resource_repository.dart';
import 'package:provider/provider.dart';
import '../core/api/api_client.dart';
import '../providers/session_provider.dart';

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

  Widget _buildList(List<Resource> list) {
    if (list.isEmpty) {
      return const Center(child: Text("Aucune ressource disponible."));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final res = list[index];

        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResourceDetailPage(
                  resource: res,
                  token: Provider.of<SessionProvider>(context, listen: false).token,
                ),
              ),
            );
            await _loadResources();
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    res.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text("Catégorie : ${res.category}"),
                  Text("Statut : ${res.status}"),
                  Text("Créée le : ${res.creationDate.toLocal().toString().split(' ')[0]}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    if (!session.isLoggedIn) return const LoginPage();

    final token = session.token;
    if (token == null) {
      return const Center(child: Text("Non connecté"));
    }

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
          _buildList(favorites),
          _buildList(setAside),
          _buildList(exploited),
        ],
      ),
    );
  }
}
