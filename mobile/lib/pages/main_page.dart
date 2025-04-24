import 'package:flutter/material.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/pages/ressources_page.dart';
import 'package:mobile/pages/favorites_page.dart';
import 'package:mobile/providers/session_provider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final SessionProvider session;

  const MainPage({Key? key, required this.session}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<Widget> _pages = [
    const RessourcesPage(),
    const FavoritesPage(),
    const HomePage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    widget.session.goToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        int selectedIndex = session.currentIndex;

        return Scaffold(
          appBar: AppBar(
            title: const Text('(RE)Sources Relationnelles'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: _pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: session.goToTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade400,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: 'Ressources',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Favoris',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
          ),
        );
      },
    );
  }
}
