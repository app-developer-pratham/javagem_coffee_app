import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';
import 'package:javagem_coffee_app/screens/delivery_screen.dart';
import 'package:javagem_coffee_app/widgets/shimmer_loading.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({super.key});

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  bool _isLoading = true;

  final notifications = [
    {
      'title': 'Your Order is on the Way!',
      'body': 'Courier Brooklyn Simmons is heading to Jl. Kpg Sutoyo with your Caffe Mocha.',
      'time': '5m ago',
      'icon': Icons.delivery_dining_outlined,
      'isOrder': true,
      'unread': true,
    },
    {
      'title': 'Buy 1 Get 1 Free Promo!',
      'body': 'Enjoy a complimentary iced latte with any handcrafted beverage order today.',
      'time': '2h ago',
      'icon': IconlyLight.discount,
      'isOrder': false,
      'unread': true,
    },
    {
      'title': 'Order #8491 Delivered',
      'body': 'Your order has been delivered safely. Hope you enjoy every sip!',
      'time': 'Yesterday',
      'icon': IconlyLight.tick_square,
      'isOrder': false,
      'unread': false,
    },
  ];

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

    return Scaffold(
      backgroundColor: AppTheme.surfaceLightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
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
                          height: 76,
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
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                AppTheme.spacing,
                8,
                AppTheme.spacing,
                totalBottomPadding,
              ),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isUnread = item['unread'] as bool;
                final isOrder = item['isOrder'] as bool;

                return AppScaleTap(
                  onTap: () {
                    if (isOrder) {
                      Navigator.of(context).push(
                        AppPageRoute(
                          page: const DeliveryScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: isUnread
                          ? AppTheme.primaryLightColor.withValues(alpha: 0.5)
                          : Colors.white,
                      shape: const SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(cornerRadius: 16, cornerSmoothing: 0.6),
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const ShapeDecoration(
                            color: AppTheme.primaryLightColor,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(
                                    cornerRadius: 12, cornerSmoothing: 0.6),
                              ),
                            ),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: AppTheme.primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item['time'] as String,
                                    style: const TextStyle(
                                      color: AppTheme.textMutedColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['body'] as String,
                                style: const TextStyle(
                                  color: AppTheme.textMutedColor,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                              if (isOrder) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  'Tap to track live order →',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
