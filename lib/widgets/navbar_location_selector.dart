import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';

class NavbarLocationSelector extends StatefulWidget {
  const NavbarLocationSelector({
    super.key,
    this.currentLocation = "Bilzen, Tanjungbalai",
    this.onLocationChanged,
  });

  final String currentLocation;
  final ValueChanged<String>? onLocationChanged;

  @override
  State<NavbarLocationSelector> createState() => _NavbarLocationSelectorState();
}

class _NavbarLocationSelectorState extends State<NavbarLocationSelector> {
  late String _location;

  @override
  void initState() {
    super.initState();
    _location = widget.currentLocation;
  }

  void _showLocationPicker() {
    final locations = [
      "Bilzen, Tanjungbalai",
      "Kpg. Sutoyo No. 620",
      "Medan Central, Sumatra",
      "Jakarta Barat, Green Garden",
    ];

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
                'Select Delivery Location',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              for (final loc in locations)
                ListTile(
                  leading: const Icon(IconlyLight.location, color: Color(0xffC67C4E)),
                  title: Text(
                    loc,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: _location == loc
                      ? const Icon(Icons.check_circle, color: Color(0xffC67C4E))
                      : null,
                  onTap: () {
                    setState(() {
                      _location = loc;
                    });
                    widget.onLocationChanged?.call(loc);
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaleTap(
      scaleDown: 0.96,
      onTap: _showLocationPicker,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Location",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xffA2A2A2),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffD8D8D8),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                IconlyLight.arrow_down_2,
                size: 16,
                color: Color(0xffD8D8D8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
