import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/page/reward_system/achievment_system.dart';
import 'package:avatar_maker/page/reward_system/daily_reward_system.dart';
import 'package:avatar_maker/page/reward_system/model/shop_item.dart';
import 'package:avatar_maker/page/reward_system/shop_page.dart';
import 'package:avatar_maker/page/viewcharacter/PageViewCharacter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/AvatarController.dart';

// Import your other classes
class AppTabController extends GetxController {
  // Current selected tab index
  final RxInt selectedTab = 0.obs;

  // Method to change the tab
  void changeTab(int index) {
    selectedTab.value = index;
  }
}

class PageBase extends StatefulWidget {
  static String routeName = "/PageBase";
  @override
  State<PageBase> createState() => _PageBaseState();
}

class _PageBaseState extends State<PageBase> with TickerProviderStateMixin {
  List<Widget> listPage = [];

  // Use the tab controller instead of a local variable
  final tabController = Get.put(AppTabController());

  final repoController = Get.put(AssetRepo());
  final saveAvatarController = Get.put(SaveAvatarController());
  final avatarController = Get.put(AvatarController());

  // Initialize new controllers
  final rewardsController = Get.put(RewardsController());
  final shopController = Get.put(ShopController());
  final achievementController = Get.put(AchievementController());

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

  // Timer for checking daily rewards
  Timer? _dailyRewardTimer;

  @override
  void initState() {
    super.initState();

    repoController.updateRepo();

    // Updated pages with real implementations instead of "Coming Soon"
    listPage = [
      PageMakerCharacter(),
      SafeArea(child: AvatarHistoryPage()),
      SafeArea(child: ShopPage()),
      SafeArea(child: AchievementsPage()),
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

    // Track login for achievements and check daily rewards
    _trackLogin();
    _checkDailyRewards();

    // Set up a timer to periodically check if daily rewards can be claimed
    // This is useful if the app stays open past midnight
    _dailyRewardTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      _checkDailyRewards();
    });
  }

  Future<void> _trackLogin() async {
    // Track login for achievements
    await achievementController.trackLogin();
  }

  Future<void> _checkDailyRewards() async {
    await rewardsController.loadRewardsData();

    // Show daily reward popup if it can be claimed
    if (rewardsController.canClaimToday.value) {
      // Wait a bit before showing the dialog to let the app initialize properly
      Future.delayed(Duration(seconds: 1), () {
        _showDailyRewardDialog();
      });
    }
  }

  void _showDailyRewardDialog() {
    // Only show if the app is in foreground and initialized
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        orangeColor,
                        primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                SizedBox(height: 20),

                // Title
                Text(
                  "Daily Reward Available!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),

                SizedBox(height: 15),

                // Description
                Text(
                  "Come back daily to collect coins and special items!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),

                SizedBox(height: 25),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.to(() => DailyRewardsPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      ),
                      child: Text(
                        "Claim Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Later",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    _dailyRewardTimer?.cancel();
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
            // Use Obx to listen to the tab controller
            child: Obx(() => listPage[tabController.selectedTab.value]),
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
                          Obx(() => _buildAnimatedNavItem(
                                icon: Icons.create_rounded,
                                label: "Create",
                                isActive: tabController.selectedTab.value == 0,
                                index: 0,
                                color: navColors[0],
                              )),
                          Obx(() => _buildAnimatedNavItem(
                                icon: Icons.collections_rounded,
                                label: "Gallery",
                                isActive: tabController.selectedTab.value == 1,
                                index: 1,
                                color: navColors[1],
                              )),
                          Obx(() => _buildAnimatedNavItem(
                                icon: Icons.shopping_bag_rounded,
                                label: "Shop",
                                isActive: tabController.selectedTab.value == 2,
                                index: 2,
                                color: navColors[2],
                              )),
                          Obx(() => _buildAnimatedNavItem(
                                icon: Icons
                                    .emoji_events_rounded, // Changed to trophy icon for achievements
                                label:
                                    "Rewards", // Changed label from "Games" to "Rewards"
                                isActive: tabController.selectedTab.value == 3,
                                index: 3,
                                color: navColors[3],
                              )),
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
    // Add notification badges for daily rewards and achievements
    Widget? badge;

    if (index == 2 && rewardsController.canClaimToday.value) {
      // Shop tab with daily reward notification
      badge = Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            color: Colors.white,
            size: 8,
          ),
        ),
      );
    } else if (index == 3 &&
        achievementController.newAchievementCount.value > 0) {
      // Achievements tab with new achievements count
      badge = Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Text(
            "${achievementController.newAchievementCount.value}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Create spring animation for the bounce effect
    final Animation<double> bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );

    return GestureDetector(
      onTap: () {
        // Update the tab controller
        tabController.changeTab(index);
        _bounceController.reset();
        _bounceController.forward();
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
                  Stack(
                    children: [
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

                      // Add the badge if needed
                      if (badge != null) badge,
                    ],
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

// BubblePainter class remains unchanged
class BubblePainter extends CustomPainter {
  final List<Offset> dotPositions;
  final List<Color> colors;
  final Size size;

  BubblePainter({
    required this.dotPositions,
    required this.colors,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < dotPositions.length; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        dotPositions[i],
        2 + (i % 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
