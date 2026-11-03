import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/screens/tabs/cart_tab.dart';
import 'package:javagem_coffee_app/screens/tabs/favorites_tab.dart';
import 'package:javagem_coffee_app/screens/tabs/notification_tab.dart';
import 'package:javagem_coffee_app/widgets/app_bottom_navigation_bar.dart';
import 'package:javagem_coffee_app/widgets/category_choice_chips.dart';
import 'package:javagem_coffee_app/widgets/coffee_card.dart';
import 'package:javagem_coffee_app/widgets/navbar_location_selector.dart';
import 'package:javagem_coffee_app/widgets/navbar_search_widget.dart';
import 'package:javagem_coffee_app/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isGridLoading = false;
  String _selectedCategory = "All Coffee";
  String _searchQuery = "";
  late List<CoffeeItem> _displayedCoffees;

  @override
  void initState() {
    super.initState();
    _displayedCoffees = List.from(dummyCoffeeList);

    // Initial shimmer loading simulation for template feel
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _filterCoffees();
      });
    }
  }

  void _onCategorySelected(String category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
      _isGridLoading = true;
    });

    // Simulate snappy network call / filter delay with grid shimmer
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _filterCoffees();
          _isGridLoading = false;
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterCoffees();
    });
  }

  void _filterCoffees() {
    List<CoffeeItem> items = List.from(dummyCoffeeList);

    // Category filter
    if (_selectedCategory == "Machiato") {
      items = items
          .where((c) =>
              c.name.toLowerCase().contains("mocha") ||
              c.subtitle.toLowerCase().contains("foam"))
          .toList();
    } else if (_selectedCategory == "Latte") {
      items = items
          .where((c) =>
              c.name.toLowerCase().contains("white") ||
              c.subtitle.toLowerCase().contains("espresso"))
          .toList();
    } else if (_selectedCategory == "Americano") {
      items = items
          .where((c) => c.name.toLowerCase().contains("panna"))
          .toList();
    } else if (_selectedCategory == "Cappuccino") {
      items = items
          .where((c) => c.name.toLowerCase().contains("fusi"))
          .toList();
    }

    // Search query filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      items = items
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              c.subtitle.toLowerCase().contains(q))
          .toList();
    }

    _displayedCoffees = items;
  }

  Widget _buildHomeFeed(
    BuildContext context,
    double screenWidth,
    double bannerWidth,
    double dynamicBannerHeight,
    double totalBottomPadding,
  ) {
    return RefreshIndicator(
      color: AppTheme.primaryColor,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // 1. Top Bar Header & Promo Banner with dark gradient background
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Dark Background gradient
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: dynamicBannerHeight / 1.75,
                  child: Container(
                    decoration: const BoxDecoration(
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
                // Foreground content: Location + Search + Promo Banner
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: AppTheme.spacing,
                      left: AppTheme.spacing,
                      top: AppTheme.spacing,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location Selector or Shimmer
                        _isLoading
                            ? const LocationHeaderSkeleton()
                            : const NavbarLocationSelector(),
                        const SizedBox(height: AppTheme.spacing),

                        // Search Bar Widget
                        NavbarSearchWidget(
                          onChanged: _onSearchChanged,
                        ),
                        const SizedBox(height: AppTheme.spacing),

                        // Promo Banner with Hero / Shimmer
                        _isLoading
                            ? PromoBannerSkeleton(
                                width: bannerWidth,
                                height: dynamicBannerHeight,
                              )
                            : AppScaleTap(
                                scaleDown: 0.98,
                                child: ClipSmoothRect(
                                  radius: const SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 16,
                                      cornerSmoothing: 0.6,
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/images/promo_banner.png",
                                    height: dynamicBannerHeight,
                                    width: bannerWidth,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Category Choice Chips or Shimmer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: AppTheme.spacing),
              child: _isLoading
                  ? const CategoryChipsSkeleton()
                  : CategoryChoiceChips(
                      onCategorySelected: _onCategorySelected,
                    ),
            ),
          ),

          // 3. Coffee Grid (Skeleton or Loaded Cards with smooth crossfade)
          if (_isLoading || _isGridLoading)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacing,
                AppTheme.spacing,
                AppTheme.spacing,
                totalBottomPadding,
              ),
              sliver: const CoffeeGridSkeleton(itemCount: 4),
            )
          else if (_displayedCoffees.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.coffee_outlined,
                      size: 48,
                      color: AppTheme.textMutedColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No coffees found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textNormalColor,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Try searching for another flavor or category',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMutedColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacing,
                AppTheme.spacing,
                AppTheme.spacing,
                totalBottomPadding,
              ),
              sliver: SliverGrid.builder(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: AppTheme.productCardAspectRatio,
                ),
                itemCount: _displayedCoffees.length,
                itemBuilder: (context, index) {
                  return CoffeeCard(
                    coffee: _displayedCoffees[index],
                    heroPrefix: 'home',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double bannerWidth = screenWidth - (AppTheme.spacing * 2);
    final double dynamicBannerHeight =
        bannerWidth / AppTheme.promoBannerAspectRatio;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final double totalBottomPadding = bottomInset + 90.0 + AppTheme.spacing;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: AppBottomNavigationBar(
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_selectedIndex),
            child: _buildCurrentTab(
              screenWidth,
              bannerWidth,
              dynamicBannerHeight,
              totalBottomPadding,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTab(
    double screenWidth,
    double bannerWidth,
    double dynamicBannerHeight,
    double totalBottomPadding,
  ) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeFeed(
          context,
          screenWidth,
          bannerWidth,
          dynamicBannerHeight,
          totalBottomPadding,
        );
      case 1:
        return FavoritesTab(
          onBrowseTap: () => setState(() => _selectedIndex = 0),
        );
      case 2:
        return const CartTab();
      case 3:
        return const NotificationTab();
      default:
        return _buildHomeFeed(
          context,
          screenWidth,
          bannerWidth,
          dynamicBannerHeight,
          totalBottomPadding,
        );
    }
  }
}
