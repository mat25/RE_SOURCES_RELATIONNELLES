import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/Resource/create_resource_widget.dart';

class CreateResource extends StatelessWidget {
  const CreateResource({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une ressource'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: session.isLoggedIn
          ? const Padding(
        padding: EdgeInsets.all(16),
        child: ResourceForm(),
      )
          : const Center(child: Text('Veuillez vous connecter.')),
    );
  }
}
