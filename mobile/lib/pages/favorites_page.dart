import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import 'login_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _showLoginSnackbar(BuildContext context, String message, bool isError) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    if (session.loginMessage != null) {
      _showLoginSnackbar(context, session.loginMessage!, session.isLoginError);
      session.clearLoginMessage();
    }

    return session.isLoggedIn
        ? const Center(child: Text('Page des favoris'))
        : const LoginPage();
  }
}
