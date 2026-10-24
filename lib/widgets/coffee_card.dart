import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:javagem_coffee_app/models/coffee.dart';

class CoffeeCard extends StatelessWidget {
  const CoffeeCard({
    super.key,
    required this.coffee,
  });
  final CoffeeItem coffee;
  @override
  Widget build(BuildContext context) {
    const double cornerSmoothing = 1;
    const double cornerRadius = 16;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: cornerRadius,
            cornerSmoothing: cornerSmoothing,
          ),
        ),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.1,
              child: ClipSmoothRect(
                radius: SmoothBorderRadius.all(
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
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
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
                        SizedBox(height: constraints.maxHeight * 0.025),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "\$${coffee.price}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: constraints.maxHeight * 0.18,
                                ),
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                fixedSize: Size.square(
                                  constraints.maxHeight * 0.40,
                                ),
                              ),
                              iconSize: constraints.maxHeight * 0.2,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
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
    );
  }
}
