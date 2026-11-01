import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/widgets/app_bottom_navigation_bar.dart';
import 'package:javagem_coffee_app/widgets/category_choice_chips.dart';
import 'package:javagem_coffee_app/widgets/coffee_card.dart';
import 'package:javagem_coffee_app/widgets/navbar_location_selector.dart';
import 'package:javagem_coffee_app/widgets/navbar_search_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double bannerAspectRatio = 2.336;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double bannerWidth = screenWidth - (AppTheme.spacing * 2);
    final double dynamicBannerHeight = bannerWidth / bannerAspectRatio;
    // Total bottom clear zone = system home bar inset + nav bar height + breathing margin
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double totalBottomPadding = bottomInset + 90.0 + AppTheme.spacing;
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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
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
                        right: AppTheme.spacing,
                        left: AppTheme.spacing,
                        top: AppTheme.spacing,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppTheme.spacing,
                        children: [
                          NavbarLocationSelector(),
                          NavbarSearchWidget(),
                          ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(
                              SmoothRadius(
                                cornerRadius:
                                    16, // Match your Figma corner radius
                                cornerSmoothing: 0.6, // 0.6 for standard iOS/Figma squircle, or 1.0 for full smooth
                              ),
                            ),
                            child: Image.asset(
                              "assets/images/promo_banner.png",
                              height: dynamicBannerHeight,
                              width: bannerWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: AppTheme.spacing),
                child: CategoryChoiceChips(),
              ),
            ),
            // 3. Lazy-loading Coffee Grid
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacing,
                AppTheme.spacing,
                AppTheme.spacing,
                totalBottomPadding,
              ), // extra bottom padding for floating bottom bar
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.655, // Adjust to fit card dimensions
                ),
                itemCount: dummyCoffeeList.length,
                itemBuilder: (context, index) {
                  return CoffeeCard(coffee: dummyCoffeeList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
