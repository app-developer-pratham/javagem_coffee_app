import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/widgets/navigation_icon.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });
  final int currentIndex;
  final Function(int value) onTap;

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  final List<AppBottomNavigationBarItem> destinations = [
    AppBottomNavigationBarItem(
      icon: Icon(IconlyLight.home),
      activeIcon: Icon(IconlyBold.home),
      index: 0,
      label: 'Home',
    ),
    AppBottomNavigationBarItem(
      icon: Icon(IconlyLight.heart),
      activeIcon: Icon(IconlyBold.heart),
      index: 1,
      label: 'Favorite',
    ),
    AppBottomNavigationBarItem(
      icon: Icon(IconlyLight.bag),
      activeIcon: Icon(IconlyBold.bag),
      index: 2,
      label: 'Cart',
    ),
    AppBottomNavigationBarItem(
      icon: Icon(IconlyLight.notification),
      activeIcon: Icon(IconlyBold.notification),
      index: 3,
      label: 'Notification',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Theme(
      data: theme.copyWith(splashFactory: NoSplash.splashFactory),
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.only(
          topLeft: SmoothRadius(cornerRadius: 30, cornerSmoothing: 0.6),
          topRight: SmoothRadius(cornerRadius: 30, cornerSmoothing: 0.6),
        ),
        child: BottomAppBar(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < destinations.length; i++)
                NavigationIcon(
                  destinations[i].icon,
                  isActive: widget.currentIndex == destinations[i].index,
                  activeIcon: destinations[i].activeIcon,
                  onTap: () {
                    widget.onTap(i);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNavigationBarItem {
  final Widget icon;
  final Widget activeIcon;
  final int index;
  final String label;

  new({
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.label,
  });
}
