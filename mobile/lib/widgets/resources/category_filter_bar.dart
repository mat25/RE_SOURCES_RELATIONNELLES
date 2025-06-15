import 'package:flutter/material.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selected == cat;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(cat.toUpperCase()),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.deepPurple,
              ),
              selectedColor: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade100,
              selected: isSelected,
              onSelected: (_) => onSelected(cat),
            ),
          );
        },
      ),
    );
  }
}
