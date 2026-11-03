import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/screens/checkout_screen.dart';
import 'package:javagem_coffee_app/widgets/shimmer_loading.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  bool _isLoading = true;
  int _qty1 = 1;
  int _qty2 = 2;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  double get _totalPrice {
    final p1 = dummyCoffeeList[0].price * _qty1;
    final p2 = dummyCoffeeList[1].price * _qty2;
    return p1 + p2 + 1.0; // include delivery
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalBottomPadding = bottomInset + 90.0 + AppTheme.spacing;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Cart',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppTheme.textDarkColor,
              ),
        ),
      ),
      body: _isLoading
          ? Padding(
              padding: const EdgeInsets.all(AppTheme.spacing),
              child: Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AppShimmer(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacing,
                8,
                AppTheme.spacing,
                totalBottomPadding,
              ),
              child: Column(
                children: [
                  _CartItemTile(
                    coffee: dummyCoffeeList[0],
                    quantity: _qty1,
                    onQtyChanged: (q) => setState(() => _qty1 = q),
                  ),
                  const SizedBox(height: 12),
                  _CartItemTile(
                    coffee: dummyCoffeeList[1],
                    quantity: _qty2,
                    onQtyChanged: (q) => setState(() => _qty2 = q),
                  ),
                  const SizedBox(height: 24),
                  // Order Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal',
                                style: TextStyle(color: AppTheme.textNormalColor)),
                            Text(
                              '\$ ${(_totalPrice - 1.0).toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Fee',
                                style: TextStyle(color: AppTheme.textNormalColor)),
                            Text('\$ 1.00',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$ ${_totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppScaleTap(
                    onTap: () {
                      Navigator.of(context).push(
                        AppPageRoute(
                          page: CheckoutScreen(coffee: dummyCoffeeList[0]),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            AppPageRoute(
                              page: CheckoutScreen(coffee: dummyCoffeeList[0]),
                            ),
                          );
                        },
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CoffeeItem coffee;
  final int quantity;
  final ValueChanged<int> onQtyChanged;

  const _CartItemTile({
    required this.coffee,
    required this.quantity,
    required this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6),
          ),
        ),
      ),
      child: Row(
        children: [
          ClipSmoothRect(
            radius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 12, cornerSmoothing: 0.6),
            ),
            child: Image.asset(
              coffee.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coffee.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  coffee.subtitle,
                  style: const TextStyle(color: AppTheme.textMutedColor, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$ ${(coffee.price * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              AppScaleTap(
                scaleDown: 0.88,
                onTap: quantity > 1 ? () => onQtyChanged(quantity - 1) : null,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surfaceActiveColor),
                  ),
                  child: const Icon(Icons.remove, size: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$quantity',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              AppScaleTap(
                scaleDown: 0.88,
                onTap: () => onQtyChanged(quantity + 1),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surfaceActiveColor),
                  ),
                  child: const Icon(Icons.add, size: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

