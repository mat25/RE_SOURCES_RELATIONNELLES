import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Se connecter"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<SessionProvider>(context, listen: false)
                .checkSession();
          },
          child: const Text("Se connecter"),
        ),
      ),
    );
  }
}
