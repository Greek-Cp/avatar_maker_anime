import 'package:avatar_maker/page/reward_system/daily_reward_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Achievement Model
class Achievement {
  final String id;
  final String title;
  final String description;
  final int requiredValue;
  final AchievementType type;
  final int coinReward;
  final String? itemReward; // Special item as reward (asset path)

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredValue,
    required this.type,
    required this.coinReward,
    this.itemReward,
  });
}

// Achievement Types
enum AchievementType {
  createAvatars,
  loginDays,
  watchAds,
  purchaseItems,
  unlockItems,
}

// Achievement Controller
class AchievementController extends GetxController {
  // References to other controllers
  final rewardsController = Get.find<RewardsController>();

  // Observable lists and variables
  final RxList<Achievement> achievements = <Achievement>[].obs;
  final RxMap<String, int> progressMap = <String, int>{}.obs;
  final RxList<String> completedAchievements = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt newAchievementCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAchievements();
    _loadUserProgress();
  }

  // Initialize achievements
  void _initializeAchievements() {
    // In a real app, this could be loaded from a JSON file or API
    achievements.value = [
      // Avatar Creation Achievements
      Achievement(
        id: 'create_first',
        title: 'First Creation',
        description: 'Create your first avatar',
        requiredValue: 1,
        type: AchievementType.createAvatars,
        coinReward: 10,
      ),
      Achievement(
        id: 'create_5',
        title: 'Novice Creator',
        description: 'Create 5 avatars',
        requiredValue: 5,
        type: AchievementType.createAvatars,
        coinReward: 20,
      ),
      Achievement(
        id: 'create_10',
        title: 'Experienced Designer',
        description: 'Create 10 avatars',
        requiredValue: 10,
        type: AchievementType.createAvatars,
        coinReward: 30,
      ),
      Achievement(
        id: 'create_25',
        title: 'Avatar Master',
        description: 'Create 25 avatars',
        requiredValue: 25,
        type: AchievementType.createAvatars,
        coinReward: 50,
        itemReward: 'assets/special/frame_gold.png', // Example path
      ),

      // Login Achievements
      Achievement(
        id: 'login_3',
        title: 'Regular Visitor',
        description: 'Login for 3 days',
        requiredValue: 3,
        type: AchievementType.loginDays,
        coinReward: 15,
      ),
      Achievement(
        id: 'login_7',
        title: 'Weekly Friend',
        description: 'Login for 7 days',
        requiredValue: 7,
        type: AchievementType.loginDays,
        coinReward: 30,
      ),
      Achievement(
        id: 'login_30',
        title: 'Dedicated Fan',
        description: 'Login for 30 days',
        requiredValue: 30,
        type: AchievementType.loginDays,
        coinReward: 100,
        itemReward: 'assets/special/background_vip.png', // Example path
      ),

      // Ad Watching Achievements
      Achievement(
        id: 'ads_5',
        title: 'Ad Supporter',
        description: 'Watch 5 ads',
        requiredValue: 5,
        type: AchievementType.watchAds,
        coinReward: 25,
      ),
      Achievement(
        id: 'ads_20',
        title: 'Ad Enthusiast',
        description: 'Watch 20 ads',
        requiredValue: 20,
        type: AchievementType.watchAds,
        coinReward: 50,
      ),
      Achievement(
        id: 'ads_50',
        title: 'Super Supporter',
        description: 'Watch 50 ads',
        requiredValue: 50,
        type: AchievementType.watchAds,
        coinReward: 100,
        itemReward: 'assets/special/accessory_crown.png', // Example path
      ),

      // Shop Achievements
      Achievement(
        id: 'purchase_first',
        title: 'First Purchase',
        description: 'Purchase your first item',
        requiredValue: 1,
        type: AchievementType.purchaseItems,
        coinReward: 10,
      ),
      Achievement(
        id: 'purchase_5',
        title: 'Collector',
        description: 'Purchase 5 items',
        requiredValue: 5,
        type: AchievementType.purchaseItems,
        coinReward: 30,
      ),
      Achievement(
        id: 'unlock_3',
        title: 'Adventurous',
        description: 'Unlock 3 items with ads',
        requiredValue: 3,
        type: AchievementType.unlockItems,
        coinReward: 25,
      ),
    ];
  }

  // Load user progress from storage
  Future<void> _loadUserProgress() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load progress map
      final progressJson = prefs.getString('achievement_progress') ?? '{}';
      final Map<String, dynamic> decodedMap = json.decode(progressJson);

      progressMap.value =
          decodedMap.map((key, value) => MapEntry(key, value as int));

      // Load completed achievements
      completedAchievements.value =
          prefs.getStringList('completed_achievements') ?? [];

      // Load new (unclaimed) achievement count
      newAchievementCount.value = prefs.getInt('new_achievement_count') ?? 0;
    } catch (e) {
      print("Error loading achievement progress: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Save progress to storage
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save progress map
      await prefs.setString(
          'achievement_progress', json.encode(progressMap.value));

      // Save completed achievements
      await prefs.setStringList(
          'completed_achievements', completedAchievements.toList());

      // Save new achievement count
      await prefs.setInt('new_achievement_count', newAchievementCount.value);
    } catch (e) {
      print("Error saving achievement progress: $e");
    }
  }

  // Update progress for an achievement type
  Future<void> updateProgress(AchievementType type, int value) async {
    // Get all achievements of this type
    final typeAchievements = achievements.where((a) => a.type == type).toList();

    for (final achievement in typeAchievements) {
      // Skip already completed achievements
      if (completedAchievements.contains(achievement.id)) {
        continue;
      }

      // Update progress
      final currentProgress = progressMap[achievement.id] ?? 0;
      final newProgress = currentProgress + value;

      // Set new progress
      progressMap[achievement.id] = newProgress;

      // Check if achievement is completed
      if (newProgress >= achievement.requiredValue) {
        // Mark as completed and increment new achievement count
        if (!completedAchievements.contains(achievement.id)) {
          completedAchievements.add(achievement.id);
          newAchievementCount.value++;

          // Show notification
          Get.snackbar(
            "Achievement Unlocked!",
            achievement.title,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            icon: Icon(Icons.emoji_events, color: Colors.white),
            duration: Duration(seconds: 3),
          );
        }
      }
    }

    // Save changes
    await _saveProgress();
  }

  // Get progress for a specific achievement
  int getProgress(String achievementId) {
    return progressMap[achievementId] ?? 0;
  }

  // Check if achievement is completed
  bool isAchievementCompleted(String achievementId) {
    return completedAchievements.contains(achievementId);
  }

  // Claim achievement reward
  Future<void> claimReward(Achievement achievement) async {
    try {
      // Check if achievement is completed and not already claimed
      if (!completedAchievements.contains(achievement.id)) {
        return;
      }

      // Award coins
      if (achievement.coinReward > 0) {
        await rewardsController.addCoins(achievement.coinReward);
      }

      // Award special item if any
      if (achievement.itemReward != null) {
        await _unlockSpecialItem(achievement.itemReward!);
      }

      // Decrement new achievement count
      if (newAchievementCount.value > 0) {
        newAchievementCount.value--;
      }

      // Save changes
      await _saveProgress();
    } catch (e) {
      print("Error claiming achievement reward: $e");
    }
  }

  // Unlock special item from achievement
  Future<void> _unlockSpecialItem(String itemAsset) async {
    try {
      // This is a placeholder - you would implement your item unlocking logic here
      final prefs = await SharedPreferences.getInstance();
      final unlockedItems = prefs.getStringList('unlocked_items') ?? [];

      if (!unlockedItems.contains(itemAsset)) {
        unlockedItems.add(itemAsset);
        await prefs.setStringList('unlocked_items', unlockedItems);
      }

      print("Unlocked special item from achievement: $itemAsset");
    } catch (e) {
      print("Error unlocking special item: $e");
    }
  }

  // Get achievements by type
  List<Achievement> getAchievementsByType(AchievementType type) {
    return achievements.where((a) => a.type == type).toList();
  }

  // Get all achievement types
  List<AchievementType> getAllTypes() {
    final types = <AchievementType>{};
    for (final achievement in achievements) {
      types.add(achievement.type);
    }
    return types.toList();
  }

  // Track avatar creation
  Future<void> trackAvatarCreated() async {
    await updateProgress(AchievementType.createAvatars, 1);
  }

  // Track login
  Future<void> trackLogin() async {
    await updateProgress(AchievementType.loginDays, 1);
  }

  // Track ad watched
  Future<void> trackAdWatched() async {
    await updateProgress(AchievementType.watchAds, 1);
  }

  // Track item purchased
  Future<void> trackItemPurchased() async {
    await updateProgress(AchievementType.purchaseItems, 1);
  }

  // Track item unlocked with ads
  Future<void> trackItemUnlocked() async {
    await updateProgress(AchievementType.unlockItems, 1);
  }
}

// Achievements Page UI
class AchievementsPage extends StatelessWidget {
  final achievementController = Get.find<AchievementController>();

  static var routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF0F5),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorations
            ..._buildBackgroundElements(),

            // Main content
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Obx(
                    () => achievementController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFAA336A)),
                          ))
                        : _buildAchievementList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFAA336A)),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              "Achievements",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAA336A),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon:
                    Icon(Icons.emoji_events_rounded, color: Color(0xFFAA336A)),
                onPressed: () {},
              ),
              Obx(
                () => achievementController.newAchievementCount.value > 0
                    ? Positioned(
                        top: 5,
                        right: 5,
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
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementList() {
    // Get all achievement types
    final types = achievementController.getAllTypes();

    return DefaultTabController(
      length: types.length,
      child: Column(
        children: [
          // Tab bar
          Container(
            height: 45,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9F6CF7),
                    Color(0xFFFA9ECC),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: TextStyle(fontSize: 12),
              tabs: types
                  .map((type) => Tab(
                        text: _getTypeTitle(type),
                        icon: Icon(_getTypeIcon(type), size: 16),
                      ))
                  .toList(),
            ),
          ),

          SizedBox(height: 15),

          // Tab content
          Expanded(
            child: TabBarView(
              children: types
                  .map((type) => _buildAchievementListByType(type))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementListByType(AchievementType type) {
    final achievements = achievementController.getAchievementsByType(type);

    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final isCompleted =
        achievementController.isAchievementCompleted(achievement.id);
    final progress = achievementController.getProgress(achievement.id);
    final progressPercentage = progress / achievement.requiredValue;

    // Card colors based on completion status
    final cardColor =
        isCompleted ? Color(0xFF9F6CF7).withOpacity(0.1) : Colors.white;
    final borderColor = isCompleted ? Color(0xFF9F6CF7) : Colors.grey[300]!;
    final progressColor = isCompleted ? Color(0xFF9F6CF7) : Color(0xFF5EBAF2);

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Achievement content
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCompleted ? Color(0xFF9F6CF7) : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(achievement.type),
                      color: isCompleted ? Colors.white : Colors.grey[500],
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 15),

                  // Achievement details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          achievement.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? Color(0xFF9F6CF7)
                                : Colors.grey[800],
                          ),
                        ),

                        SizedBox(height: 5),

                        // Description
                        Text(
                          achievement.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: 10),

                        // Progress indicator
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  value: progressPercentage.clamp(0.0, 1.0),
                                  backgroundColor: Colors.grey[200],
                                  color: progressColor,
                                  minHeight: 10,
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            // Progress text
                            Text(
                              "$progress/${achievement.requiredValue}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? Color(0xFF9F6CF7)
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        // Rewards
                        Row(
                          children: [
                            // Coin reward
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.monetization_on_rounded,
                                      color: Colors.amber, size: 14),
                                  SizedBox(width: 3),
                                  Text(
                                    "${achievement.coinReward}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Item reward if any
                            if (achievement.itemReward != null) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Color(0xFFAA336A).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(0xFFAA336A),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.card_giftcard_rounded,
                                        color: Color(0xFFAA336A), size: 14),
                                    SizedBox(width: 3),
                                    Text(
                                      "Special Item",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Claim button for completed achievements
                  if (isCompleted)
                    IconButton(
                      icon: Icon(
                        Icons.card_giftcard_rounded,
                        color: Color(0xFFAA336A),
                      ),
                      onPressed: () => _showClaimRewardDialog(achievement),
                    ),
                ],
              ),
            ),

            // Completed ribbon
            if (isCompleted)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF9F6CF7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showClaimRewardDialog(Achievement achievement) {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
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
              // Header
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF9F6CF7),
                      Color(0xFFFA9ECC),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              SizedBox(height: 15),

              // Title
              Text(
                "Achievement Unlocked!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA336A),
                ),
              ),

              SizedBox(height: 10),

              // Achievement name
              Text(
                achievement.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9F6CF7),
                ),
              ),

              SizedBox(height: 5),

              // Description
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 20),

              // Rewards header
              Text(
                "Your Rewards",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 15),

              // Rewards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Coin reward
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.amber,
                      size: 30,
                    ),
                  ),

                  SizedBox(width: 10),

                  Text(
                    "${achievement.coinReward}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),

                  Text(
                    " Coins",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              // Special item if any
              if (achievement.itemReward != null) ...[
                SizedBox(height: 20),
                Text(
                  "Special Item Unlocked!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAA336A),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFA9ECC).withOpacity(0.3),
                        Color(0xFF9F6CF7).withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFAA336A).withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: achievement.itemReward!.isNotEmpty
                        ? Image.asset(
                            achievement.itemReward!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.card_giftcard_rounded,
                            color: Color(0xFFAA336A),
                            size: 40,
                          ),
                  ),
                ),
              ],

              SizedBox(height: 25),

              // Claim button
              ElevatedButton(
                onPressed: () {
                  achievementController.claimReward(achievement);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9F6CF7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  "Claim Rewards!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  String _getTypeTitle(AchievementType type) {
    switch (type) {
      case AchievementType.createAvatars:
        return "Create";
      case AchievementType.loginDays:
        return "Login";
      case AchievementType.watchAds:
        return "Ads";
      case AchievementType.purchaseItems:
        return "Shop";
      case AchievementType.unlockItems:
        return "Unlock";
      default:
        return "Other";
    }
  }

  IconData _getTypeIcon(AchievementType type) {
    switch (type) {
      case AchievementType.createAvatars:
        return Icons.create_rounded;
      case AchievementType.loginDays:
        return Icons.calendar_today_rounded;
      case AchievementType.watchAds:
        return Icons.movie_rounded;
      case AchievementType.purchaseItems:
        return Icons.shopping_cart_rounded;
      case AchievementType.unlockItems:
        return Icons.lock_open_rounded;
      default:
        return Icons.emoji_events_rounded;
    }
  }

  // Background decorations
  List<Widget> _buildBackgroundElements() {
    // Get screen size
    final size = Get.size;

    return [
      // Top right blob
      Positioned(
        top: -70,
        right: -70,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFFFA9ECC).withOpacity(0.3),
                Color(0xFFFA9ECC).withOpacity(0.0),
              ],
              radius: 0.7,
            ),
          ),
        ),
      ),

      // Bottom left blob
      Positioned(
        bottom: -50,
        left: -50,
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Color(0xFF9F6CF7).withOpacity(0.3),
                Color(0xFF9F6CF7).withOpacity(0.0),
              ],
              radius: 0.7,
            ),
          ),
        ),
      ),
    ];
  }
}
