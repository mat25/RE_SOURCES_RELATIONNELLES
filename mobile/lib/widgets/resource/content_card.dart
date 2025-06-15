import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/resource.dart';

class ResourceContentCard extends StatelessWidget {
  final Resource resource;

  const ResourceContentCard({Key? key, required this.resource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contenu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(resource.content, style: const TextStyle(fontSize: 16)),
            if (resource.videoLink?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GestureDetector(
                  onTap: () async {
                    final url = Uri.tryParse(resource.videoLink!);
                    if (url != null && await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_fill, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          resource.videoLink!,
                          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
