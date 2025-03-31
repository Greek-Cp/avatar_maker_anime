// Item Shop Implementation
import 'dart:convert';

import 'package:avatar_maker/page/maker/PageMakerCharacter.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/page/reward_system/achievment_system.dart';
import 'package:avatar_maker/page/reward_system/daily_reward_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

// Shop Item Model
class ShopItem {
  final String id;
  final String name;
  final String assetPath;
  final String description;
  final ItemType type;
  final ItemCategory category;
  final int price; // Price in coins, 0 for FREE items
  final bool isLocked; // If true, can be unlocked via watching ads
  final int adsToUnlock; // Number of ads to watch to unlock (if isLocked)
  final bool isPremium; // Special premium items

  ShopItem({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.description,
    required this.type,
    required this.category,
    required this.price,
    this.isLocked = false,
    this.adsToUnlock = 0,
    this.isPremium = false,
  });
}

// Item type enum
enum ItemType {
  hair,
  eyes,
  mouth,
  outfit,
  accessory,
  background,
  frame,
  sticker,
  special
}

// Item category enum
enum ItemCategory { free, basic, rare, legendary }

class ShopController extends GetxController {
  final rewardsController = Get.find<RewardsController>();
  final assetRepo = Get.find<AssetRepo>();

  // Observable lists and variables
  final RxList<ShopItem> shopItems = <ShopItem>[].obs;
  final RxList<String> unlockedItems = <String>[].obs;
  final RxList<String> ownedItems = <String>[].obs;
  final RxMap<String, int> adProgressMap = <String, int>{}.obs;
  final RxInt selectedCategory = 0.obs;
  final RxBool isLoading = false.obs;

  // Add a property to highlight a specific item in the shop
  final RxString highlightItemId = "".obs;

  // Filter variables
  final RxList<ItemType> itemTypes = <ItemType>[].obs;
  final RxInt selectedType = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadShopItems();
    _loadUserItems();
  }

  // Load all shop items
  Future<void> _loadShopItems() async {
    isLoading.value = true;

    try {
      // First, create categories list for the tabs
      itemTypes.value = [
        ItemType.hair,
        ItemType.eyes,
        ItemType.mouth,
        ItemType.outfit,
        ItemType.accessory,
        ItemType.background,
        ItemType.special,
      ];

      // Generate shop items based on the asset repository
      final items = <ShopItem>[];

      // Process each category in the asset repo
      for (int categoryIndex = 0;
          categoryIndex < assetRepo.listItemMaker.length;
          categoryIndex++) {
        final category = assetRepo.listItemMaker[categoryIndex];
        final itemType = _mapCategoryToItemType(categoryIndex);

        // Skip if category doesn't have items or is not in our shop categories
        if (category.listItem == null || !itemTypes.contains(itemType)) {
          continue;
        }

        // Process all items in this category
        for (int itemIndex = 1;
            itemIndex < category.listItem!.length;
            itemIndex++) {
          final assetPath = category.listItem![itemIndex];

          // Use asset_categoryIndex_itemIndex format for IDs
          final String itemId = 'asset_${categoryIndex}_${itemIndex}';
          final String itemName = _generateItemName(itemType, itemIndex);

          // Determine if this item should be locked or premium
          bool isLocked = false;
          int adsToUnlock = 0;
          bool isPremium = false;
          int price = 0;
          ItemCategory itemCategory;

          // Lock every third item starting from index 2
          if (itemIndex % 3 == 2) {
            isLocked = true;
            adsToUnlock = 1 + (itemIndex % 3); // 1-3 ads to unlock
            itemCategory = ItemCategory.rare;
          }
          // Make every fifth item premium
          else if (itemIndex % 5 == 0) {
            isPremium = true;
            price = 200 + (itemIndex * 10);
            itemCategory = ItemCategory.legendary;
          }
          // Make some items free
          else if (itemIndex % 4 == 0) {
            price = 0;
            itemCategory = ItemCategory.free;
          }
          // Regular priced items
          else {
            price = 50 + (itemIndex * 5);
            itemCategory = ItemCategory.basic;
          }

          items.add(ShopItem(
            id: itemId,
            name: itemName,
            assetPath: assetPath,
            description:
                'A beautiful ${itemType.toString().split('.').last} for your avatar',
            type: itemType,
            category: itemCategory,
            price: price,
            isLocked: isLocked,
            adsToUnlock: adsToUnlock,
            isPremium: isPremium,
          ));
        }
      }

      // Set shop items
      shopItems.value = items;
    } catch (e) {
      print("Error loading shop items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Load user's unlocked/owned items
  Future<void> _loadUserItems() async {
    try {
      // In a real app, load these from SharedPreferences or a database
      final prefs = await SharedPreferences.getInstance();

      // Load unlocked items (via ads)
      unlockedItems.value = prefs.getStringList('unlocked_items') ?? [];

      // Load purchased items (with coins)
      ownedItems.value = prefs.getStringList('owned_items') ?? [];

      // Load ad progress for locked items
      final adProgressJson = prefs.getString('ad_progress') ?? '{}';
      final Map<String, dynamic> decodedMap = json.decode(adProgressJson);

      adProgressMap.value =
          decodedMap.map((key, value) => MapEntry(key, value as int));
    } catch (e) {
      print("Error loading user items: $e");
    }
  }

  // Check if user owns an item
  bool userOwnsItem(String itemId) {
    return ownedItems.contains(itemId) || unlockedItems.contains(itemId);
  }

  // Get ad watch progress for an item
  int getAdProgressForItem(String itemId, int totalRequired) {
    return adProgressMap[itemId] ?? 0;
  }

  // Modified purchase item function to refresh avatar maker
  Future<bool> purchaseItem(ShopItem item) async {
    if (userOwnsItem(item.id)) {
      return true; // Already owned
    }

    if (rewardsController.totalCoins.value < item.price) {
      Get.snackbar(
        "Not Enough Coins",
        "You need ${item.price - rewardsController.totalCoins.value} more coins to buy this item.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    try {
      // Spend coins
      final success = await rewardsController.spendCoins(item.price);

      if (success) {
        // Add to owned items
        final newOwned = [...ownedItems, item.id];
        ownedItems.value = newOwned;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('owned_items', newOwned);

        // Track purchase for achievements
        final achievementController = Get.find<AchievementController>();
        await achievementController.trackItemPurchased();

        // Refresh the avatar maker's locked items
        try {
          final makerController = Get.find<PageMakerCharacterController>();
          makerController.refreshLockedStatus();
        } catch (e) {
          print("PageMakerCharacterController not found: $e");
        }

        Get.snackbar(
          "Purchase Successful",
          "You've purchased ${item.name}!",
          backgroundColor: Color(0xFF9F6CF7).withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        return true;
      }

      return false;
    } catch (e) {
      print("Error purchasing item: $e");
      Get.snackbar(
        "Purchase Failed",
        "There was an error processing your purchase.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  // Modified ad watching function to refresh avatar maker
  Future<bool> watchAdForItem(ShopItem item) async {
    if (userOwnsItem(item.id)) {
      return true; // Already owned
    }

    if (!item.isLocked) {
      return false; // Not unlockable via ads
    }

    try {
      // Show ad here - for demo we'll just simulate ad completion
      // In a real app, you'd integrate with AdMob, Unity Ads, etc.

      // Wait a moment to simulate ad playing
      await Future.delayed(Duration(seconds: 1));

      // Update progress
      int currentProgress = adProgressMap[item.id] ?? 0;
      currentProgress++;

      // Update progress map
      final newProgressMap = Map<String, int>.from(adProgressMap);
      newProgressMap[item.id] = currentProgress;
      adProgressMap.value = newProgressMap;

      // Save progress
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ad_progress', json.encode(newProgressMap));

      // Track ad watched for achievements
      final achievementController = Get.find<AchievementController>();
      await achievementController.trackAdWatched();

      // Check if fully unlocked
      if (currentProgress >= item.adsToUnlock) {
        // Unlock the item
        final newUnlocked = [...unlockedItems, item.id];
        unlockedItems.value = newUnlocked;

        // Save to SharedPreferences
        await prefs.setStringList('unlocked_items', newUnlocked);

        // Track item unlocked for achievements
        await achievementController.trackItemUnlocked();

        // Refresh the avatar maker's locked items
        try {
          final makerController = Get.find<PageMakerCharacterController>();
          makerController.refreshLockedStatus();
        } catch (e) {
          print("PageMakerCharacterController not found: $e");
        }

        Get.snackbar(
          "Item Unlocked!",
          "You've unlocked ${item.name}!",
          backgroundColor: Color(0xFF9F6CF7).withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Ad Watched",
          "Progress: $currentProgress/${item.adsToUnlock} ads watched to unlock ${item.name}",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }

      return true;
    } catch (e) {
      print("Error watching ad: $e");
      return false;
    }
  }

  // Method to find an item by ID
  ShopItem? findItemById(String id) {
    try {
      return shopItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter items by type
  List<ShopItem> getItemsByType(ItemType type) {
    return shopItems.where((item) => item.type == type).toList();
  }

  // Set the selected category
  void setSelectedType(int index) {
    if (index >= 0 && index < itemTypes.length) {
      selectedType.value = index;
    }
  }

  // Helper functions
  ItemType _mapCategoryToItemType(int categoryIndex) {
    // Map your asset repository categories to ItemType
    // Adjust this to match your own category structure
    switch (categoryIndex) {
      case 0:
        return ItemType.hair;
      case 1:
        return ItemType.eyes;
      case 2:
        return ItemType.mouth;
      case 3:
        return ItemType.outfit;
      case 4:
        return ItemType.accessory;
      case 5:
        return ItemType.background;
      default:
        return ItemType.special;
    }
  }

  String _generateItemName(ItemType type, int index) {
    // Generate names based on item type
    final typeStr = type.toString().split('.').last;
    final adjectives = [
      'Cool',
      'Stylish',
      'Cute',
      'Elegant',
      'Fancy',
      'Magical',
      'Bright',
      'Dark',
      'Mysterious',
      'Happy'
    ];

    final adj = adjectives[index % adjectives.length];

    switch (type) {
      case ItemType.hair:
        return '$adj Hairstyle ${index + 1}';
      case ItemType.eyes:
        return '$adj Eyes ${index + 1}';
      case ItemType.mouth:
        return '$adj Smile ${index + 1}';
      case ItemType.outfit:
        return '$adj Outfit ${index + 1}';
      case ItemType.accessory:
        return '$adj Accessory ${index + 1}';
      case ItemType.background:
        return '$adj Background ${index + 1}';
      case ItemType.frame:
        return '$adj Frame ${index + 1}';
      case ItemType.sticker:
        return '$adj Sticker ${index + 1}';
      case ItemType.special:
        return '$adj Special Item ${index + 1}';
    }
  }
}
// Add this to ShopPage to highlight items when directed from avatar maker
