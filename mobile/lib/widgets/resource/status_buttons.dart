import 'package:flutter/material.dart';

class StatusButtons extends StatelessWidget {
  final bool isBookmarked;
  final bool isFavorite;
  final bool isUsed;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onUsedToggle;

  const StatusButtons({
    Key? key,
    required this.isBookmarked,
    required this.isFavorite,
    required this.isUsed,
    required this.onBookmarkToggle,
    required this.onFavoriteToggle,
    required this.onUsedToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: 'Mettre de côté',
          onTap: onBookmarkToggle,
          color: Colors.deepPurple,
        ),
        _actionButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          label: 'Favori',
          onTap: onFavoriteToggle,
          color: Colors.red,
        ),
        _actionButton(
          icon: isUsed ? Icons.check_box : Icons.check_box_outline_blank,
          label: 'Exploité',
          onTap: onUsedToggle,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, color: color), onPressed: onTap),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
