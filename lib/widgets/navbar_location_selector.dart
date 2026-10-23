import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';

class NavbarLocationSelector extends StatefulWidget {
  const new({super.key});

  @override
  State<NavbarLocationSelector> createState() => _NavbarLocationSelectorState();
}

class _NavbarLocationSelectorState extends State<NavbarLocationSelector> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (details) => setState(() => _isPressed = false),
      child: Opacity(
        opacity: _isPressed ? 0.6 : 1,
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xffA2A2A2),
              ),
            ),
            Row(
              spacing: 4,
              children: [
                Text(
                  "Bilzen, Tanjungbalai",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffD8D8D8),
                  ),
                ),
                const Icon(
                  IconlyLight.arrow_down_2,
                  size: 16,
                  color: Color(0xffD8D8D8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
