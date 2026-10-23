import 'package:flutter/material.dart';

class NavigationIcon extends StatelessWidget {
  const NavigationIcon(
    this.icon, {
    super.key,
    required this.onTap,
    this.isActive = false,
    this.activeIcon,
  });
  final Widget icon;
  final Widget? activeIcon;
  final bool isActive;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? theme.primaryColor;
    final size = MediaQuery.of(context).size;
    return SizedBox.square(
      dimension: size.height * 0.08,
      child: IconButton(
        onPressed: onTap,
        icon: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                size: 24,
                color: isActive
                    ? theme.bottomNavigationBarTheme.selectedItemColor
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              child: isActive ? (activeIcon ?? icon) : icon,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              width: 10,
              height: isActive ? 5 : 0,
              margin: EdgeInsets.only(
                top: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive ? bgColor : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
