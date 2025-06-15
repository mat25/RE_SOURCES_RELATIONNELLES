import 'package:flutter/material.dart';
import 'settings_tile.dart';

class SettingsCard extends StatelessWidget {
  final List<SettingsTile> tiles;

  const SettingsCard({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: List.generate(tiles.length * 2 - 1, (index) {
          if (index.isEven) {
            return tiles[index ~/ 2];
          } else {
            return const Divider(height: 1);
          }
        }),
      ),
    );
  }
}
