
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learning_project/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _pulseAnimation;

  bool _isNavigated = false;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.0,
          0.7,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeIn,
        ),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.4,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.4,
          0.9,
          curve: Curves.easeIn,
        ),
      ),
    );

    _pulseAnimation = Tween<double>(
      begin: 20.0,
      end: 38.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _entranceController.forward();

    // Navigate independently of notification permission.
    _navigationTimer = Timer(
      const Duration(milliseconds: 3200),
      _navigateToLogin,
    );
  }

  void _navigateToLogin() {
    if (!mounted || _isNavigated) return;

    _isNavigated = true;

    debugPrint('Splash: Opening Login Screen');

    Navigator.of(context).pushReplacementNamed(
      AppRoutes.login,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double logoSize =
    (size.width * 0.48).clamp(160.0, 220.0);
    final double innerLogoSize = logoSize * 0.7;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: -20,
              right: -20,
              child: _waveLines(),
            ),

            Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _logoScaleAnimation,
                        _pulseAnimation,
                      ]),
                      builder: (context, child) {
                        return ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: FadeTransition(
                            opacity: _logoFadeAnimation,
                            child: Container(
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFBB616),
                                  width: 2.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFBB616)
                                        .withValues(alpha: 0.3),
                                    blurRadius: _pulseAnimation.value,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: innerLogoSize,
                                  height: innerLogoSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFBB616),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        innerLogoSize * 0.1,
                                      ),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.shopping_cart,
                                            color: const Color(0xFFB32424),
                                            size: innerLogoSize * 0.45,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    SlideTransition(
                      position: _textSlideAnimation,
                      child: FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Column(
                          children: [
                            const Text(
                              'NEW',
                              style: TextStyle(
                                color: Color(0xFFB32424),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 5,
                              ),
                            ),

                            const SizedBox(height: 6),

                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Super ',
                                    style: TextStyle(
                                      color: Color(0xFFB32424),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Value',
                                    style: TextStyle(
                                      color: Color(0xFFFBB616),
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 1.2,
                                  color: const Color(0xFFB32424),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Color(0xFFFBB616),
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  height: 1.2,
                                  color: const Color(0xFFB32424),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            const Text(
                              'M A R K E T',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 4.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Column(
                  children: [
                    _bottomWaveLines(),

                    const SizedBox(height: 12),

                    const Text(
                      'Your Trusted Shopping Partner',
                      style: TextStyle(
                        color: Color(0xFFB32424),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: 120,
                      height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBB616),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _waveLines() {
    return SizedBox(
      height: 85,
      child: CustomPaint(
        painter: WavePainter(),
        size: const Size(double.infinity, 85),
      ),
    );
  }

  Widget _bottomWaveLines() {
    return SizedBox(
      height: 65,
      child: CustomPaint(
        painter: BottomWavePainter(),
        size: const Size(double.infinity, 65),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBB616).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 5; i++) {
      final path = Path();

      path.moveTo(0, 20 + i * 8);

      path.cubicTo(
        size.width * 0.25,
        i * 8,
        size.width * 0.55,
        50 + i * 8,
        size.width,
        25 + i * 8,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => false;
}

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBB616).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (int i = 0; i < 5; i++) {
      final path = Path();

      path.moveTo(0, 55 - i * 7);

      path.cubicTo(
        size.width * 0.25,
        75 - i * 7,
        size.width * 0.55,
        15 - i * 7,
        size.width,
        5 - i * 7,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BottomWavePainter oldDelegate) => false;
}
