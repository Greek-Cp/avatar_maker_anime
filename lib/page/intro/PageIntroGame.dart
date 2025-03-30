import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:avatar_maker/page/PageBase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Splash Screen - First screen users see when opening the app
class SplashScreen extends StatefulWidget {
  static String routeName = "/SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for splash effects
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Colors from your PageBase
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color purpleColor = Color(0xFF9F6CF7);
  final Color blueColor = Color(0xFF5EBAF2);
  final Color orangeColor = Color(0xFFFFB347);
  final Color backgroundColor = Color(0xFFFFF0F5);

  @override
  void initState() {
    super.initState();

    // Set up animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Check if intro has been shown before and navigate accordingly
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    // Wait for splash animation
    await Future.delayed(Duration(milliseconds: 3000));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showIntro = prefs.getBool('showIntro') ?? true;

    if (showIntro) {
      Get.offAllNamed(IntroScreen.routeName);
    } else {
      Get.offAllNamed(PageBase.routeName);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              purpleColor.withOpacity(0.2),
              backgroundColor,
              primaryColor.withOpacity(0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            ..._buildBackgroundParticles(size),

            // Logo and app name
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App Logo
                          Container(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  primaryColor,
                                  accentColor,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 15,
                                  spreadRadius: -5,
                                  offset: Offset(-5, -5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.face_retouching_natural,
                              color: Colors.white,
                              size: size.width * 0.2,
                            ),
                          ),

                          SizedBox(height: 30),

                          // App name with gradient
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [accentColor, purpleColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              "Anime Avatar Maker",
                              style: TextStyle(
                                fontSize: size.width * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          // Tagline with glass container
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  "Create Your Perfect Anime Avatar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                        color: accentColor.withOpacity(0.7),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  List<Widget> _buildBackgroundParticles(Size size) {
    return List.generate(20, (index) {
      final random = math.Random(index * 5);
      final particleSize = 10.0 + random.nextDouble() * 20;
      final xPos = random.nextDouble() * size.width;
      final yPos = random.nextDouble() * size.height;
      final color =
          [primaryColor, purpleColor, blueColor, orangeColor][index % 4];

      return Positioned(
        left: xPos,
        top: yPos,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final progress = _animationController.value;
            final opacity = (progress < 0.3)
                ? progress / 0.3
                : (progress > 0.8)
                    ? (1 - (progress - 0.8) / 0.2)
                    : 1.0;

            return Opacity(
              opacity: opacity * 0.6,
              child: Container(
                width: particleSize,
                height: particleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

// Intro Screen with anime-themed walkthrough
class IntroScreen extends StatefulWidget {
  static String routeName = "/IntroScreen";

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _backgroundAnimController;
  late AnimationController _buttonsAnimController;
  final int _totalPages = 3;
  int _currentPage = 0;

  // Colors from your PageBase
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color purpleColor = Color(0xFF9F6CF7);
  final Color blueColor = Color(0xFF5EBAF2);
  final Color orangeColor = Color(0xFFFFB347);
  final Color backgroundColor = Color(0xFFFFF0F5);

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 20000),
    )..repeat();

    _buttonsAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimController.dispose();
    _buttonsAnimController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Reset and forward button animation on each page change
    _buttonsAnimController.reset();
    _buttonsAnimController.forward();
  }

  void _finishIntro() async {
    // Save that intro has been shown
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showIntro', false);

    // Navigate to main app
    Get.offAllNamed(PageBase.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _backgroundAnimController,
            builder: (context, child) {
              final angle = _backgroundAnimController.value * 2 * math.pi;

              return Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(math.cos(angle), math.sin(angle)),
                    end: Alignment(
                        math.cos(angle + math.pi), math.sin(angle + math.pi)),
                    colors: [
                      purpleColor.withOpacity(0.2),
                      backgroundColor,
                      primaryColor.withOpacity(0.3),
                      blueColor.withOpacity(0.2),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating bubbles
          ..._buildFloatingBubbles(size),

          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _buildIntroPage(
                        size,
                        "Create Your Avatar",
                        "Design your unique anime character with hundreds of customization options.",
                        Icons.brush_rounded,
                        primaryColor,
                      ),
                      _buildIntroPage(
                        size,
                        "Save & Share",
                        "Save your creations to your gallery and share them with friends.",
                        Icons.share_rounded,
                        purpleColor,
                      ),
                      _buildIntroPage(
                        size,
                        "Have Fun!",
                        "Enjoy creating endless anime avatars with exciting features.",
                        Icons.sentiment_very_satisfied_rounded,
                        blueColor,
                      ),
                    ],
                  ),
                ),

                // Bottom navigation
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page indicators
                      Row(
                        children: List.generate(
                          _totalPages,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.only(right: 8),
                            height: 12,
                            width: _currentPage == index ? 30 : 12,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? accentColor
                                  : accentColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: _currentPage == index
                                  ? [
                                      BoxShadow(
                                        color: accentColor.withOpacity(0.5),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ),

                      // Button
                      AnimatedBuilder(
                        animation: _buttonsAnimController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.8 + (_buttonsAnimController.value * 0.2),
                            child: GestureDetector(
                              onTap: () {
                                if (_currentPage < _totalPages - 1) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _finishIntro();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primaryColor,
                                      accentColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _currentPage < _totalPages - 1
                                          ? "Next"
                                          : "Start",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      _currentPage < _totalPages - 1
                                          ? Icons.arrow_forward_rounded
                                          : Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(
      Size size, String title, String description, IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _buttonsAnimController,
      builder: (context, child) {
        return Opacity(
          opacity: _buttonsAnimController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _buttonsAnimController.value)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enhanced animated avatar illustration
                  Container(
                    width: size.width * 0.75,
                    height: size.width * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                        radius: 0.8,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsating inner glow
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.7, end: 1.0),
                          duration: Duration(milliseconds: 2000),
                          curve: Curves.easeInOut,
                          builder: (context, double value, child) {
                            return Container(
                              width: size.width * 0.6 * value,
                              height: size.width * 0.6 * value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    color.withOpacity(0.8),
                                    color.withOpacity(0.0),
                                  ],
                                  radius: 0.6,
                                ),
                              ),
                            );
                          },
                          onEnd: () => setState(() {}),
                        ),

                        // Inner ring effect
                        AnimatedBuilder(
                          animation: _backgroundAnimController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle:
                                  _backgroundAnimController.value * math.pi * 2,
                              child: Container(
                                width: size.width * 0.5,
                                height: size.width * 0.5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 1.5,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Stylized icon with background
                        Container(
                          width: size.width * 0.28,
                          height: size.width * 0.28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withOpacity(1.0),
                                color.withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 15,
                                offset: Offset(4, 4),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: -5,
                                offset: Offset(-3, -3),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            size: size.width * 0.16,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),

                        // Enhanced orbiting particles
                        ..._buildOrbitingParticles(size.width * 0.37, color),

                        // Secondary orbiting ring with sparkles
                        ..._buildSparkleRing(size.width * 0.33, color),
                      ],
                    ),
                  ),

                  SizedBox(height: 50),

                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [color, accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Description
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildFloatingBubbles(Size size) {
    // Increased number of bubbles
    return List.generate(30, (index) {
      final random = math.Random(index * 7);

      // More variation in bubble sizes
      final bubbleSizeCategory = index % 3; // 0 = small, 1 = medium, 2 = large
      double bubbleSize;

      switch (bubbleSizeCategory) {
        case 0: // Small bubbles
          bubbleSize = 3.0 + random.nextDouble() * 7;
          break;
        case 1: // Medium bubbles
          bubbleSize = 10.0 + random.nextDouble() * 10;
          break;
        case 2: // Large bubbles
          bubbleSize = 20.0 + random.nextDouble() * 15;
          break;
        default:
          bubbleSize = 10.0;
      }

      // Position bubbles throughout the screen
      final xPos = random.nextDouble() * size.width;
      final yPos = random.nextDouble() * size.height;

      // Varied bubble colors with gradients
      final colorIndex = index % 4;
      final color =
          [primaryColor, purpleColor, blueColor, orangeColor][colorIndex];
      final secondaryColor = [
        accentColor,
        Color(0xFF7B4FC9),
        Color(0xFF20A0E8),
        Color(0xFFFF9900)
      ][colorIndex];

      // Varied animation durations for more natural movement
      final duration = 12000 + random.nextInt(15000);

      // Different starting points for animations
      final startValue = random.nextDouble();

      return Positioned(
        left: xPos,
        top: yPos,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: startValue, end: startValue + 1),
          duration: Duration(milliseconds: duration),
          curve: Curves.linear,
          builder: (context, double value, child) {
            // More complex movement patterns
            final normalizedValue = value % 1.0;
            final wobbleAmount = bubbleSizeCategory == 2
                ? 5.0
                : (bubbleSizeCategory == 1 ? 15.0 : 30.0);

            return Transform.translate(
              offset: Offset(
                math.sin(normalizedValue * math.pi * 2 + index) * wobbleAmount,
                -normalizedValue * size.height * 0.7 -
                    bubbleSize, // Rising effect
              ),
              child: Opacity(
                opacity: (0.2 + random.nextDouble() * 0.3) *
                    // Fade out as bubbles reach the top
                    (1.0 - math.pow(normalizedValue, 2) * 0.7),
                child: Container(
                  width: bubbleSize,
                  height: bubbleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.9),
                        secondaryColor.withOpacity(0.5),
                      ],
                      center: Alignment(0.3, -0.3), // Off-center for 3D effect
                      radius: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  // Add shine effect to larger bubbles
                  child: bubbleSizeCategory >= 1
                      ? Stack(
                          children: [
                            Positioned(
                              top: bubbleSize * 0.2,
                              left: bubbleSize * 0.2,
                              child: Container(
                                width: bubbleSize * 0.3,
                                height: bubbleSize * 0.3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            );
          },
          onEnd: () {
            setState(() {});
          },
        ),
      );
    });
  }

  List<Widget> _buildOrbitingParticles(double radius, Color color) {
    // More particles with varied sizes and speeds
    return List.generate(8, (index) {
      final angle = (index / 8) * (2 * math.pi);
      final particleSize = 8.0 + (index % 3) * 4.0; // Varied sizes
      final speedMultiplier = 1.0 + (index % 3) * 0.3; // Varied speeds
      final particleColor = index % 2 == 0 ? Colors.white : color;

      return AnimatedBuilder(
        animation: _backgroundAnimController,
        builder: (context, child) {
          final currentAngle = angle +
              (_backgroundAnimController.value * speedMultiplier * 2 * math.pi);
          final x = radius * math.cos(currentAngle);
          final y = radius * math.sin(currentAngle);

          // Add a subtle pulsing effect
          final pulseValue = 0.8 +
              0.2 *
                  math.sin(
                      _backgroundAnimController.value * 4 * math.pi + index);

          return Transform.translate(
            offset: Offset(x, y),
            child: Transform.scale(
              scale: pulseValue,
              child: Container(
                width: particleSize,
                height: particleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      particleColor.withOpacity(0.9),
                      particleColor.withOpacity(0.3),
                    ],
                    radius: 0.7,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: particleColor.withOpacity(0.7),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Additional ring of sparkle effects
  List<Widget> _buildSparkleRing(double radius, Color color) {
    return List.generate(12, (index) {
      final angle = (index / 12) * (2 * math.pi);
      // Alternate direction
      final clockwise = index % 2 == 0;
      final speedMultiplier = 0.7 + (index % 4) * 0.1;

      return AnimatedBuilder(
        animation: _backgroundAnimController,
        builder: (context, child) {
          final currentAngle = clockwise
              ? angle +
                  (_backgroundAnimController.value *
                      speedMultiplier *
                      2 *
                      math.pi)
              : angle -
                  (_backgroundAnimController.value *
                      speedMultiplier *
                      2 *
                      math.pi);

          final x = radius * math.cos(currentAngle);
          final y = radius * math.sin(currentAngle);

          // Sparkle effect
          double fadeValue = math.max(0,
              math.sin(_backgroundAnimController.value * 8 * math.pi + index));

          if (fadeValue < 0.2) return SizedBox(); // Hide very dim sparkles

          return Transform.translate(
            offset: Offset(x, y),
            child: Opacity(
              opacity: fadeValue,
              child: _buildSparkle(
                size: 3.0 + fadeValue * 4.0,
                color: color,
              ),
            ),
          );
        },
      );
    });
  }

  // Individual sparkle widget
  Widget _buildSparkle({required double size, required Color color}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Horizontal line
        Container(
          width: size * 2.5,
          height: size / 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Vertical line
        Container(
          width: size / 2,
          height: size * 2.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Center dot
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.8),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
