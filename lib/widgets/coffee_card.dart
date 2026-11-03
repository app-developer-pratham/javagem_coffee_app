import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/screens/detail_screen.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({
    super.key,
    required this.coffee,
    this.heroPrefix = 'grid',
  });

  final CoffeeItem coffee;
  final String heroPrefix;

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      AppPageRoute(
        page: DetailScreen(
          coffee: coffee,
          heroTag: '$heroPrefix-coffee-image-${coffee.id}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double cornerSmoothing = 1;
    const double cornerRadius = 16;
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

    return CupertinoContextMenu.builder(
      actions: [
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.cart_badge_plus,
          child: Text('Add to Cart', style: textTheme.bodyLarge),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.slider_horizontal_3,
          child: Text('Customize', style: textTheme.bodyLarge),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.heart,
          child: Text('Add to Favorites', style: textTheme.bodyLarge),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.share,
          child: Text('Share', style: textTheme.bodyLarge),
        ),
      ],
      builder: (context, animation) {
        return AppScaleTap(
          onTap: () => _navigateToDetail(context),
          scaleDown: 0.97,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.45,
            ),
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
                  shadows: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Coffee Image
                      Hero(
                        tag: '$heroPrefix-coffee-image-${coffee.id}',
                        child: AspectRatio(
                          aspectRatio: 1.1,
                          child: ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(
                              SmoothRadius(
                                cornerRadius: cornerRadius,
                                cornerSmoothing: cornerSmoothing,
                              ),
                            ),
                            child: Image.asset(
                              coffee.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coffee.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: constraints.maxHeight * 0.18,
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.025,
                                  ),
                                  Text(
                                    coffee.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontSize: constraints.maxHeight * 0.15,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "\$${coffee.price.toStringAsFixed(2)}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                constraints.maxHeight * 0.18,
                                          ),
                                        ),
                                      ),
                                      AppScaleTap(
                                        scaleDown: 0.90,
                                        onTap: () => _navigateToDetail(context),
                                        child: Container(
                                          width: constraints.maxHeight * 0.40,
                                          height: constraints.maxHeight * 0.40,
                                          decoration: const ShapeDecoration(
                                            color: AppTheme.primaryColor,
                                            shape: SmoothRectangleBorder(
                                              borderRadius: SmoothBorderRadius.all(
                                                SmoothRadius(
                                                  cornerRadius: 10,
                                                  cornerSmoothing: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
