import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';

class NavbarSearchWidget extends StatelessWidget {
  const NavbarSearchWidget({
    super.key,
    this.onChanged,
    this.onFilterTap,
  });

  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  void _showFilterModal(BuildContext context) {
    if (onFilterTap != null) {
      onFilterTap!();
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                topRight: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xffE3E3E3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filter Coffees',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text('Type', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: const Text('All'), selected: true),
                  ChoiceChip(label: const Text('Hot Only'), selected: false),
                  ChoiceChip(label: const Text('Iced Only'), selected: false),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Roast', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: const Text('Light'), selected: false),
                  ChoiceChip(label: const Text('Medium'), selected: true),
                  ChoiceChip(label: const Text('Dark'), selected: false),
                ],
              ),
              const SizedBox(height: 24),
              AppScaleTap(
                onTap: () => Navigator.pop(ctx),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Apply Filter'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: const ShapeDecoration(
                color: Color(0xff2A2A2A),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 12,
                      cornerSmoothing: 1,
                    ),
                  ),
                ),
              ),
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  hintText: "Search Coffee",
                  hintStyle: TextStyle(
                    color: Color(0xffA2A2A2),
                  ),
                  prefixIcon: Icon(
                    IconlyLight.search,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          AppScaleTap(
            scaleDown: 0.92,
            onTap: () => _showFilterModal(context),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: const ShapeDecoration(
                  color: Color(0xffC67C4E),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: 12,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                ),
                child: const Icon(
                  IconlyLight.filter,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
