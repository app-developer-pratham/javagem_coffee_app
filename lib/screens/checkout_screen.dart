import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';
import 'package:javagem_coffee_app/models/coffee.dart';
import 'package:javagem_coffee_app/screens/delivery_screen.dart';

typedef OrderScreen = CheckoutScreen;

enum OrderDeliveryMode { deliver, pickUp }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.coffee,
  });

  final CoffeeItem? coffee;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  OrderDeliveryMode _deliveryMode = OrderDeliveryMode.deliver;
  int _quantity = 1;
  String _address = 'Jl. Kpg Sutoyo';
  String _addressDetail = 'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai.';
  String? _note;
  String _paymentMethod = 'Cash/Wallet';
  bool _isPlacingOrder = false;
  String _selectedDiscount = '1 Discount Applied (Promo \$1.00 OFF)';

  static const double _originalDeliveryFee = 2.0;
  static const double _discountedDeliveryFee = 1.0;

  CoffeeItem get _coffee => widget.coffee ?? dummyCoffeeList.first;

  double get _subtotal => _coffee.price * _quantity;

  double get _deliveryFee =>
      _deliveryMode == OrderDeliveryMode.deliver ? _discountedDeliveryFee : 0.0;

  double get _totalPrice => _subtotal + _deliveryFee;

  void _showEditAddressModal() {
    final controller = TextEditingController(text: _address);
    final detailController = TextEditingController(text: _addressDetail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                topRight: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceActiveColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit Delivery Address',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Street Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailController,
                decoration: InputDecoration(
                  labelText: 'Full Address Details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppScaleTap(
                onTap: () {
                  setState(() {
                    if (controller.text.isNotEmpty) {
                      _address = controller.text;
                    }
                    if (detailController.text.isNotEmpty) {
                      _addressDetail = detailController.text;
                    }
                  });
                  Navigator.pop(ctx);
                },
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      if (controller.text.isNotEmpty) {
                        _address = controller.text;
                      }
                      if (detailController.text.isNotEmpty) {
                        _addressDetail = detailController.text;
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save Address'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddNoteModal() {
    final noteController = TextEditingController(text: _note ?? '');
    final quickNotes = [
      'Less sugar',
      'Extra hot',
      'Oat milk preferred',
      'Leave at door',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                topRight: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceActiveColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Order Note',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickNotes.map((note) {
                  return ActionChip(
                    label: Text(note, style: const TextStyle(fontSize: 12)),
                    onPressed: () {
                      noteController.text = note;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'e.g. Please ring bell upon arrival...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppScaleTap(
                onTap: () {
                  setState(() {
                    _note = noteController.text.trim().isEmpty
                        ? null
                        : noteController.text.trim();
                  });
                  Navigator.pop(ctx);
                },
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      _note = noteController.text.trim().isEmpty
                          ? null
                          : noteController.text.trim();
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Add Note'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDiscountsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                topRight: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceActiveColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Available Discounts',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(IconlyLight.discount,
                    color: AppTheme.primaryColor),
                title: const Text('Promo \$1.00 OFF',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Applied on all coffee delivery'),
                trailing: const Icon(Icons.check_circle,
                    color: AppTheme.primaryColor),
                onTap: () {
                  setState(() {
                    _selectedDiscount = '1 Discount Applied (Promo \$1.00 OFF)';
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(IconlyLight.ticket,
                    color: AppTheme.primaryColor),
                title: const Text('WELCOME20',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('20% discount for first time orders'),
                trailing: const Icon(Icons.circle_outlined),
                onTap: () {
                  setState(() {
                    _selectedDiscount = '20% OFF (WELCOME20)';
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentMethodModal() {
    final methods = [
      {'name': 'Cash/Wallet', 'subtitle': 'Balance \$48.50', 'icon': IconlyLight.wallet},
      {'name': 'Apple Pay', 'subtitle': 'Instant checkout', 'icon': Icons.apple},
      {'name': 'Credit Card', 'subtitle': '•••• 8824', 'icon': Icons.credit_card},
      {'name': 'Cash on Delivery', 'subtitle': 'Pay at your door', 'icon': Icons.attach_money},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.only(
                topLeft: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                topRight: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceActiveColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Payment Method',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              for (final method in methods)
                ListTile(
                  leading: Icon(
                    method['icon'] as IconData,
                    color: AppTheme.primaryColor,
                  ),
                  title: Text(
                    method['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(method['subtitle'] as String),
                  trailing: _paymentMethod == method['name']
                      ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                      : const Icon(Icons.circle_outlined, color: AppTheme.textMutedColor),
                  onTap: () {
                    setState(() {
                      _paymentMethod = method['name'] as String;
                    });
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _onOrderPressed() {
    if (_isPlacingOrder) return;

    setState(() {
      _isPlacingOrder = true;
    });

    // Simulate realistic order placement with smooth transition
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
        Navigator.of(context).push(
          AppPageRoute(
            page: DeliveryScreen(
              deliveryAddress: _deliveryMode == OrderDeliveryMode.deliver
                  ? _address
                  : 'Store Pick Up (Bilzen Branch)',
            ),
          ),
        );
      }
    });
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
              // Top App Bar ("Order" #421:2004)
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
                      'Order',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.2,
                        color: AppTheme.textDarkColor,
                      ),
                    ),
                    const SizedBox(width: 44, height: 44),
                  ],
                ),
              ),

              // Scrollable Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: AppTheme.spacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upper Section (Padding 24px horizontal)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Deliver / Pick Up Segmented Toggle (327x43, rx 12, padding 4)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const ShapeDecoration(
                                color: AppTheme.surfaceGreyColor,
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 12,
                                      cornerSmoothing: 0.6,
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _DeliveryTypeTab(
                                      label: 'Deliver',
                                      isSelected: _deliveryMode ==
                                          OrderDeliveryMode.deliver,
                                      onTap: () {
                                        setState(() {
                                          _deliveryMode =
                                              OrderDeliveryMode.deliver;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: _DeliveryTypeTab(
                                      label: 'Pick Up',
                                      isSelected: _deliveryMode ==
                                          OrderDeliveryMode.pickUp,
                                      onTap: () {
                                        setState(() {
                                          _deliveryMode =
                                              OrderDeliveryMode.pickUp;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Delivery Address Section with AnimatedSwitcher
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: Column(
                                key: ValueKey(_deliveryMode),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _deliveryMode == OrderDeliveryMode.deliver
                                        ? 'Delivery Address'
                                        : 'Pick Up Location',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      height: 1.5,
                                      color: AppTheme.textDarkColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _deliveryMode == OrderDeliveryMode.deliver
                                        ? _address
                                        : 'JavaGem Bilzen Store #01',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: AppTheme.textNormalColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _deliveryMode == OrderDeliveryMode.deliver
                                        ? _addressDetail
                                        : 'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai (Pick up at counter)',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 1.2,
                                      color: AppTheme.textMutedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Action Pills (Edit Address & Add Note)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _AddressActionPill(
                                  icon: IconlyLight.edit_square,
                                  label: _deliveryMode == OrderDeliveryMode.deliver
                                      ? 'Edit Address'
                                      : 'Change Branch',
                                  onTap: _showEditAddressModal,
                                ),
                                _AddressActionPill(
                                  icon: IconlyLight.document,
                                  label: _note == null
                                      ? 'Add Note'
                                      : 'Note: $_note',
                                  onTap: _showAddNoteModal,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Inset Divider Line (295px width -> 16px horizontal inset)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: AppTheme.surfaceActiveColor,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Product Item Row (54x54 image, title/subtitle, quantity stepper)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipSmoothRect(
                                  radius: const SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 8,
                                      cornerSmoothing: 0.6,
                                    ),
                                  ),
                                  child: Image.asset(
                                    _coffee.imageUrl,
                                    width: 54,
                                    height: 54,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _coffee.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          height: 1.5,
                                          color: AppTheme.textDarkColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _coffee.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 1.2,
                                          color: AppTheme.textMutedColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Quantity Stepper (- 1 +) with AnimatedSwitcher
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _QuantityStepButton(
                                      icon: Icons.remove_rounded,
                                      enabled: _quantity > 1,
                                      onTap: () {
                                        if (_quantity > 1) {
                                          setState(() {
                                            _quantity--;
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 42,
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 180),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: Text(
                                          '$_quantity',
                                          key: ValueKey(_quantity),
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            height: 1.5,
                                            color: AppTheme.textHoverColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _QuantityStepButton(
                                      icon: Icons.add_rounded,
                                      enabled: true,
                                      onTap: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Full-Bleed Section Separator Bar (4px height, #F9F2ED)
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: AppTheme.primaryLightColor,
                      ),

                      const SizedBox(height: 16),

                      // Lower Section (Padding 24px horizontal)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Discount Banner Card (327x56, rx 16, stroke #EDEDED)
                            AppScaleTap(
                              onTap: _showDiscountsModal,
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.all(16),
                                decoration: const ShapeDecoration(
                                  color: AppTheme.surfaceWhiteColor,
                                  shape: SmoothRectangleBorder(
                                    side: BorderSide(
                                      color: AppTheme.surfaceGreyColor,
                                      width: 1,
                                    ),
                                    borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(
                                        cornerRadius: 16,
                                        cornerSmoothing: 0.6,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      IconlyLight.discount,
                                      size: 20,
                                      color: AppTheme.primaryColor,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        _selectedDiscount,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          height: 1.5,
                                          color: AppTheme.textNormalColor,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      IconlyLight.arrow_right_2,
                                      size: 20,
                                      color: AppTheme.textHoverColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Payment Summary Section
                            Text(
                              'Payment Summary',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                height: 1.5,
                                color: AppTheme.textDarkColor,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Price Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AppTheme.textNormalColor,
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  child: Text(
                                    '\$ ${_subtotal.toStringAsFixed(2)}',
                                    key: ValueKey(_subtotal),
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: AppTheme.textDarkColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Delivery Fee Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Fee',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AppTheme.textNormalColor,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_deliveryMode ==
                                        OrderDeliveryMode.deliver) ...[
                                      Text(
                                        '\$ ${_originalDeliveryFee.toStringAsFixed(1)}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          height: 1.5,
                                          color: AppTheme.textHoverColor,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor:
                                              AppTheme.textHoverColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      child: Text(
                                        '\$ ${_deliveryFee.toStringAsFixed(1)}',
                                        key: ValueKey(_deliveryFee),
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          height: 1.5,
                                          color: AppTheme.textDarkColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Payment & Order Sheet (rx 16 top corners, #FFFFFF)
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Payment Method Row (Wallet icon + Cash/Wallet + Total + Chevron)
                    AppScaleTap(
                      onTap: _showPaymentMethodModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const Icon(
                              IconlyLight.wallet,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _paymentMethod,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.2,
                                      color: AppTheme.textDarkColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: Text(
                                      '\$ ${_totalPrice.toStringAsFixed(2)}',
                                      key: ValueKey(_totalPrice),
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        height: 1.5,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              IconlyLight.arrow_down_2,
                              size: 20,
                              color: AppTheme.textHoverColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Order CTA Button (327x56, rx 16, #C67C4E) with Loading State
                    SizedBox(
                      width: double.infinity,
                      child: AppScaleTap(
                        onTap: _isPlacingOrder ? null : _onOrderPressed,
                        child: FilledButton(
                          onPressed: _isPlacingOrder ? null : _onOrderPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: AppTheme.surfaceWhiteColor,
                            minimumSize: const Size.fromHeight(56),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(
                                  cornerRadius: 16,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                          ),
                          child: _isPlacingOrder
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Placing Order...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Order',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    height: 1.5,
                                    color: AppTheme.surfaceWhiteColor,
                                  ),
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

class _DeliveryTypeTab extends StatelessWidget {
  const _DeliveryTypeTab({
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 35,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          shape: const SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(
                cornerRadius: 8,
                cornerSmoothing: 0.6,
              ),
            ),
          ),
        ),
        child: Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
            height: 1.2,
            color: isSelected
                ? AppTheme.surfaceWhiteColor
                : AppTheme.textDarkColor,
          ),
        ),
      ),
    );
  }
}

class _AddressActionPill extends StatelessWidget {
  const _AddressActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppScaleTap(
      onTap: onTap,
      scaleDown: 0.94,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.surfaceActiveColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppTheme.textNormalColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.2,
                color: AppTheme.textNormalColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepButton extends StatelessWidget {
  const _QuantityStepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppScaleTap(
      scaleDown: 0.88,
      onTap: enabled ? onTap : null,
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhiteColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? AppTheme.primaryLightColor
                : AppTheme.surfaceActiveColor,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppTheme.textHoverColor : AppTheme.textMutedColor,
        ),
      ),
    );
  }
}
