import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CategoryChoiceChips extends StatefulWidget {
  const CategoryChoiceChips({super.key});

  @override
  State<CategoryChoiceChips> createState() => _CategoryChoiceChipsState();
}

class _CategoryChoiceChipsState extends State<CategoryChoiceChips> {
  final categories = [
    "All Coffee",
    "Machiato",
    "Latte",
    "Americano",
    "Cappuccino",
    "Mocha",
    "Frappe",
    "Cold Coffee",
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    const double spacing = 24;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: spacing,
      ),
      child: Row(
        spacing: 12,
        children: [
          for (int i = 0; i < categories.length; i++)
            FilterChip(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 8, cornerSmoothing: 1),
                ),
              ),
              label: Text(categories[i]),
              selected: selectedIndex == i,
              onSelected: (value) {
                setState(() {
                  selectedIndex = i;
                });
              },
            ),
        ],
      ),
    );
  }
}
