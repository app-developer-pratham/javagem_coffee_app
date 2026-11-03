import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/widgets/coffee_card.dart';
import 'package:javagem_coffee_app/widgets/shimmer_loading.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({
    super.key,
    this.onBrowseTap,
  });

  final VoidCallback? onBrowseTap;

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalBottomPadding = bottomInset + 90.0 + AppTheme.spacing;
    final favorites = dummyCoffeeList.where((c) => c.isFavorite || c.id == 'coffee_1').toList();

    return Scaffold(
      backgroundColor: AppTheme.surfaceLightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textDarkColor,
              ),
        ),
      ),
      body: _isLoading
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacing,
                AppTheme.spacing,
                AppTheme.spacing,
                totalBottomPadding,
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: AppTheme.productCardAspectRatio,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const CoffeeCardSkeleton(),
              ),
            )
          : favorites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        IconlyLight.heart,
                        size: 64,
                        color: AppTheme.textMutedColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Favorites Yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDarkColor,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the heart on any coffee to add it here',
                        style: TextStyle(color: AppTheme.textMutedColor),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppTheme.spacing,
                    AppTheme.spacing,
                    AppTheme.spacing,
                    totalBottomPadding,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: AppTheme.productCardAspectRatio,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return CoffeeCard(
                        coffee: favorites[index],
                        heroPrefix: 'fav',
                      );
                    },
                  ),
                ),
    );
  }
}

