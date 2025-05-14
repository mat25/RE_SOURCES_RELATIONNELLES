import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'login_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (session.loginMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(session.loginMessage!),
                backgroundColor: session.isLoggedIn ? Colors.green : Colors.red,
              ),
            );
            session.clearLoginMessage();
          }
        });

        return session.isLoggedIn
            ? const Center(child: Text('Page des favoris'))
            : const LoginPage();
      },
    );
  }
}
