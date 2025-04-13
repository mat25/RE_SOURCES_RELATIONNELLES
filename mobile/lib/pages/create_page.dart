import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/login_form.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return session.isLoggedIn
        ? const Center(child: Text('Page des favoris'))
        : const LoginForm();
  }
}
