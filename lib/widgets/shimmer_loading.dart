import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable Shimmer container matching the app's palette
class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xffE6E6E6),
      highlightColor: highlightColor ?? const Color(0xffF7F7F7),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// Dark shimmer for top navbar header elements on dark gradient
class AppDarkShimmer extends StatelessWidget {
  final Widget child;

  const AppDarkShimmer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xff2A2A2A),
      highlightColor: const Color(0xff404040),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// Skeleton for Location selector on dark background
class LocationHeaderSkeleton extends StatelessWidget {
  const LocationHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDarkShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 140,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for Promo Banner
class PromoBannerSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const PromoBannerSkeleton({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6),
        ),
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Skeleton for Category Choice Chips
class CategoryChipsSkeleton extends StatelessWidget {
  const CategoryChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final chipWidths = [90.0, 75.0, 60.0, 85.0, 70.0];
    return AppShimmer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing),
        child: Row(
          children: [
            for (int i = 0; i < chipWidths.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipSmoothRect(
                  radius: const SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 8, cornerSmoothing: 1.0),
                  ),
                  child: Container(
                    width: chipWidths[i],
                    height: 38,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for single Coffee Card on the grid
class CoffeeCardSkeleton extends StatelessWidget {
  const CoffeeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const double cornerSmoothing = 1.0;
    const double cornerRadius = 16.0;

    return AppShimmer(
      child: AspectRatio(
        aspectRatio: AppTheme.productCardAspectRatio,
        child: Container(
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: cornerRadius,
                  cornerSmoothing: cornerSmoothing,
                ),
              ),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image skeleton
              AspectRatio(
                aspectRatio: 1.1,
                child: ClipSmoothRect(
                  radius: const SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: cornerRadius,
                      cornerSmoothing: cornerSmoothing,
                    ),
                  ),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title bar
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Subtitle bar
                      Container(
                        width: 70,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      // Bottom row: price and button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(
                              SmoothRadius(
                                cornerRadius: 10,
                                cornerSmoothing: 1.0,
                              ),
                            ),
                            child: Container(
                              width: 32,
                              height: 32,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer Grid showing multiple CoffeeCardSkeletons
class CoffeeGridSkeleton extends StatelessWidget {
  final int itemCount;

  const CoffeeGridSkeleton({
    super.key,
    this.itemCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: AppTheme.productCardAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const CoffeeCardSkeleton();
      },
    );
  }
}

