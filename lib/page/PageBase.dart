import 'dart:math' as math;
import 'dart:ui';

import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/page/viewcharacter/PageViewCharacter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/AvatarController.dart';

class PageBase extends StatefulWidget {
  static String routeName = "/PageBase"; // Changed from String? to String
  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase> with TickerProviderStateMixin {
  List<Widget> listPage = [];

  int selectedPage = 0;
  final repoController = Get.put(AssetRepo());
  final saveAvatarController = Get.put(SaveAvatarController());
  final avatarController = Get.put(AvatarController());

  // Enhanced color palette for kids
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color purpleColor = Color(0xFF9F6CF7);
  final Color blueColor = Color(0xFF5EBAF2);
  final Color orangeColor = Color(0xFFFFB347);
  final Color backgroundColor = Color(0xFFFFF0F5);

  // Animation controllers
  late AnimationController _bounceController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  // Colors for nav items
  late List<Color> navColors;

  @override
  void initState() {
    super.initState();

    // Register this state controller with GetX so it can be accessed
    Get.put(this, tag: 'pageBaseState');

    repoController.updateRepo();

    // Initialize pages
    listPage = [
      SafeArea(child: PageMakerCharacter()),
      SafeArea(child: AvatarHistoryPage()),
      SafeArea(child: PageComingSoon("Magic Shop")),
      SafeArea(child: PageComingSoon("Fun Games")),
    ];

    // Setup animation controllers
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Define navigation colors
    navColors = [
      primaryColor,
      purpleColor,
      blueColor,
      orangeColor,
    ];
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();

    // Remove the state from GetX when disposed
    Get.delete<_PageBaseState>(tag: 'pageBaseState');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the actual screen size
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          // Main content with padding at bottom to avoid navbar overlap
          Container(
            width: screenSize.width,
            height: screenSize.height,
            padding: EdgeInsets.only(bottom: 90 + bottomPadding),
            child: listPage[selectedPage],
          ),

          // Bottom navigation bar
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFancyNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFancyNavBar() {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background curved container with glass effect
          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.3),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  child: CustomPaint(
                    painter: BubblePainter(
                      dotPositions: _calculateDotPositions(width),
                      colors: [
                        primaryColor.withOpacity(0.3),
                        purpleColor.withOpacity(0.3),
                        blueColor.withOpacity(0.3),
                        orangeColor.withOpacity(0.3),
                      ],
                      size: Size(width - 32, 70),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAnimatedNavItem(
                            icon: Icons.create_rounded,
                            label: "Create",
                            isActive: selectedPage == 0,
                            index: 0,
                            color: navColors[0],
                          ),
                          _buildAnimatedNavItem(
                            icon: Icons.collections_rounded,
                            label: "Gallery",
                            isActive: selectedPage == 1,
                            index: 1,
                            color: navColors[1],
                          ),
                          _buildAnimatedNavItem(
                            icon: Icons.shopping_bag_rounded,
                            label: "Shop",
                            isActive: selectedPage == 2,
                            index: 2,
                            color: navColors[2],
                          ),
                          _buildAnimatedNavItem(
                            icon: Icons.sports_esports_rounded,
                            label: "Games",
                            isActive: selectedPage == 3,
                            index: 3,
                            color: navColors[3],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating bubbles around the navbar
          ..._buildFloatingBubbles(),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingBubbles() {
    return List.generate(6, (index) {
      final random = math.Random(index * 10);
      final size = (8 + random.nextInt(6)).toDouble();
      final xOffset = -70.0 + random.nextInt(140);
      final yOffset = -30.0 + random.nextInt(60);

      return Positioned(
        left: MediaQuery.of(context).size.width / 2 + xOffset,
        top: 40 + yOffset,
        child: AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            final floatValue =
                math.sin((_scaleController.value * math.pi * 2) + index);
            final xFloat = math.cos(
                    (_rotationController.value * math.pi * 2) + index * 0.5) *
                5;
            final yFloat = math.sin(
                    (_rotationController.value * math.pi * 2) + index * 0.5) *
                5;

            return Transform.translate(
              offset: Offset(xFloat, yFloat + floatValue * 3),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: navColors[index % navColors.length].withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color:
                          navColors[index % navColors.length].withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 1,
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

  Widget _buildAnimatedNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required int index,
    required Color color,
  }) {
    // Create spring animation for the bounce effect
    final Animation<double> bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPage = index;
          _bounceController.reset();
          _bounceController.forward();
        });
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounceController, _scaleController]),
        builder: (context, child) {
          double scale = isActive ? 1.0 + (bounceAnimation.value * 0.2) : 1.0;

          // Add subtle pulsing effect to inactive items
          if (!isActive) {
            scale = 0.9 + (_scaleController.value * 0.1);
          }

          return Transform.scale(
            scale: scale,
            child: Container(
              width: MediaQuery.of(context).size.width / 5, // Responsive width
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with background bubble
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(isActive ? 0.8 : 0.3),
                          color.withOpacity(isActive ? 0.6 : 0.1),
                        ],
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 8,
                                spreadRadius: -2,
                                offset: Offset(-2, -2),
                              ),
                            ]
                          : [],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Add sparkles for active item
                        if (isActive)
                          ...List.generate(4, (i) {
                            final angle = i * (math.pi / 2);
                            final distance = 22.0;
                            return Positioned(
                              left: 22 +
                                  math.cos(angle +
                                          _rotationController.value *
                                              math.pi *
                                              2) *
                                      distance *
                                      0.3,
                              top: 22 +
                                  math.sin(angle +
                                          _rotationController.value *
                                              math.pi *
                                              2) *
                                      distance *
                                      0.3,
                              child: Opacity(
                                opacity: 0.6,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),

                        // Icon
                        Icon(
                          icon,
                          color: Colors.white,
                          size: isActive ? 26 : 22,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4),

                  // Label with animated color and optional bounce
                  Container(
                    height: 14,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isActive ? color : Colors.grey.shade700,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w500,
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
    );
  }

  // Calculates positions for background bubbles in the navbar
  List<Offset> _calculateDotPositions(double width) {
    List<Offset> positions = [];
    final random = math.Random(42);

    for (int i = 0; i < 20; i++) {
      double x = random.nextDouble() * (width - 32);
      double y = random.nextDouble() * 70;
      positions.add(Offset(x, y));
    }

    return positions;
  }
}

// Custom painter for bubble background effect
class BubblePainter extends CustomPainter {
  final List<Offset> dotPositions;
  final List<Color> colors;
  final Size size;

  BubblePainter(
      {required this.dotPositions, required this.colors, required this.size});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    for (int i = 0; i < dotPositions.length; i++) {
      // Scale dots based on canvas size
      final scaledX = dotPositions[i].dx * (canvasSize.width / size.width);
      final scaledY = dotPositions[i].dy * (canvasSize.height / size.height);

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(scaledX, scaledY), 3 + (i % 8), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Coming Soon Page with fun animated elements for kids
class PageComingSoon extends StatefulWidget {
  final String featureName;

  PageComingSoon(this.featureName);

  @override
  State<PageComingSoon> createState() => _PageComingSoonState();
}

class _PageComingSoonState extends State<PageComingSoon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFDAD7FF),
            Color(0xFFFFE0F3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background elements
          ..._buildBackgroundElements(width, height),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated icon container
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0,
                          math.sin(_animationController.value * math.pi) * 10),
                      child: Container(
                        width: width * 0.4,
                        height: width * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getColorForFeature(widget.featureName)
                                  .withOpacity(0.7),
                              _getColorForFeature(widget.featureName)
                                  .withOpacity(0.3),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getColorForFeature(widget.featureName)
                                  .withOpacity(0.5),
                              blurRadius: 25,
                              spreadRadius: 5,
                              offset: Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 20,
                              spreadRadius: -5,
                              offset: Offset(-10, -10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            _getIconForFeature(widget.featureName),
                            color: Colors.white,
                            size: width * 0.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),

                // Animated title
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      _getColorForFeature(widget.featureName),
                      Color(0xFFFF6CAB),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    widget.featureName,
                    style: TextStyle(
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 12),

                // Subtitle with animated container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorForFeature(widget.featureName)
                            .withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    "Coming Soon!",
                    style: TextStyle(
                      color: Color(0xFFAA336A),
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // Description
                Container(
                  width: width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _getDescriptionForFeature(widget.featureName),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF4A4A4A),
                      fontSize: width * 0.04,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundElements(double width, double height) {
    return List.generate(15, (index) {
      final random = math.Random(index * 3);
      final size = (width * 0.04) + random.nextDouble() * (width * 0.06);
      final xPos = random.nextDouble() * width;
      final yPos = random.nextDouble() * height;
      final opacity = 0.1 + random.nextDouble() * 0.2;

      return Positioned(
        left: xPos,
        top: yPos,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final animValue = math
                .sin((_animationController.value * math.pi * 2) + (index / 3));
            final moveX =
                math.cos(_animationController.value * math.pi + index) * 10;
            final moveY =
                math.sin(_animationController.value * math.pi + index) * 10;

            return Transform.translate(
              offset: Offset(moveX, moveY),
              child: Opacity(
                opacity: (opacity + animValue * 0.1).clamp(0.05, 0.3),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColorForFeature(widget.featureName),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorForFeature(widget.featureName)
                            .withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  IconData _getIconForFeature(String feature) {
    switch (feature.toLowerCase()) {
      case 'magic shop':
        return Icons.shopping_bag_rounded;
      case 'fun games':
        return Icons.sports_esports_rounded;
      case 'community':
        return Icons.people_rounded;
      case 'settings':
        return Icons.settings_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  Color _getColorForFeature(String feature) {
    switch (feature.toLowerCase()) {
      case 'magic shop':
        return Color(0xFF9F6CF7); // Purple
      case 'fun games':
        return Color(0xFF5EBAF2); // Blue
      case 'community':
        return Color(0xFFFF8C9F); // Pink
      case 'settings':
        return Color(0xFFFFB347); // Orange
      default:
        return Color(0xFFFA9ECC); // Default pink
    }
  }

  String _getDescriptionForFeature(String feature) {
    switch (feature.toLowerCase()) {
      case 'magic shop':
        return "Get ready to discover magical items, outfits and special powers for your avatars! The Magic Shop will be filled with wonderful surprises.";
      case 'fun games':
        return "Play exciting mini-games with your avatars! Challenge friends, win prizes, and have tons of fun in our upcoming games section.";
      case 'community':
        return "Share your avatars with friends, join events, and see what others are creating in our friendly community space!";
      case 'settings':
        return "Customize your experience, change themes, and make everything just the way you like it with our upcoming settings options.";
      default:
        return "We're working on something special just for you! Stay tuned for amazing new features coming soon.";
    }
  }
}
