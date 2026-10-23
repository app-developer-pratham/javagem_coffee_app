import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:javagem_coffee_app/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
            ShaderMask(
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
                  stops: [
                    0.0,
                    0.8,
                    0.9,
                    1.0,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                "assets/images/onboarding.png",
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Fall in Love with Coffee in Blissful Delight!",
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Welcome to our cozy coffee corner, where every cup is a delightful for you.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Color(0xffA2A2A2),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ),
                      );
                    },
                    child: Text("Get Started"),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
