import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../assets_class/Part15_class15.dart';
import '../PageBase.dart';

class AvatarController extends GetxController {
  // Avatar yang sedang ditampilkan di editor
  RxList<String> currentAvatar = <String>[].obs;

  // Metode untuk memuat avatar ke editor
  void loadAvatar(List<String> avatarLayers) {
    // Menyimpan data avatar
    currentAvatar.value = List<String>.from(avatarLayers);
    update();

    // Arahkan pengguna ke halaman editor dengan data
    Get.to(() => PageMakerCharacter());
  }

  // Memuat avatar dari SaveAvatarController untuk diedit
  void loadAvatarForEdit(int index) {
    try {
      final saveController = Get.find<SaveAvatarController>();
      print("Loading avatar for edit, index: $index");

      if (index >= 0 && index < saveController.listAvatar.length) {
        // First mark the avatar for editing in the SaveAvatarController
        saveController.loadAvatarForEditing(index);

        // Make sure to properly remove any existing controller instance
        if (Get.isRegistered<PageMakerCharacterController>()) {
          Get.delete<PageMakerCharacterController>();
        }

        // Register the controller before navigation
        Get.put(PageMakerCharacterController());

        // Get the tab controller to change the tab
        final tabController = Get.find<AppTabController>();

        // Switch to the first tab (Create tab - index 0)
        tabController.changeTab(0);

        // Navigate back to the main page if needed
        if (Get.currentRoute != PageBase.routeName) {
          Get.until((route) => route.settings.name == PageBase.routeName);
        }

        // Show success message
        Get.snackbar("Avatar Loaded", "Your avatar is ready for editing",
            backgroundColor: Color(0xFF9F6CF7).withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 2));
      }
    } catch (e) {
      print("Error in loadAvatarForEdit: $e");
      Get.snackbar("Error", "Failed to load avatar for editing",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
    }
  }
}

class PageMakerCharacterController extends GetxController
    with SingleGetTickerProviderMixin {
  final assetRepo = Get.find<AssetRepo>();
  final saveAvatarController = Get.find<SaveAvatarController>();
  final avatarController = Get.find<AvatarController>();

  // Reactive state variables
  final RxInt partSelected = 0.obs;
  final RxInt itemSelected = 0.obs;
  final RxList<Widget> listImageLayer = <Widget>[].obs;
  final RxList<String> listAvatarLayerString = <String>[].obs;
  final RxList<int> randNumber = <int>[].obs;
  final RxBool isEditing = false.obs;
  final RxInt editingIndex = (-1).obs;
  final RxBool isLoading = false.obs;

  // Map untuk menyimpan item yang dipilih untuk setiap kategori
  final RxMap<int, int> selectedItemsPerCategory = <int, int>{}.obs;

  // Animation controller
  late AnimationController animationController;

  // Global key for capturing widget as image
  final globalKey = GlobalKey();

  // Theme colors
  final Color primaryColor = Color(0xFFFA9ECC);
  final Color secondaryColor = Color(0xFFFFC0D9);
  final Color accentColor = Color(0xFFAA336A);
  final Color backgroundColor = Color(0xFFFFF0F5);
  final Color textColor = Color(0xFF4A4A4A);

  @override
  void onInit() {
    super.onInit();

    print("PageMakerCharacterController: onInit called");

    // Setup animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Initialize map for selected items
    final itemMakerLength = assetRepo.listItemMaker.length;
    for (int i = 0; i < itemMakerLength; i++) {
      selectedItemsPerCategory[i] = 0;
    }

    // Check if editing mode - pull data from SaveAvatarController
    print(
        "SaveAvatarController editing index: ${saveAvatarController.editingIndex.value}");
    print(
        "SaveAvatarController current editing avatar: ${saveAvatarController.currentEditingAvatar}");

    if (saveAvatarController.editingIndex.value >= 0) {
      // We're in editing mode
      print("EDIT MODE DETECTED!");
      isEditing.value = true;
      editingIndex.value = saveAvatarController.editingIndex.value;

      // Load the avatar being edited
      final avatarToEdit = saveAvatarController.currentEditingAvatar;
      if (avatarToEdit.isNotEmpty) {
        print(
            "Loading avatar data for editing, layers: ${avatarToEdit.length}");

        // Make sure listAvatarLayerString is initialized with the correct length
        listAvatarLayerString.value = List<String>.from(avatarToEdit);

        // Initialize listImageLayer with the proper images
        listImageLayer.value = List<Widget>.generate(
          avatarToEdit.length,
          (index) => Image.asset(
            avatarToEdit[index],
            fit: BoxFit.fitWidth,
          ),
        );

        // Identify selected items for each category
        _identifySelectedItems();
        print("Selected items per category: $selectedItemsPerCategory");
      } else {
        print("ERROR: avatarToEdit is empty!");
        _initializeRandomAvatar(); // Fallback to random if edit data is missing
      }
    } else {
      print("NORMAL MODE - Initializing random avatar");
      // Initialize with random character
      _initializeRandomAvatar();
    }
  }

  // Identifikasi item yang dipilih untuk setiap kategori berdasarkan avatar yang dimuat
  void _identifySelectedItems() {
    for (int categoryIndex = 0;
        categoryIndex < assetRepo.listItemMaker.length;
        categoryIndex++) {
      if (categoryIndex < listAvatarLayerString.length) {
        final categoryItems = assetRepo.listItemMaker[categoryIndex].listItem!;
        final currentAsset = listAvatarLayerString[categoryIndex];

        bool foundMatch = false;
        for (int itemIndex = 0; itemIndex < categoryItems.length; itemIndex++) {
          if (categoryItems[itemIndex] == currentAsset) {
            selectedItemsPerCategory[categoryIndex] = itemIndex;
            foundMatch = true;
            print(
                "Category $categoryIndex: selected item $itemIndex (${categoryItems[itemIndex]})");
            break;
          }
        }

        if (!foundMatch) {
          print(
              "WARNING: No match found for asset ${currentAsset} in category $categoryIndex");
          selectedItemsPerCategory[categoryIndex] = 0; // Default to first item
        }
      }
    }

    // Update the currently selected item based on the current category
    itemSelected.value = selectedItemsPerCategory[partSelected.value] ?? 0;
  }

  void _initializeRandomAvatar() {
    final listItemMaker = assetRepo.listItemMaker;
    randNumber.clear(); // Clear previous random numbers if any

    listImageLayer.value = List.generate(listItemMaker.length, (index) {
      int tnd = Random().nextInt(listItemMaker[index].listItem!.length);
      randNumber.add(tnd);

      // Simpan item yang dipilih secara acak
      selectedItemsPerCategory[index] = tnd;

      return Image.asset(
        listItemMaker[index].listItem![tnd],
        fit: BoxFit.fitWidth,
      );
    });

    listAvatarLayerString.value = List.generate(listImageLayer.length,
        (index) => listItemMaker[index].listItem![randNumber[index]]);
  }

  void changePartSelected(int index) {
    partSelected.value = index;

    // Update item yang dipilih berdasarkan kategori yang dipilih
    itemSelected.value = selectedItemsPerCategory[index] ?? 0;
  }

  void selectItem(int index) {
    final listItemMaker = assetRepo.listItemMaker;

    // Simpan item yang dipilih untuk kategori saat ini
    selectedItemsPerCategory[partSelected.value] = index;

    // Update nilai itemSelected untuk highlight di UI
    itemSelected.value = index;

    // Update layer dan string avatar
    listAvatarLayerString[partSelected.value] =
        listItemMaker[partSelected.value].listItem![index].toString();

    listImageLayer[partSelected.value] =
        Image.asset(listItemMaker[partSelected.value].listItem![index]);
  }

  // Mendapatkan item yang dipilih untuk kategori tertentu
  int getSelectedItemForCategory(int categoryIndex) {
    return selectedItemsPerCategory[categoryIndex] ?? 0;
  }

  void randomizeAvatar() {
    final listItemMaker = assetRepo.listItemMaker;

    for (int index = 0; index < listImageLayer.length; index++) {
      if (listItemMaker[index].listItem != null) {
        int tnd = Random().nextInt(listItemMaker[index].listItem!.length);

        // Simpan item yang dipilih secara acak
        selectedItemsPerCategory[index] = tnd;

        listImageLayer[index] =
            Image.asset(listItemMaker[index].listItem![tnd]);
        listAvatarLayerString[index] =
            listItemMaker[index].listItem![tnd].toString();
      }
    }

    // Update item yang dipilih untuk kategori saat ini
    itemSelected.value = selectedItemsPerCategory[partSelected.value] ?? 0;

    animationController.forward(from: 0.0);
  }

  void clearAvatar() {
    for (int index = 0; index < listImageLayer.length; index++) {
      listAvatarLayerString[index] = "assets/assets0sv1.png";
      listImageLayer[index] = Image.asset("assets/assets0sv1.png");

      // Reset item yang dipilih
      selectedItemsPerCategory[index] = 0;
    }

    // Update item yang dipilih untuk kategori saat ini
    itemSelected.value = 0;
  }

  void clearLayer(int index) {
    listImageLayer[index] = Image.asset("assets/assets0sv1.png");
    listAvatarLayerString[index] = "assets/assets0sv1.png";

    // Reset item yang dipilih untuk kategori ini
    selectedItemsPerCategory[index] = 0;

    // Jika kategori yang dibersihkan adalah kategori saat ini, update itemSelected
    if (index == partSelected.value) {
      itemSelected.value = 0;
    }
  }

  Future<void> saveOrUpdateAvatar() async {
    isLoading.value = true;

    try {
      if (isEditing.value && editingIndex.value >= 0) {
        print("Updating existing avatar at index ${editingIndex.value}");
        // Update existing avatar
        await saveAvatarController.updateAvatarAtIndex(
            editingIndex.value, listAvatarLayerString.toList());
      } else {
        print("Saving new avatar");
        // Save new avatar
        await saveAvatarController.saveAvatar(listAvatarLayerString.toList());
      }

      // Save image to gallery
      await saveWidgetAsImage();

      // Show success message
      Get.snackbar(
        isEditing.value ? "Avatar Updated!" : "Avatar Saved!",
        isEditing.value
            ? "Your avatar has been updated successfully"
            : "Your creation has been saved to your gallery",
        icon: Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: accentColor,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(15),
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print("Error saving avatar: $e");
      Get.snackbar(
        "Error",
        "Failed to save your avatar. Please try again.",
        icon: Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Uint8List> captureWidget() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      print("Error capturing widget: $e");
      return Uint8List(0);
    }
  }

  Future<void> saveWidgetAsImage() async {
    try {
      Uint8List imageBytes = await captureWidget();
      if (imageBytes.isNotEmpty) {
        final result = await ImageGallerySaver.saveImage(imageBytes);
        if (result['isSuccess']) {
          print('Image saved successfully!');
        } else {
          print('Failed to save image.');
        }
      }
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class PageMakerCharacter extends StatefulWidget {
  static String routeName = "/PageMakerCharacter";

  @override
  State<PageMakerCharacter> createState() => _PageMakerCharacterState();
}

class _PageMakerCharacterState extends State<PageMakerCharacter>
    with SingleTickerProviderStateMixin {
  final PageMakerCharacterController controller =
      Get.find<PageMakerCharacterController>();
  final SaveAvatarController controllerSave = Get.find<SaveAvatarController>();

  final RxBool isMenuOpen = false.obs;

  // Animation controllers for bubbles
  late AnimationController _bubbleAnimationController;
  late List<Bubble> bubbles;

  @override
  void initState() {
    super.initState();

    // Initialize bubble animation controller
    _bubbleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    )..repeat();

    // Generate random bubbles
    bubbles = List.generate(20, (index) => Bubble());
  }

  @override
  void dispose() {
    _bubbleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(size),
              Expanded(
                child: Stack(
                  children: [
                    // Animated bubbles in background
                    ...generateBubbles(size),

                    // Main content
                    _buildMainContent(size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> generateBubbles(Size size) {
    return List.generate(bubbles.length, (index) {
      return AnimatedBuilder(
        animation: _bubbleAnimationController,
        builder: (context, child) {
          final bubble = bubbles[index];

          // Calculate bubble's current position
          final progress =
              (_bubbleAnimationController.value + bubble.offset!) % 1.0;
          final yPos =
              size.height - progress * (size.height + bubble.size! * 2);
          final xOffset = math.sin((progress * bubble.curve!) * math.pi * 2) *
              bubble.waveWidth!;

          return Positioned(
            left: (bubble.position! * size.width) + xOffset,
            top: yPos,
            child: Opacity(
              opacity: bubble.opacity!,
              child: Container(
                width: bubble.size,
                height: bubble.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      bubble.color!.withOpacity(0.7),
                      bubble.color!.withOpacity(0.3),
                    ],
                    stops: [0.4, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: bubble.color!.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
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

  Widget _buildAppBar(Size size) {
    final buttonSize = size.width * 0.1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: buttonSize * 0.45),
            width: buttonSize,
            height: buttonSize,
          ),
          Text(
            "Create Your Avatar",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.055,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.purple.withOpacity(0.3),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          _buildGlassButton(
            onTap: () => _showHelpDialog(context),
            child: Icon(Icons.help_outline_rounded,
                color: Colors.white, size: buttonSize * 0.45),
            width: buttonSize,
            height: buttonSize,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(Size size) {
    // Calculate responsive dimensions
    final characterPreviewFlex = 6;
    final customizationAreaFlex = 5;
    final totalFlex = characterPreviewFlex + customizationAreaFlex;

    return Column(
      children: [
        // Character Preview Section - Larger portion
        Container(
          height: size.height * (characterPreviewFlex / totalFlex) * 0.75,
          child: _buildCharacterPreview(size),
        ),
        // Customization Area
        Expanded(
          child: _buildCustomizationArea(size),
        ),
      ],
    );
  }

  Widget _buildCharacterPreview(Size size) {
    final iconSize = size.width * 0.06;
    final menuButtonSize = size.width * 0.11;
    final cameraButtonSize = size.width * 0.14;
    final characterSize = size.width * 0.8;

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Character and Background - Positioned higher but still touching bottom
          Positioned.fill(
            bottom: -20, // Shift character up while keeping it attached
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Larger character
                _buildCharacterWithBackground(characterSize),
              ],
            ),
          ),

          // Menu Button (3 dots)
          Positioned(
            top: 10,
            right: 16,
            child: _buildGlassButton(
              onTap: () {
                isMenuOpen.value = !isMenuOpen.value;
                HapticFeedback.lightImpact();
              },
              width: menuButtonSize,
              height: menuButtonSize,
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),

          // Action menu - only visible when menu is open
          Obx(() => isMenuOpen.value
              ? Positioned(
                  top: 70,
                  right: 16,
                  child: _buildActionMenu(size),
                )
              : SizedBox.shrink()),

          // Camera button
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildGlassButton(
              onTap: () => controller.saveOrUpdateAvatar(),
              width: cameraButtonSize,
              height: cameraButtonSize,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF89B3).withOpacity(0.8),
                  Color(0xFFFF6CAB).withOpacity(0.6),
                ],
              ),
              child: Obx(
                () => controller.isLoading.value
                    ? SizedBox(
                        width: cameraButtonSize * 0.43,
                        height: cameraButtonSize * 0.43,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: cameraButtonSize * 0.43,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(Size size) {
    final menuWidth = size.width * 0.16;
    final iconSize = size.width * 0.06;
    final fontSize = size.width * 0.025;

    return Container(
      width: menuWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuOption(
                icon: Icons.layers,
                label: "Layers",
                color: Color(0xFF84CAFF),
                onTap: () {
                  isMenuOpen.value = false;
                  _showLayersBottomSheet(context);
                },
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              Divider(height: 1, color: Colors.white.withOpacity(0.3)),
              _buildMenuOption(
                icon: Icons.refresh,
                label: "Random",
                color: Color(0xFFB0A6FF),
                onTap: () {
                  isMenuOpen.value = false;
                  controller.randomizeAvatar();
                },
                iconSize: iconSize,
                fontSize: fontSize,
              ),
              Divider(height: 1, color: Colors.white.withOpacity(0.3)),
              _buildMenuOption(
                icon: Icons.cleaning_services_outlined,
                label: "Clear",
                color: Color(0xFFFF89B3),
                onTap: () {
                  isMenuOpen.value = false;
                  controller.clearAvatar();

                  controllerSave.clearEditingState();
                  controller.isEditing.value = false;
                },
                iconSize: iconSize,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required Color color,
    required Function() onTap,
    required double iconSize,
    required double fontSize,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: iconSize,
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterWithBackground(double size) {
    final innerCircleSize = size * 0.79;
    final reflectionWidth = size * 0.71;
    final reflectionHeight = size * 0.36;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFFB0A6FF).withOpacity(0.8),
            Color(0xFF9387FF).withOpacity(0.5),
          ],
          stops: [0.4, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9387FF).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner circle
          Container(
            width: innerCircleSize,
            height: innerCircleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFB5C4FF).withOpacity(0.3),
            ),
          ),

          // Reflection
          Positioned(
            top: size * 0.18,
            child: Container(
              width: reflectionWidth,
              height: reflectionHeight,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          // Character layers - Positioned to align at bottom
          Positioned.fill(
            child: RepaintBoundary(
              key: controller.globalKey,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: _buildLayersWithAnimation(),
              ),
            ),
          ),

          // Sparkles
          ..._buildSparkles(size),
        ],
      ),
    );
  }

  List<Widget> _buildLayersWithAnimation() {
    return List.generate(controller.listImageLayer.length, (index) {
      return Obx(() {
        final itemKey = '${controller.listAvatarLayerString[index]}';
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.3, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuart,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<String>(itemKey),
            child: controller.listImageLayer[index],
          ),
        );
      });
    });
  }

  List<Widget> _buildSparkles(double characterSize) {
    final random = math.Random(42);
    return List.generate(6, (index) {
      final size = characterSize * (0.014 + random.nextDouble() * 0.014);
      final angle = index * (math.pi * 2 / 6);
      final radius = characterSize * (0.43 + random.nextDouble() * 0.07);
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;

      return Positioned(
        left: characterSize * 0.5 + x,
        top: characterSize * 0.43 + y,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.5, end: 1.0),
          duration: Duration(milliseconds: 1000 + index * 200),
          builder: (context, double value, child) {
            final opacity = math.sin((value + index * 0.2) * math.pi).abs();
            // Ensure opacity is between 0.0 and 1.0
            final safeOpacity = opacity.clamp(0.0, 1.0);
            return Opacity(
              opacity: safeOpacity,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
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

  Widget _buildCustomizationArea(Size size) {
    final borderRadius = size.width * 0.08;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.6),
            Colors.white.withOpacity(0.4),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Column(
              children: [
                _buildDragHandle(size),
                _buildCategorySelector(size),
                Expanded(
                  child: _buildItemsGrid(size),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
      child: Container(
        width: size.width * 0.1,
        height: size.height * 0.005,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(size.width * 0.025),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(Size size) {
    final itemHeight = size.height * 0.086;

    return Container(
      height: itemHeight,
      child: AnimationLimiter(
        child: GetBuilder<PageMakerCharacterController>(
          id: 'category_selector',
          builder: (controller) {
            final listItemMaker = controller.assetRepo.listItemMaker;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.032),
              itemCount: listItemMaker.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 400),
                  child: SlideAnimation(
                    horizontalOffset: 30.0,
                    child: FadeInAnimation(
                      child: Obx(() {
                        final isSelected =
                            controller.partSelected.value == index;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.013),
                          child: GestureDetector(
                            onTap: () {
                              controller.changePartSelected(index);
                              controller
                                  .update(['category_selector', 'item_grid']);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: size.width * 0.21,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.037),
                                color: isSelected
                                    ? Color(0xFFB5A6FF)
                                    : Colors.white.withOpacity(0.4),
                                border: Border.all(
                                  color: Colors.white
                                      .withOpacity(isSelected ? 0.7 : 0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.037),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.021),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: size.width * 0.08,
                                          height: size.width * 0.08,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                  Part15_class15.asset_0),
                                              Image.asset(listItemMaker[index]
                                                  .listItem![0]),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.005),
                                        Text(
                                          "Part ${index + 1}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * 0.032,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemsGrid(Size size) {
    return AnimationLimiter(
      child: Obx(() {
        final listItemMaker = controller.assetRepo.listItemMaker;
        final selectedItem = controller
                .selectedItemsPerCategory[controller.partSelected.value] ??
            0;

        return GridView.builder(
          padding: EdgeInsets.all(size.width * 0.032),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: size.width * 0.021,
            mainAxisSpacing: size.width * 0.021,
          ),
          itemCount:
              listItemMaker[controller.partSelected.value].listItem!.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: Duration(milliseconds: 400),
              columnCount: 4,
              child: ScaleAnimation(
                duration: Duration(milliseconds: 300),
                child: FadeInAnimation(
                  duration: Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () {
                      // Add vibration feedback on tap
                      HapticFeedback.lightImpact();
                      controller.selectItem(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * 0.032),
                        color: selectedItem == index
                            ? Color(0xFFFF6CAB).withOpacity(0.6)
                            : Colors.white.withOpacity(0.4),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * 0.032),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(Part15_class15.asset_0),
                                Image.asset(
                                    listItemMaker[controller.partSelected.value]
                                        .listItem![index]),
                                if (selectedItem == index)
                                  Positioned(
                                    top: size.width * 0.013,
                                    right: size.width * 0.013,
                                    child: Container(
                                      width: size.width * 0.042,
                                      height: size.width * 0.042,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Color(0xFFFF6CAB),
                                          size: size.width * 0.032,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildGlassButton({
    required Widget child,
    required Function()? onTap,
    required double width,
    required double height,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.4),
          gradient: gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.3),
                ],
              ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(width * 0.4),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

  void _showLayersBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Get.bottomSheet(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              // Glass background
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.08),
                    topRight: Radius.circular(size.width * 0.08),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.4),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.08),
                    topRight: Radius.circular(size.width * 0.08),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),

              // Content
              Column(
                children: [
                  _buildDragHandle(size),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.053),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Layers",
                          style: TextStyle(
                            color: Color(0xFF666CFF),
                            fontSize: size.width * 0.053,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Color(0xFF666CFF)),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  ),

                  // Avatar preview with correct positioning
                  Container(
                    width: size.width * 0.27,
                    height: size.width * 0.27,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB0A6FF).withOpacity(0.3),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9387FF).withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Obx(() => Stack(
                            alignment: Alignment.bottomCenter,
                            children: controller.listImageLayer
                                .map((widget) => widget)
                                .toList(),
                          )),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // Divider
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.11),
                    height: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Layers list
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.053),
                        itemCount: controller.listImageLayer.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(milliseconds: 400),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.012),
                                  child: _buildLayerTile(index, size),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  // Done button
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.053),
                    child: _buildGlassButton(
                      onTap: () => Get.back(),
                      width: double.infinity,
                      height: size.height * 0.062,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF9387FF).withOpacity(0.8),
                          Color(0xFF666CFF).withOpacity(0.6),
                        ],
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.042,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildLayerTile(int index, Size size) {
    final thumbnailSize = size.width * 0.13;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * 0.042),
        color: Colors.white.withOpacity(0.4),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size.width * 0.042),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(size.width * 0.027),
            child: Row(
              children: [
                // Layer thumbnail
                Container(
                  width: thumbnailSize,
                  height: thumbnailSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * 0.027),
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.027),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [controller.listImageLayer[index]],
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.04),

                // Layer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.021,
                          vertical: size.height * 0.004,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.021),
                          color: Color(0xFFB0A6FF).withOpacity(0.4),
                        ),
                        child: Text(
                          "Layer ${index + 1}",
                          style: TextStyle(
                            color: Color(0xFF666CFF),
                            fontSize: size.width * 0.032,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.006),
                      Text(
                        "Part ${index + 1} Component",
                        style: TextStyle(
                          color: Color(0xFF666CFF).withOpacity(0.8),
                          fontSize: size.width * 0.034,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Clear layer button
                IconButton(
                  onPressed: () {
                    controller.clearLayer(index);
                    Get.back();
                  },
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFF6CAB),
                    size: size.width * 0.058,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Get.bottomSheet(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.all(size.width * 0.053),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              // Glass background
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.08),
                    topRight: Radius.circular(size.width * 0.08),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.4),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.08),
                    topRight: Radius.circular(size.width * 0.08),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),

              // Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(size),
                  SizedBox(height: size.height * 0.012),

                  // Title with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.027),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB0A6FF).withOpacity(0.4),
                        ),
                        child: Icon(
                          Icons.emoji_objects_rounded,
                          color: Color(0xFF666CFF),
                          size: size.width * 0.064,
                        ),
                      ),
                      SizedBox(width: size.width * 0.027),
                      Text(
                        "How To Play",
                        style: TextStyle(
                          color: Color(0xFF666CFF),
                          fontSize: size.width * 0.058,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),

                  // Instructions
                  AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: Duration(milliseconds: 600),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          _buildHelpItem(
                            icon: Icons.style_rounded,
                            title: "Choose Category",
                            description: "Select different parts to customize",
                            color: Color(0xFF84CAFF),
                            size: size,
                          ),
                          _buildHelpItem(
                            icon: Icons.grid_view_rounded,
                            title: "Select Items",
                            description: "Tap on items to add to your avatar",
                            color: Color(0xFFB0A6FF),
                            size: size,
                          ),
                          _buildHelpItem(
                            icon: Icons.more_vert,
                            title: "Menu Options",
                            description: "Tap menu for more features",
                            color: Color(0xFFFF89B3),
                            size: size,
                          ),
                          _buildHelpItem(
                            icon: Icons.camera_alt_rounded,
                            title: "Save Avatar",
                            description: "Capture and save your creation",
                            color: Color(0xFFFF6CAB),
                            size: size,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // Got it button
                  _buildGlassButton(
                    onTap: () => Get.back(),
                    width: double.infinity,
                    height: size.height * 0.062,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF9387FF).withOpacity(0.8),
                        Color(0xFF666CFF).withOpacity(0.6),
                      ],
                    ),
                    child: Text(
                      "Got it!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.042,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required Size size,
  }) {
    final iconSize = size.width * 0.12;

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      child: Row(
        children: [
          // Icon with glass effect
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * 0.032),
              color: color.withOpacity(0.5),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.032),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: size.width * 0.058,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.04),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF666CFF),
                    fontSize: size.width * 0.042,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  description,
                  style: TextStyle(
                    color: Color(0xFF666CFF).withOpacity(0.7),
                    fontSize: size.width * 0.037,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Bubble class for animated bubbles
class Bubble {
  double? size;
  double? position;
  double? opacity;
  double? offset;
  double? waveWidth;
  double? curve;
  Color? color;

  Bubble() {
    final random = Random();

    // Random properties for variety
    size = 5 + random.nextDouble() * 15;
    position = random.nextDouble();
    opacity = 0.3 + random.nextDouble() * 0.3;
    offset = random.nextDouble();
    waveWidth = 10 + random.nextDouble() * 20;
    curve = 0.5 + random.nextDouble();

    // Random color from a pastel palette
    final colors = [
      Color(0xFFFA9ECC), // Pink
      Color(0xFF9F6CF7), // Purple
      Color(0xFF84CAFF), // Blue
      Color(0xFFFFB347), // Orange
      Color(0xFF9387FF), // Lavender
    ];

    color = colors[random.nextInt(colors.length)];
  }
}
