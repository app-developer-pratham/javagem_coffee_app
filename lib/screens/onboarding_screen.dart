import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:javagem_coffee_app/core/app_transitions.dart';
import 'package:javagem_coffee_app/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _imageScaleAnimation;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _imageScaleAnimation = Tween<double>(begin: 1.06, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _headlineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOut),
      ),
    );

    _headlineSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.8, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    Navigator.of(context).pushReplacement(
      AppPageRoute(
        page: const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Background Image with scale animation & shader gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.65,
              child: AnimatedBuilder(
                animation: _imageScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _imageScaleAnimation.value,
                    alignment: Alignment.topCenter,
                    child: child,
                  );
                },
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black,
                        Colors.black26,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.7, 0.88, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    "assets/images/onboarding.png",
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Foreground Content with Staggered Entrance Animations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Headline Text
                  SlideTransition(
                    position: _headlineSlide,
                    child: FadeTransition(
                      opacity: _headlineFade,
                      child: Text(
                        "Fall in Love with Coffee in Blissful Delight!",
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),

                  // Subtitle Text
                  SlideTransition(
                    position: _subtitleSlide,
                    child: FadeTransition(
                      opacity: _subtitleFade,
                      child: Text(
                        "Welcome to our cozy coffee corner, where every cup is a delightful treat crafted for you.",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xffA2A2A2),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // "Get Started" CTA Button with press micro-interaction
                  SlideTransition(
                    position: _buttonSlide,
                    child: FadeTransition(
                      opacity: _buttonFade,
                      child: AppScaleTap(
                        onTap: _onGetStarted,
                        child: FilledButton(
                          onPressed: _onGetStarted,
                          child: const Text("Get Started"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
