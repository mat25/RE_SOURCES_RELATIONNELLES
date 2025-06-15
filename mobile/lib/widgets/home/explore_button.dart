import 'package:flutter/material.dart';
import '../../pages/main_page.dart';
import '../../providers/session_provider.dart';

class ExploreButton extends StatelessWidget {
  final SessionProvider session;

  const ExploreButton({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.view_list),
        label: const Text('Voir toutes les ressources'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          session.goToTab(0);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MainPage(session: session),
            ),
          );
        },
      ),
    );
  }
}
