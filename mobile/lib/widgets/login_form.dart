import 'package:flutter/material.dart';
import 'package:mobile/pages/home_page.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleLogin(SessionProvider session) async {
    setState(() {
      _isLoading = true;
    });

    await session.login();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email),
                  labelText: 'Pseudo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => session.username = value,
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Mot de passe',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                onChanged: (value) => session.password = value,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                  },
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.login, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Connexion...' : 'Se connecter',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : () => _handleLogin(session),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
