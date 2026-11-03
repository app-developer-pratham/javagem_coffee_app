import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly_plus/iconly.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({
    super.key,
    this.deliveryAddress = 'Jl. Kpg Sutoyo',
  });

  final String deliveryAddress;

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _sheetEntranceController;
  late final Animation<Offset> _sheetSlideAnimation;
  late final Animation<double> _progressBarAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse radar animation for courier marker
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Bottom sheet entrance animation
    _sheetEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _sheetSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _sheetEntranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _progressBarAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _sheetEntranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _sheetEntranceController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sheetEntranceController.dispose();
    super.dispose();
  }

  void _showCallModal() {
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
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceActiveColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ClipSmoothRect(
                radius: const SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.6),
                ),
                child: Image.asset(
                  'assets/images/courier_avatar.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Brooklyn Simmons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Personal Courier (+62 812 3456 7890)',
                style: TextStyle(color: AppTheme.textMutedColor, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppScaleTap(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_end, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 32),
                  AppScaleTap(
                    onTap: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Connected with courier Brooklyn'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xff36C07E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceLightColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed Map with Route, Destination Pin & Animated Courier Marker
            Positioned.fill(
              child: _DeliveryMapCanvas(pulseAnimation: _pulseController),
            ),

            // Top Floating Navigation & GPS Buttons (#421:2268)
            Positioned(
              top: mediaQuery.padding.top + 24,
              left: AppTheme.spacing,
              right: AppTheme.spacing,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MapFloatingButton(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(
                      IconlyLight.arrow_left_2,
                      size: 24,
                      color: AppTheme.textHoverColor,
                    ),
                  ),
                  _MapFloatingButton(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tracking centered on delivery courier'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const CustomPaint(
                      size: Size(24, 24),
                      painter: _GpsTargetIconPainter(
                        color: AppTheme.textHoverColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Delivery Tracking Sheet (#421:2234) with slide-up entrance
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _sheetSlideAnimation,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    AppTheme.spacing,
                    16,
                    AppTheme.spacing,
                    bottomPadding > 0 ? bottomPadding + 16 : 36,
                  ),
                  decoration: const ShapeDecoration(
                    color: AppTheme.surfaceWhiteColor,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius.only(
                        topLeft: SmoothRadius(
                          cornerRadius: 24,
                          cornerSmoothing: 0.6,
                        ),
                        topRight: SmoothRadius(
                          cornerRadius: 24,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 28,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag Indicator Handle (45x5, rx 2.5, #E3E3E3)
                      Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceActiveColor,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Remaining Time Title ("10 minutes left" + Live pulse indicator)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xff36C07E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '10 minutes left',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.5,
                              color: AppTheme.textDarkColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Delivery Destination Subtitle
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.5,
                            color: AppTheme.textMutedColor,
                          ),
                          children: [
                            const TextSpan(text: 'Delivery to '),
                            TextSpan(
                              text: widget.deliveryAddress,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                height: 1.5,
                                color: AppTheme.textHoverColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Animated 4-Segment Progress Bar
                      AnimatedBuilder(
                        animation: _progressBarAnimation,
                        builder: (context, _) {
                          final currentProgress = _progressBarAnimation.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: List.generate(4, (index) {
                                final isCompleted = index < currentProgress;
                                return Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: EdgeInsets.only(
                                      right: index < 3 ? 10 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? const Color(0xff36C07E)
                                          : AppTheme.surfaceActiveColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Order Status Card ("Delivered your order")
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: const ShapeDecoration(
                          color: AppTheme.surfaceWhiteColor,
                          shape: SmoothRectangleBorder(
                            side: BorderSide(
                              color: AppTheme.surfaceActiveColor,
                              width: 1,
                            ),
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
                            // Scooter Icon Box with subtle bobbing
                            Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: const ShapeDecoration(
                                color: AppTheme.surfaceWhiteColor,
                                shape: SmoothRectangleBorder(
                                  side: BorderSide(
                                    color: AppTheme.surfaceActiveColor,
                                    width: 1,
                                  ),
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 12,
                                      cornerSmoothing: 0.6,
                                    ),
                                  ),
                                ),
                              ),
                              child: Transform.flip(
                                flipX: true,
                                child: Image.asset(
                                  'assets/icons/ic_delivery_scooter.png',
                                  width: 27.5,
                                  height: 27.5,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Delivering your order',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.5,
                                      color: AppTheme.textDarkColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'We will deliver your goods to you in the shortest possible time.',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      height: 1.5,
                                      color: AppTheme.textMutedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Courier Profile Row ("Brooklyn Simmons" / "Personal Courier")
                      Row(
                        children: [
                          ClipSmoothRect(
                            radius: const SmoothBorderRadius.all(
                              SmoothRadius(
                                cornerRadius: 14,
                                cornerSmoothing: 0.6,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/courier_avatar.png',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Brooklyn Simmons',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    height: 1.5,
                                    color: AppTheme.textDarkColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Personal Courier',
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
                          // Call Action Button with AppScaleTap
                          AppScaleTap(
                            onTap: _showCallModal,
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: const ShapeDecoration(
                                color: AppTheme.surfaceWhiteColor,
                                shape: SmoothRectangleBorder(
                                  side: BorderSide(
                                    color: AppTheme.surfaceActiveColor,
                                    width: 1,
                                  ),
                                  borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(
                                      cornerRadius: 12,
                                      cornerSmoothing: 0.6,
                                    ),
                                  ),
                                ),
                              ),
                              child: const Icon(
                                IconlyLight.calling,
                                size: 24,
                                color: AppTheme.textHoverColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapFloatingButton extends StatelessWidget {
  const _MapFloatingButton({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppScaleTap(
      onTap: onTap,
      scaleDown: 0.92,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
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
          shadows: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _DeliveryMapCanvas extends StatelessWidget {
  const _DeliveryMapCanvas({required this.pulseAnimation});

  final Animation<double> pulseAnimation;

  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final fittedSizes = applyBoxFit(
          BoxFit.cover,
          const Size(_designWidth, _designHeight),
          size,
        );
        final renderSize = fittedSizes.destination;
        final dx = (size.width - renderSize.width) / 2;
        final dy = (size.height - renderSize.height) / 2;
        final scaleX = renderSize.width / _designWidth;
        final scaleY = renderSize.height / _designHeight;

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: dx,
              top: dy,
              width: renderSize.width,
              height: renderSize.height,
              child: Image.asset(
                'assets/images/delivery_map.png',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              left: dx,
              top: dy,
              width: renderSize.width,
              height: renderSize.height,
              child: CustomPaint(
                painter: _RouteAndPinPainter(
                  scaleX: scaleX,
                  scaleY: scaleY,
                ),
              ),
            ),
            // Courier Radar wave + Pin Badge at (x: 233, y: 311)
            Positioned(
              left: dx + (233 * scaleX) - 16,
              top: dy + (311 * scaleY) - 16,
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, _) {
                  final pulseValue = pulseAnimation.value;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Expanding Radar Ripple
                      Container(
                        width: 40 + (32 * pulseValue),
                        height: 40 + (32 * pulseValue),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withValues(
                            alpha: (1.0 - pulseValue) * 0.35,
                          ),
                        ),
                      ),
                      // Inner Courier Icon Badge
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppTheme.surfaceWhiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x40B8B8B8),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icons/ic_delivery_scooter.png',
                          width: 18,
                          height: 18,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RouteAndPinPainter extends CustomPainter {
  const _RouteAndPinPainter({
    required this.scaleX,
    required this.scaleY,
  });

  final double scaleX;
  final double scaleY;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(scaleX, scaleY);

    // 1. Route Polyline: M252 311V168.5L240 174L120 180.5V204.5L95 206L97 236L81.5 237
    final routePath = Path()
      ..moveTo(252, 311)
      ..lineTo(252, 168.5)
      ..lineTo(240, 174)
      ..lineTo(120, 180.5)
      ..lineTo(120, 204.5)
      ..lineTo(95, 206)
      ..lineTo(97, 236)
      ..lineTo(81.5, 237);

    // Outer subtle glow
    final glowPaint = Paint()
      ..color = AppTheme.primaryColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(routePath, glowPaint);

    final routePaint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(routePath, routePaint);

    // 2. Destination Pin Shadow Ellipse (cx: 78, cy: 232, rx: 5, ry: 1)
    final shadowPaint = Paint()
      ..color = AppTheme.primaryColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(78, 232),
        width: 10,
        height: 2,
      ),
      shadowPaint,
    );

    // 3. Destination Location Pin (#421:2264)
    final pinPath = Path()
      ..fillType = PathFillType.evenOdd
      ..moveTo(74.5316, 213.937)
      ..cubicTo(76.7165, 212.667, 79.402, 212.689, 81.5664, 213.995)
      ..cubicTo(83.7095, 215.327, 85.012, 217.704, 84.9998, 220.261)
      ..cubicTo(84.95, 222.802, 83.5533, 225.19, 81.8075, 227.036)
      ..cubicTo(80.7998, 228.106, 79.6726, 229.053, 78.4488, 229.856)
      ..cubicTo(78.3228, 229.929, 78.1847, 229.978, 78.0415, 230.0)
      ..cubicTo(77.9036, 229.994, 77.7693, 229.953, 77.6508, 229.881)
      ..cubicTo(75.7824, 228.675, 74.1433, 227.134, 72.8123, 225.334)
      ..cubicTo(71.6986, 223.831, 71.0658, 222.016, 71.0, 220.134)
      ..cubicTo(70.9986, 217.572, 72.3468, 215.206, 74.5316, 213.937)
      ..close()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(78.0, 220.28),
          radius: 2.38,
        ),
      );

    final pinPaint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(pinPath, pinPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RouteAndPinPainter oldDelegate) {
    return oldDelegate.scaleX != scaleX || oldDelegate.scaleY != scaleY;
  }
}

class _GpsTargetIconPainter extends CustomPainter {
  const _GpsTargetIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer circle (radius 7.5) & inner circle (radius 3)
    canvas.drawCircle(center, 7.5, paint);
    canvas.drawCircle(center, 3.0, paint);

    // 4 directional ticks
    canvas.drawLine(
      Offset(center.dx, center.dy - 8),
      Offset(center.dx, center.dy - 10),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 8),
      Offset(center.dx, center.dy + 10),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - 8, center.dy),
      Offset(center.dx - 10, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + 8, center.dy),
      Offset(center.dx + 10, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GpsTargetIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
