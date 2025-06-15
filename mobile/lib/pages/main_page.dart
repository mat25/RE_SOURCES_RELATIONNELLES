import 'package:flutter/material.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:mobile/pages/profil_page.dart';
import 'package:mobile/pages/resources_page.dart';
import 'package:mobile/pages/favorites_page.dart';
import 'package:mobile/providers/session_provider.dart';
import 'package:mobile/widgets/main/app_title_bar.dart';
import 'package:mobile/widgets/main/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final SessionProvider session;

  const MainPage({Key? key, required this.session}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = const [
    ResourcesPage(),
    FavoritesPage(),
    HomePage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        int selectedIndex = session.currentIndex;

        return Scaffold(
          appBar: const AppTitleBar(),
          body: _pages[selectedIndex],
          bottomNavigationBar: BottomNavBar(
            currentIndex: selectedIndex,
            onTap: session.goToTab,
          ),
        );
      },
    );
  }
}
