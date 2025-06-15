import 'package:flutter/material.dart';
import 'package:mobile/widgets/Form/login_form.dart';
import 'package:mobile/widgets/Form/register_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 40),

            Visibility(
              visible: _isRegistering,
              child: const RegisterForm(),
            ),

            if (!_isRegistering)
              const LoginForm(),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(_isRegistering ? 'Retour à la connexion' : 'Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
