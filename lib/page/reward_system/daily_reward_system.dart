import 'dart:math';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Rewards System Controller
class RewardsController extends GetxController {
  // Rewards data
  final RxList<DailyReward> dailyRewards = <DailyReward>[].obs;
  final RxInt currentDay = 0.obs;
  final RxInt totalCoins = 0.obs;
  final RxBool canClaimToday = false.obs;
  final RxBool isLoading = false.obs;
  final RxString lastClaimDate = ''.obs;
  final RxBool showDoubleReward = false.obs;

  // Reference to AssetRepo for items
  final assetRepo = Get.find<AssetRepo>();

  // Colors from your app theme
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color purpleColor = Color(0xFF9F6CF7);
  final Color blueColor = Color(0xFF5EBAF2);
  final Color orangeColor = Color(0xFFFFB347);
  final Color backgroundColor = Color(0xFFFFF0F5);

  // Constants
  final String PREFS_TOTAL_COINS = 'total_coins';
  final String PREFS_CURRENT_DAY = 'current_day';
  final String PREFS_LAST_CLAIM = 'last_claim_date';
  final String PREFS_STREAK_START = 'streak_start_date';

  @override
  void onInit() {
    super.onInit();
    _initializeRewards();
    loadRewardsData();
  }

  // Initialize the rewards for the 7-day cycle
  void _initializeRewards() {
    dailyRewards.value = [
      DailyReward(day: 1, coins: 10, item: null, description: "Welcome Gift"),
      DailyReward(day: 2, coins: 15, item: null, description: "Login Bonus"),
      DailyReward(day: 3, coins: 20, item: null, description: "Streak Bonus"),
      DailyReward(day: 4, coins: 25, item: null, description: "Midweek Gift"),
      DailyReward(day: 5, coins: 30, item: null, description: "Loyalty Bonus"),
      DailyReward(
          day: 6, coins: 40, item: null, description: "Weekend Eve Bonus"),
      DailyReward(
          day: 7,
          coins: 50,
          item: _getRandomItemAsset(),
          description: "Weekly Champion + Special Item"),
    ];
  }

  // Get a random item asset for the day 7 reward
  String? _getRandomItemAsset() {
    try {
      // Pick a random category (excluding basic/empty items)
      int categoryIndex = Random().nextInt(assetRepo.listItemMaker.length);

      // Pick a random item from the category (ensuring it's not the first default item)
      final categoryItems = assetRepo.listItemMaker[categoryIndex].listItem!;
      int itemIndex = 1 + Random().nextInt(categoryItems.length - 1);

      if (itemIndex < categoryItems.length) {
        return categoryItems[itemIndex];
      }
      return null;
    } catch (e) {
      print("Error getting random item: $e");
      return null;
    }
  }

  // Load saved rewards data from SharedPreferences
  Future<void> loadRewardsData() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load total coins
      totalCoins.value = prefs.getInt(PREFS_TOTAL_COINS) ?? 0;

      // Load current streak day
      currentDay.value = prefs.getInt(PREFS_CURRENT_DAY) ?? 0;

      // Load last claim date
      lastClaimDate.value = prefs.getString(PREFS_LAST_CLAIM) ?? '';

      // Check if player can claim today
      await _checkClaimEligibility();
    } catch (e) {
      print("Error loading rewards data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Check if player can claim today's reward
  Future<void> _checkClaimEligibility() async {
    final today = _getTodayFormatted();

    // If never claimed before or claimed on a different day
    if (lastClaimDate.isEmpty || lastClaimDate.value != today) {
      canClaimToday.value = true;

      // If the last claim wasn't yesterday, reset streak (except for first time)
      if (lastClaimDate.isNotEmpty) {
        final yesterday = _getYesterdayFormatted();

        if (lastClaimDate.value != yesterday) {
          // More than one day gap, reset streak
          await _resetStreak();
        }
      }
    } else {
      // Already claimed today
      canClaimToday.value = false;
    }
  }

  // Claim daily reward
  Future<DailyReward?> claimDailyReward({bool doubled = false}) async {
    if (!canClaimToday.value) return null;

    try {
      isLoading.value = true;

      // Increment day counter (wrap around to 1 after day 7)
      int newDay = (currentDay.value % 7) + 1;
      currentDay.value = newDay;

      // Get the reward for current day
      final DailyReward reward = dailyRewards[newDay - 1];

      // Double the coins if watching ad for double reward
      int coinsToAdd = doubled ? reward.coins * 2 : reward.coins;

      // Add coins to total
      totalCoins.value += coinsToAdd;

      // Save updated data
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(PREFS_TOTAL_COINS, totalCoins.value);
      prefs.setInt(PREFS_CURRENT_DAY, currentDay.value);

      // Save today as last claim date
      final today = _getTodayFormatted();
      lastClaimDate.value = today;
      prefs.setString(PREFS_LAST_CLAIM, today);

      // Mark as claimed for today
      canClaimToday.value = false;

      // If it's day 7 and there's an item, unlock it in the inventory
      if (newDay == 7 && reward.item != null) {
        await _unlockSpecialItem(reward.item!);
      }

      return doubled
          ? DailyReward(
              day: reward.day,
              coins: reward.coins * 2,
              item: reward.item,
              description: reward.description + " (DOUBLED!)")
          : reward;
    } catch (e) {
      print("Error claiming daily reward: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset streak when user misses a day
  Future<void> _resetStreak() async {
    try {
      currentDay.value = 0;
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt(PREFS_CURRENT_DAY, 0);
    } catch (e) {
      print("Error resetting streak: $e");
    }
  }

  // Unlock special item (for day 7 reward)
  Future<void> _unlockSpecialItem(String itemAsset) async {
    try {
      // This is just a placeholder - you would implement your item unlocking logic here
      // You could save to a special "unlocked items" collection in shared preferences
      final prefs = await SharedPreferences.getInstance();
      final unlockedItems = prefs.getStringList('unlocked_items') ?? [];

      if (!unlockedItems.contains(itemAsset)) {
        unlockedItems.add(itemAsset);
        await prefs.setStringList('unlocked_items', unlockedItems);
      }

      print("Unlocked special item: $itemAsset");
    } catch (e) {
      print("Error unlocking special item: $e");
    }
  }

  // Spend coins (for shop purchases)
  Future<bool> spendCoins(int amount) async {
    if (totalCoins.value < amount) return false;

    try {
      totalCoins.value -= amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(PREFS_TOTAL_COINS, totalCoins.value);
      return true;
    } catch (e) {
      print("Error spending coins: $e");
      return false;
    }
  }

  // Add coins (for rewarded ads, achievements, etc.)
  Future<void> addCoins(int amount) async {
    try {
      totalCoins.value += amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(PREFS_TOTAL_COINS, totalCoins.value);
    } catch (e) {
      print("Error adding coins: $e");
    }
  }

  // Show double reward option (after ad is available)
  void showDoubleRewardOption() {
    showDoubleReward.value = true;
  }

  // Get formatted date string for today
  String _getTodayFormatted() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  // Get formatted date string for yesterday
  String _getYesterdayFormatted() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return DateFormat('yyyy-MM-dd').format(yesterday);
  }
}

// Model for daily rewards
class DailyReward {
  final int day;
  final int coins;
  final String? item; // Asset path for special item, null if no item
  final String description;

  DailyReward({
    required this.day,
    required this.coins,
    this.item,
    required this.description,
  });
}

// Daily Login Rewards UI
class DailyRewardsPage extends StatelessWidget {
  final rewardsController = Get.find<RewardsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rewardsController.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorations
            ..._buildBackgroundElements(),

            // Main content
            Obx(() => rewardsController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        rewardsController.accentColor),
                  ))
                : _buildMainContent(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 10),
        _buildCoinsDisplay(),
        SizedBox(height: 20),
        Expanded(
          child: _buildRewardsGrid(),
        ),
        _buildClaimButton(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: rewardsController.accentColor),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Daily Rewards",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: rewardsController.accentColor,
                  ),
                ),
                SizedBox(height: 4),
                Obx(() => Text(
                      "Day ${rewardsController.currentDay.value == 0 ? 1 : rewardsController.currentDay.value} of 7",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(width: 40), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildCoinsDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            rewardsController.orangeColor.withOpacity(0.7),
            rewardsController.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on_rounded, color: Colors.amber, size: 26),
          SizedBox(width: 8),
          Obx(() => Text(
                "${rewardsController.totalCoins.value}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
          Text(
            " Coins",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsGrid() {
    return Obx(() {
      // Get current day (if 0, user is starting day 1)
      final currentDay = rewardsController.currentDay.value == 0
          ? 1
          : rewardsController.currentDay.value;

      // If user has claimed today, the next day to claim is current day + 1 (or 1 if we completed day 7)
      final nextDay = rewardsController.canClaimToday.value
          ? currentDay
          : (currentDay % 7) + 1;

      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: rewardsController.dailyRewards.length,
        itemBuilder: (context, index) {
          final reward = rewardsController.dailyRewards[index];
          final day = index + 1;

          // Determine card state
          bool isActive =
              day == nextDay && rewardsController.canClaimToday.value;
          bool isClaimed = day < nextDay ||
              (day == currentDay && !rewardsController.canClaimToday.value);
          bool isLocked = day > nextDay ||
              (day == nextDay && !rewardsController.canClaimToday.value);

          return _buildRewardCard(
            reward: reward,
            isActive: isActive,
            isClaimed: isClaimed,
            isLocked: isLocked,
          );
        },
      );
    });
  }

  Widget _buildRewardCard({
    required DailyReward reward,
    required bool isActive,
    required bool isClaimed,
    required bool isLocked,
  }) {
    // Choose appropriate colors based on card state
    Color cardColor;
    Color borderColor;
    double elevation;

    if (isActive) {
      cardColor = rewardsController.blueColor.withOpacity(0.2);
      borderColor = rewardsController.blueColor;
      elevation = 8.0;
    } else if (isClaimed) {
      cardColor = rewardsController.purpleColor.withOpacity(0.1);
      borderColor = rewardsController.purpleColor.withOpacity(0.4);
      elevation = 2.0;
    } else {
      cardColor = Colors.grey.withOpacity(0.1);
      borderColor = Colors.grey.withOpacity(0.3);
      elevation = 1.0;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? rewardsController.blueColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: elevation * 2,
            spreadRadius: elevation / 4,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Status indicator
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isClaimed
                    ? rewardsController.purpleColor
                    : isActive
                        ? rewardsController.blueColor
                        : Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
              child: Center(
                child: Icon(
                  isClaimed
                      ? Icons.check
                      : isActive
                          ? Icons.stars_rounded
                          : Icons.lock,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Card content
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Day number
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isClaimed
                        ? rewardsController.purpleColor.withOpacity(0.2)
                        : isActive
                            ? rewardsController.blueColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                    border: Border.all(
                      color: isClaimed
                          ? rewardsController.purpleColor.withOpacity(0.5)
                          : isActive
                              ? rewardsController.blueColor
                              : Colors.grey.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Day ${reward.day}",
                      style: TextStyle(
                        color: isClaimed
                            ? rewardsController.purpleColor
                            : isActive
                                ? rewardsController.blueColor
                                : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Reward content
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Coins
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on_rounded,
                            color: Colors.amber,
                            size: 22,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${reward.coins}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isClaimed
                                  ? Colors.grey[500]
                                  : isActive
                                      ? Colors.black
                                      : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),

                      // Claimed overlay
                      if (isClaimed)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "CLAIMED",
                                style: TextStyle(
                                  color: rewardsController.purpleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // Special item preview (day 7)
                if (reward.item != null)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: rewardsController.accentColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                rewardsController.accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: isLocked
                            ? Icon(
                                Icons.help_outline,
                                color: Colors.grey[400],
                                size: 24,
                              )
                            : Center(
                                child: Image.asset(
                                  reward.item!,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                      if (isLocked)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                        ),
                    ],
                  ),

                SizedBox(height: 5),

                // Description
                Text(
                  reward.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Glowing border for active card
          if (isActive)
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(
                      color: rewardsController.blueColor.withOpacity(0.7),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: rewardsController.blueColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClaimButton(BuildContext context) {
    return Obx(() {
      final bool canClaim = rewardsController.canClaimToday.value;
      final nextDay = rewardsController.currentDay.value == 0
          ? 1
          : (rewardsController.currentDay.value % 7) + 1;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            if (canClaim)
              _buildActiveClaimButtons(nextDay - 1)
            else
              _buildInactiveClaimButton(),
            SizedBox(height: 15),
          ],
        ),
      );
    });
  }

  Widget _buildActiveClaimButtons(int rewardIndex) {
    final reward = rewardsController.dailyRewards[rewardIndex];

    return Column(
      children: [
        // Primary claim button
        ElevatedButton(
          onPressed: () => _claimReward(false),
          style: ElevatedButton.styleFrom(
            backgroundColor: rewardsController.accentColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: rewardsController.accentColor.withOpacity(0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.card_giftcard_rounded, size: 24),
              SizedBox(width: 10),
              Text(
                "Claim ${reward.coins} Coins",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),

        // Double reward button (for rewarded ads)
        Obx(() => rewardsController.showDoubleReward.value
            ? ElevatedButton(
                onPressed: () => _claimReward(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rewardsController.orangeColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: rewardsController.orangeColor.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Watch Ad for ${reward.coins * 2} Coins",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : TextButton(
                onPressed: () {
                  // Here you would trigger the ad load
                  // After ad is available, call showDoubleRewardOption()

                  // For demo, we'll just show it directly
                  rewardsController.showDoubleRewardOption();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie_rounded,
                        color: rewardsController.orangeColor),
                    SizedBox(width: 8),
                    Text(
                      "Watch Ad to Double Reward",
                      style: TextStyle(
                        color: rewardsController.orangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  Widget _buildInactiveClaimButton() {
    // Format the current time to display next claim time
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final hoursLeft = tomorrow.difference(now).inHours;
    final minutesLeft = tomorrow.difference(now).inMinutes % 60;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time_rounded, color: Colors.grey[600]),
              SizedBox(width: 10),
              Text(
                "Next Reward in $hoursLeft h $minutesLeft min",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Claim reward action
  void _claimReward(bool doubled) async {
    final result = await rewardsController.claimDailyReward(doubled: doubled);

    if (result != null) {
      // Show reward dialog
      _showRewardDialog(result, doubled);
    }
  }

  // Show reward dialog
  void _showRewardDialog(DailyReward reward, bool doubled) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rewardsController.accentColor.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.celebration,
                  color: rewardsController.accentColor,
                  size: 50,
                ),
              ),

              SizedBox(height: 20),

              // Title
              Text(
                "Reward Claimed!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: rewardsController.accentColor,
                ),
              ),

              SizedBox(height: 15),

              // Reward details
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: rewardsController.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: rewardsController.secondaryColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on_rounded,
                            color: Colors.amber, size: 30),
                        SizedBox(width: 10),
                        Text(
                          "${reward.coins} Coins",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (doubled)
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: rewardsController.orangeColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "2X",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (reward.item != null) ...[
                      SizedBox(height: 15),
                      Text(
                        "Special Item Unlocked!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: rewardsController.accentColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: rewardsController.accentColor
                                  .withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          reward.item!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Description
              Text(
                reward.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 25),

              // Close button
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rewardsController.accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  "Awesome!",
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
      barrierDismissible: false,
    );
  }

  // Background decorations
  List<Widget> _buildBackgroundElements() {
    // Get screen size
    final size = Get.size;

    return [
      // Top right blob
      Positioned(
        top: -50,
        right: -50,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                rewardsController.primaryColor.withOpacity(0.3),
                rewardsController.primaryColor.withOpacity(0.0),
              ],
              radius: 0.7,
            ),
          ),
        ),
      ),

      // Bottom left blob
      Positioned(
        bottom: -30,
        left: -30,
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                rewardsController.purpleColor.withOpacity(0.3),
                rewardsController.purpleColor.withOpacity(0.0),
              ],
              radius: 0.7,
            ),
          ),
        ),
      ),

      // Small decorative circles
      ...List.generate(8, (index) {
        final random = Random(index * 10);
        final size = 10.0 + random.nextDouble() * 15.0;
        final xPos = random.nextDouble() * Get.width;
        final yPos = random.nextDouble() * Get.height;
        final color = [
          rewardsController.primaryColor,
          rewardsController.secondaryColor,
          rewardsController.purpleColor,
          rewardsController.blueColor,
        ][index % 4];

        return Positioned(
          left: xPos,
          top: yPos,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
          ),
        );
      }),
    ];
  }
}
