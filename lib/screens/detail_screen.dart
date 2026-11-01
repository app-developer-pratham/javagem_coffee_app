import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/screens/checkout_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.coffee,
  });

  final CoffeeItem coffee;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  CoffeeSize _selectedSize = CoffeeSize.m;
  late bool _isFavorite;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.coffee.isFavorite;
  }

  String _sizeLabel(CoffeeSize size) {
    switch (size) {
      case CoffeeSize.s:
        return 'S';
      case CoffeeSize.m:
        return 'M';
      case CoffeeSize.l:
        return 'L';
    }
  }

  String _badgeAsset(String badge) {
    switch (badge) {
      case 'delivery':
        return 'assets/icons/ic_bike.png';
      case 'coffee_bean':
        return 'assets/icons/ic_bean.png';
      case 'milk':
        return 'assets/icons/ic_milk.png';
      default:
        return 'assets/icons/ic_bean.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceLightColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top App Bar ("Detail" #421:1886)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacing,
                  16,
                  AppTheme.spacing,
                  16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TopActionButton(
                      onTap: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        IconlyLight.arrow_left_2,
                        size: 24,
                        color: AppTheme.textHoverColor,
                      ),
                    ),
                    Text(
                      'Detail',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.2,
                        color: AppTheme.textDarkColor,
                      ),
                    ),
                    _TopActionButton(
                      onTap: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      icon: Icon(
                        _isFavorite ? IconlyBold.heart : IconlyLight.heart,
                        size: 24,
                        color: _isFavorite
                            ? AppTheme.primaryColor
                            : AppTheme.textHoverColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacing,
                    8,
                    AppTheme.spacing,
                    AppTheme.spacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image (#421:1885: 327x202, radius 16)
                      AspectRatio(
                        aspectRatio: AppTheme.detailImageAspectRatio,
                        child: ClipSmoothRect(
                          radius: const SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: 16,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                          child: Image.asset(
                            widget.coffee.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Detail Product Info & Superiority Badges (#421:1864)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title, Subtitle & Rating (#421:1866)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.coffee.name,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    height: 1.5,
                                    color: AppTheme.textDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.coffee.subtitle,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    height: 1.2,
                                    color: AppTheme.textMutedColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Rating (#421:1870)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/icons/ic_star.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    RichText(
                                      text: TextSpan(
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppTheme.textHoverColor,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${widget.coffee.rating} ',
                                          ),
                                          TextSpan(
                                            text:
                                                '(${widget.coffee.reviewCount})',
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color:
                                                      AppTheme.textMutedColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Superiority Badges (#421:1877: 44x44 containers, 12px gap, 12px radius)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 12,
                            children: [
                              for (final badge
                                  in (widget.coffee.iconBadges.isNotEmpty
                                      ? widget.coffee.iconBadges
                                      : const [
                                          'delivery',
                                          'coffee_bean',
                                          'milk',
                                        ]))
                                Container(
                                  width: 44,
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: AppTheme.iconBadgeBgColor,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 12,
                                        cornerSmoothing: 0.6,
                                      ),
                                    ),
                                  ),
                                  child: Image.asset(
                                    _badgeAsset(badge),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Divider Line (#421:1884: #E3E3E3, 1px)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: AppTheme.surfaceActiveColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description Section (#421:1861)
                      Text(
                        'Description',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.textDarkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            height: 1.5,
                            color: AppTheme.textMutedColor,
                          ),
                          children: [
                            TextSpan(
                              text: _isDescriptionExpanded
                                  ? '${widget.coffee.description} Crafted with carefully roasted 100% Arabica beans and steamed milk for a smooth, velvety finish. '
                                  : '${widget.coffee.description} ',
                            ),
                            TextSpan(
                              text: _isDescriptionExpanded
                                  ? 'Read Less'
                                  : 'Read More',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.5,
                                color: AppTheme.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    _isDescriptionExpanded =
                                        !_isDescriptionExpanded;
                                  });
                                },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Size Selector Section (#421:1852)
                      Text(
                        'Size',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.5,
                          color: AppTheme.textDarkColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        spacing: 16,
                        children: [
                          for (final size in widget.coffee.availableSizes)
                            Expanded(
                              child: _SizeChoiceButton(
                                label: _sizeLabel(size),
                                isSelected: _selectedSize == size,
                                onTap: () {
                                  setState(() {
                                    _selectedSize = size;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar (#421:1846)
              Container(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacing,
                  16,
                  AppTheme.spacing,
                  bottomPadding > 0 ? bottomPadding + 12 : 24,
                ),
                decoration: const ShapeDecoration(
                  color: AppTheme.surfaceWhiteColor,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                      topLeft: SmoothRadius(
                        cornerRadius: 16,
                        cornerSmoothing: 0.6,
                      ),
                      topRight: SmoothRadius(
                        cornerRadius: 16,
                        cornerSmoothing: 0.6,
                      ),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 24,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Price Column (#421:1847)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.2,
                            color: AppTheme.textGreyHoverColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$ ${widget.coffee.price.toStringAsFixed(2)}',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 1.5,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 34),

                    // Buy Now CTA (#421:1850)
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutScreen(coffee: widget.coffee),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.surfaceWhiteColor,
                          minimumSize: const Size.fromHeight(56),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 16,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        ),
                        child: Text(
                          'Buy Now',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.5,
                            color: AppTheme.surfaceWhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.onTap,
  });

  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: icon,
        ),
      ),
    );
  }
}

class _SizeChoiceButton extends StatelessWidget {
  const _SizeChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 41,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: isSelected
                ? AppTheme.primaryLightColor
                : AppTheme.surfaceWhiteColor,
            shape: SmoothRectangleBorder(
              side: BorderSide(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.surfaceActiveColor,
                width: 1,
              ),
              borderRadius: SmoothBorderRadius(
                cornerRadius: 12,
                cornerSmoothing: 0.6,
              ),
            ),
          ),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.5,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textDarkColor,
            ),
          ),
        ),
      ),
    );
  }
}
