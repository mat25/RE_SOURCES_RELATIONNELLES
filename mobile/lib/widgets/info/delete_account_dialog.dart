import 'package:flutter/material.dart';
import '../../providers/session_provider.dart';
import '../../pages/main_page.dart';

void showDeleteAccountDialog(BuildContext context, SessionProvider session) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Supprimer le compte'),
      content: const Text('Cette action est irréversible. Êtes-vous sûr(e) de vouloir supprimer votre compte ?'),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            Navigator.pop(context);
            try {
              final message = await session.deleteAccount();
              await session.logout();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => MainPage(session: session)),
                      (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: Colors.green),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
                );
              }
            }
          },
        ),
      ],
    ),
  );
}
