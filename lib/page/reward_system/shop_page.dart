// Shop Page UI
import 'dart:math';

import 'package:avatar_maker/page/reward_system/daily_reward_system.dart';
import 'package:avatar_maker/page/reward_system/model/shop_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopPage extends StatelessWidget {
  final shopController = Get.find<ShopController>();
  final rewardsController = Get.find<RewardsController>();

  static var routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shopController.rewardsController.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorations
            ..._buildBackgroundElements(),

            // Main content
            Column(
              children: [
                _buildHeader(),
                SizedBox(height: 10),
                _buildCategoryTabs(),
                SizedBox(height: 15),
                Expanded(
                  child: Obx(
                    () => shopController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              shopController.rewardsController.accentColor,
                            ),
                          ))
                        : _buildItemGrid(),
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
            icon: Icon(Icons.arrow_back_ios_rounded,
                color: shopController.rewardsController.accentColor),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              "Magic Shop",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: shopController.rewardsController.accentColor,
              ),
            ),
          ),
          // Coins display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.amber,
                width: 1.5,
              ),
            ),
            child: Obx(() => Row(
                  children: [
                    Icon(Icons.monetization_on_rounded,
                        color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text(
                      "${rewardsController.totalCoins.value}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Obx(() => Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: shopController.itemTypes.length,
            itemBuilder: (context, index) {
              final isSelected = shopController.selectedType.value == index;
              final type = shopController.itemTypes[index];

              return GestureDetector(
                onTap: () => shopController.setSelectedType(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              shopController.rewardsController.purpleColor,
                              shopController.rewardsController.blueColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: shopController
                                  .rewardsController.purpleColor
                                  .withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      _getCategoryName(type),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  String _getCategoryName(ItemType type) {
    switch (type) {
      case ItemType.hair:
        return "Hair";
      case ItemType.eyes:
        return "Eyes";
      case ItemType.mouth:
        return "Mouth";
      case ItemType.outfit:
        return "Outfits";
      case ItemType.accessory:
        return "Accessories";
      case ItemType.background:
        return "Backgrounds";
      case ItemType.frame:
        return "Frames";
      case ItemType.sticker:
        return "Stickers";
      case ItemType.special:
        return "Special";
      default:
        return "Other";
    }
  }

  Widget _buildItemGrid() {
    return Obx(() {
      final selectedType =
          shopController.itemTypes[shopController.selectedType.value];
      final items = shopController.getItemsByType(selectedType);

      if (items.isEmpty) {
        return Center(
          child: Text(
            "No items available in this category",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          // Check if this item is highlighted (from avatar maker)
          final isHighlighted = shopController.highlightItemId.value == item.id;

          // If highlighted, add special effects
          if (isHighlighted) {
            // Reset highlight after 3 seconds to prevent it staying highlighted forever
            Future.delayed(Duration(seconds: 3), () {
              shopController.highlightItemId.value = "";
            });

            return AnimatedScale(
              scale: 1.05,
              duration: Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: shopController.rewardsController.accentColor
                          .withOpacity(0.7),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: _buildShopItemCard(item),
              ),
            );
          }

          return _buildShopItemCard(item);
        },
      );
    });
  }

  Widget _buildShopItemCard(ShopItem item) {
    final isOwned = shopController.userOwnsItem(item.id);
    final adProgress = isOwned
        ? item.adsToUnlock
        : shopController.getAdProgressForItem(item.id, item.adsToUnlock);

    // Card header background color based on category
    Color headerColor;
    String categoryLabel;
    IconData categoryIcon;

    switch (item.category) {
      case ItemCategory.free:
        headerColor = Colors.green;
        categoryLabel = "FREE";
        categoryIcon = Icons.redeem_rounded;
        break;
      case ItemCategory.rare:
        headerColor = shopController.rewardsController.blueColor;
        categoryLabel = "RARE";
        categoryIcon = Icons.star_rounded;
        break;
      case ItemCategory.legendary:
        headerColor = shopController.rewardsController.orangeColor;
        categoryLabel = "LEGENDARY";
        categoryIcon = Icons.auto_awesome_rounded;
        break;
      default:
        headerColor = shopController.rewardsController.purpleColor;
        categoryLabel = "BASIC";
        categoryIcon = Icons.style_rounded;
    }

    if (item.isPremium) {
      headerColor = shopController.rewardsController.accentColor;
      categoryLabel = "PREMIUM";
      categoryIcon = Icons.diamond_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: headerColor.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with category
          Container(
            height: 28,
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(categoryIcon, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  categoryLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Item image
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Item preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item.assetPath,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Locked overlay
                  if (item.isLocked && !isOwned)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(height: 5),
                          if (item.adsToUnlock > 0)
                            Text(
                              "Watch ${item.adsToUnlock - adProgress} ads",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),

                  // "Owned" overlay
                  if (isOwned)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "OWNED",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Item name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Price or ad progress
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                if (item.isLocked && !isOwned)
                  Expanded(
                    child: _buildAdProgress(adProgress, item.adsToUnlock),
                  )
                else if (!isOwned && item.price > 0)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.monetization_on_rounded,
                            color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          "${item.price}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  )
                else if (!isOwned)
                  Expanded(
                    child: Text(
                      "FREE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Action button
                if (!isOwned) _buildActionButton(item, isOwned, adProgress),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdProgress(int current, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ad Progress",
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 3),
        Row(
          children: List.generate(total, (index) {
            return Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < current
                    ? shopController.rewardsController.orangeColor
                    : Colors.grey[300],
                border: Border.all(
                  color: index < current
                      ? shopController.rewardsController.orangeColor
                      : Colors.grey[400]!,
                  width: 1,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActionButton(ShopItem item, bool isOwned, int adProgress) {
    if (isOwned) {
      return SizedBox();
    }

    if (item.isLocked) {
      // Ad unlock button
      return ElevatedButton(
        onPressed: () => _watchAdForItem(item),
        style: ElevatedButton.styleFrom(
          backgroundColor: shopController.rewardsController.orangeColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size(40, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Icon(Icons.movie_rounded, size: 16),
      );
    } else if (item.price == 0) {
      // Free item - Get button
      return ElevatedButton(
        onPressed: () => _getItemForFree(item),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size(40, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Icon(Icons.download_rounded, size: 16),
      );
    } else {
      // Paid item - Buy button
      return ElevatedButton(
        onPressed: () => _buyItem(item),
        style: ElevatedButton.styleFrom(
          backgroundColor: shopController.rewardsController.purpleColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size(40, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Icon(Icons.shopping_cart_rounded, size: 16),
      );
    }
  }

  void _watchAdForItem(ShopItem item) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Watch Ad to Unlock",
          style: TextStyle(
            color: shopController.rewardsController.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.assetPath,
              height: 120,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15),
            Text(
              "Watch an ad to make progress towards unlocking ${item.name}.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              shopController.watchAdForItem(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: shopController.rewardsController.orangeColor,
              foregroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.movie_rounded, size: 16),
                SizedBox(width: 5),
                Text("Watch Ad"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getItemForFree(ShopItem item) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Get Free Item",
          style: TextStyle(
            color: shopController.rewardsController.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.assetPath,
              height: 120,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15),
            Text(
              "Do you want to add ${item.name} to your collection for free?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              shopController.purchaseItem(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text("Get it Now"),
          ),
        ],
      ),
    );
  }

  void _buyItem(ShopItem item) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Confirm Purchase",
          style: TextStyle(
            color: shopController.rewardsController.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.assetPath,
              height: 120,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 15),
            Text(
              "Do you want to buy ${item.name} for ${item.price} coins?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.monetization_on_rounded,
                    color: Colors.amber, size: 20),
                SizedBox(width: 5),
                Obx(() => Text(
                      "Your balance: ${rewardsController.totalCoins.value}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: rewardsController.totalCoins.value >= item.price
                            ? Colors.green
                            : Colors.red,
                      ),
                    )),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: rewardsController.totalCoins.value >= item.price
                ? () {
                    Get.back();
                    shopController.purchaseItem(item);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: shopController.rewardsController.purpleColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_rounded, size: 16),
                SizedBox(width: 5),
                Text("Buy Now"),
              ],
            ),
          ),
        ],
      ),
    );
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
                shopController.rewardsController.purpleColor.withOpacity(0.3),
                shopController.rewardsController.purpleColor.withOpacity(0.0),
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
                shopController.rewardsController.orangeColor.withOpacity(0.3),
                shopController.rewardsController.orangeColor.withOpacity(0.0),
              ],
              radius: 0.7,
            ),
          ),
        ),
      ),

      // Small decorative circles
      ...List.generate(10, (index) {
        final random = Random(index * 5);
        final size = 6.0 + random.nextDouble() * 10.0;
        final xPos = random.nextDouble() * Get.width;
        final yPos = random.nextDouble() * Get.height;
        final color = [
          shopController.rewardsController.primaryColor,
          shopController.rewardsController.secondaryColor,
          shopController.rewardsController.purpleColor,
          shopController.rewardsController.blueColor,
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
