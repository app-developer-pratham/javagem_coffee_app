import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';

class CategoryChoiceChips extends StatefulWidget {
  const CategoryChoiceChips({
    super.key,
    this.onCategorySelected,
  });

  final ValueChanged<String>? onCategorySelected;

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
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double spacing = 24;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: spacing,
      ),
      child: Row(
        children: [
          for (int i = 0; i < categories.length; i++)
            Padding(
              padding: EdgeInsets.only(right: i < categories.length - 1 ? 12 : 0),
              child: AppScaleTap(
                scaleDown: 0.94,
                onTap: () {
                  if (selectedIndex != i) {
                    setState(() {
                      selectedIndex = i;
                    });
                    widget.onCategorySelected?.call(categories[i]);
                  }
                },
                child: FilterChip(
                  shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(cornerRadius: 10, cornerSmoothing: 1),
                    ),
                  ),
                  label: Text(categories[i]),
                  selected: selectedIndex == i,
                  onSelected: (value) {
                    if (selectedIndex != i) {
                      setState(() {
                        selectedIndex = i;
                      });
                      widget.onCategorySelected?.call(categories[i]);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
