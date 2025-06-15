import 'package:flutter/material.dart';
import '../../models/resource.dart';

class ResourceInfoCard extends StatelessWidget {
  final Resource resource;

  const ResourceInfoCard({Key? key, required this.resource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoTile(Icons.calendar_today, 'Créée le', resource.creationDate.toLocal().toString().split(' ')[0]),
            _infoTile(Icons.category, 'Catégorie', resource.category),
            _infoTile(Icons.label, 'Type', resource.type ?? 'Non spécifié'),
            _infoTile(Icons.check_circle_outline, 'Statut', resource.status),
            _infoTile(Icons.visibility, 'Visibilité', resource.visibility),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 10),
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
