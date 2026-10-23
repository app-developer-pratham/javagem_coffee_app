import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/widgets/app_bottom_navigation_bar.dart';
import 'package:javagem_coffee_app/widgets/category_choice_chips.dart';
import 'package:javagem_coffee_app/widgets/navbar_location_selector.dart';
import 'package:javagem_coffee_app/widgets/navbar_search_widget.dart';
import 'package:javagem_coffee_app/widgets/navigation_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double spacing = 24;
    const double bannerAspectRatio = 2.336;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double bannerWidth = screenWidth - (spacing * 2);
    final double dynamicBannerHeight = bannerWidth / bannerAspectRatio;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: AppBottomNavigationBar(
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          currentIndex: selectedIndex,
        ),
        body: SingleChildScrollView(
          child: Column(
            spacing: spacing,
            children: [
              Stack(
                children: [
                  // Background
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: dynamicBannerHeight / 1.75,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff111111),
                            Color(0xff313131),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                    ),
                  ),
                  // Foreground
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: spacing,
                        left: spacing,
                        top: spacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 24,
                        children: [
                          NavbarLocationSelector(),
                          NavbarSearchWidget(),
                          Image.asset(
                            "assets/images/promo_banner.png",
                            height: dynamicBannerHeight,
                            width: bannerWidth,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              CategoryChoiceChips(),
            ],
          ),
        ),
      ),
    );
  }
}
