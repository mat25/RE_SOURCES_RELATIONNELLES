import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/user_repository.dart';
import '../../core/api/api_client.dart';
import '../../providers/session_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String prenom = '';
  String nom = '';
  String pseudo = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final userRepo = UserRepository(ApiClient());

  bool _isEmailValid(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> _register() async {
    final session = Provider.of<SessionProvider>(context, listen: false);

    if ([prenom, nom, pseudo, email, password, confirmPassword].any((v) => v.trim().isEmpty)) {
      _showSnackBar('Tous les champs sont requis.');
      return;
    }

    if (!_isEmailValid(email)) {
      _showSnackBar('Email invalide.');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Les mots de passe ne correspondent pas.');
      return;
    }

    try {
      await userRepo.registerUser(
        firstName: prenom,
        lastName: nom,
        username: pseudo,
        email: email,
        password: password,
      );

      _showSnackBar('Compte créé avec succès ! Connexion...');

      session.setCredentials(pseudo, password);
      final success = await session.login(pseudo, password);

    } catch (e) {
      _showSnackBar('Erreur lors de l’inscription : $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Créer un compte',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'Prénom', icon: Icons.account_circle, onChanged: (v) => prenom = v),
            const SizedBox(height: 16),
            _buildTextField(label: 'Nom', icon: Icons.badge, onChanged: (v) => nom = v),
            const SizedBox(height: 16),
            _buildTextField(label: 'Pseudo', icon: Icons.alternate_email, onChanged: (v) => pseudo = v),
            const SizedBox(height: 16),
            _buildTextField(label: 'Email', icon: Icons.email, onChanged: (v) => email = v),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Mot de passe',
              obscure: _obscurePassword,
              toggle: () => setState(() => _obscurePassword = !_obscurePassword),
              onChanged: (v) => password = v,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Confirmer le mot de passe',
              obscure: _obscureConfirmPassword,
              toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              onChanged: (v) => confirmPassword = v,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: const Text('S’inscrire', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _register,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, required Function(String) onChanged}) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required Function(String) onChanged,
  }) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
