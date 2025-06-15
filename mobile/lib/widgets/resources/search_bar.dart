import 'package:flutter/material.dart';

class ResourceSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ResourceSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Rechercher une ressource...",
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
