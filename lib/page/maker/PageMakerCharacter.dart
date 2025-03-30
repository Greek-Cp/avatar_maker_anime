import 'dart:math';
import 'dart:math' as math;
import 'dart:ui';

import 'package:avatar_maker/component/ComponentButton.dart';
import 'package:avatar_maker/controller/AvatarController.dart';
import 'package:avatar_maker/page/repo/AssetRepo.dart';
import 'package:avatar_maker/util/ColorApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../component/ComponentItem.dart';
import '../../assets_class/Part15_class15.dart';

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
    final saveController = Get.find<SaveAvatarController>();

    if (index >= 0 && index < saveController.listAvatar.length) {
      saveController.loadAvatarForEditing(index);
      Get.to(() => PageMakerCharacter());
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

    // Setup animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Inisialisasi map untuk menyimpan item yang dipilih
    final itemMakerLength = assetRepo.listItemMaker.length;
    for (int i = 0; i < itemMakerLength; i++) {
      selectedItemsPerCategory[i] = 0;
    }

    // Check if we're editing an existing avatar
    if (saveAvatarController.editingIndex.value >= 0) {
      // We're in editing mode
      isEditing.value = true;
      editingIndex.value = saveAvatarController.editingIndex.value;

      // Load the avatar being edited
      final avatarToEdit = saveAvatarController.currentEditingAvatar;
      if (avatarToEdit.isNotEmpty) {
        listAvatarLayerString.value = List.from(avatarToEdit);
        listImageLayer.value = List.generate(
            avatarToEdit.length,
            (index) => Image.asset(
                  avatarToEdit[index],
                  fit: BoxFit.fitWidth,
                ));

        // Identifikasi item yang dipilih untuk setiap kategori
        _identifySelectedItems();
      }
    } else {
      // Initialize with random character
      _initializeRandomAvatar();
    }
  }

  // Identifikasi item yang dipilih untuk setiap kategori berdasarkan avatar yang dimuat
  void _identifySelectedItems() {
    for (int categoryIndex = 0;
        categoryIndex < assetRepo.listItemMaker.length;
        categoryIndex++) {
      final categoryItems = assetRepo.listItemMaker[categoryIndex].listItem!;
      final currentAsset = listAvatarLayerString[categoryIndex];

      for (int itemIndex = 0; itemIndex < categoryItems.length; itemIndex++) {
        if (categoryItems[itemIndex] == currentAsset) {
          selectedItemsPerCategory[categoryIndex] = itemIndex;
          break;
        }
      }
    }
  }

  void _initializeRandomAvatar() {
    final listItemMaker = assetRepo.listItemMaker;

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
        // Update existing avatar
        await saveAvatarController.updateAvatarAtIndex(
            editingIndex.value, listAvatarLayerString.toList());
      } else {
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

class PageMakerCharacter extends StatelessWidget {
  static String routeName = "/PageMakerCharacter";

  final PageMakerCharacterController controller =
      Get.put(PageMakerCharacterController());

  final RxBool isMenuOpen = false.obs;

  @override
  Widget build(BuildContext context) {
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
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
              return Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 18.sp),
            width: 40.w,
            height: 40.w,
          ),
          Text(
            "Create Your Avatar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
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
            onTap: () => _showHelpDialog(Get.context!),
            child: Icon(Icons.help_outline_rounded,
                color: Colors.white, size: 18.sp),
            width: 40.w,
            height: 40.w,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Character Preview Section - Larger portion
        Expanded(
          flex: 6, // Increased size
          child: _buildCharacterPreview(),
        ),
        // Customization Area
        Expanded(
          flex: 5,
          child: _buildCustomizationArea(),
        ),
      ],
    );
  }

  Widget _buildCharacterPreview() {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Character and Background - Positioned higher but still touching bottom
          Positioned.fill(
            bottom: -20.h, // Shift character up while keeping it attached
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Larger character
                _buildCharacterWithBackground(),
              ],
            ),
          ),

          // Menu Button (3 dots)
          Positioned(
            top: 10.h,
            right: 16.w,
            child: _buildMenuButton(),
          ),

          // Action menu - only visible when menu is open
          Obx(() => isMenuOpen.value
              ? Positioned(
                  top: 70.h,
                  right: 16.w,
                  child: _buildActionMenu(),
                )
              : SizedBox.shrink()),

          // Camera button
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: _buildGlassButton(
              onTap: () => controller.saveOrUpdateAvatar(),
              width: 56.w,
              height: 56.w,
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
                        width: 24.w,
                        height: 24.w,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 24.w,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton() {
    return _buildGlassButton(
      onTap: () {
        isMenuOpen.value = !isMenuOpen.value;
        HapticFeedback.lightImpact();
      },
      width: 45.w,
      height: 45.w,
      child: Icon(
        Icons.more_vert,
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }

  Widget _buildActionMenu() {
    return Container(
      width: 65.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
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
        borderRadius: BorderRadius.circular(16.r),
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
                  _showLayersBottomSheet(Get.context!);
                },
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
              ),
              Divider(height: 1, color: Colors.white.withOpacity(0.3)),
              _buildMenuOption(
                icon: Icons.cleaning_services_outlined,
                label: "Clear",
                color: Color(0xFFFF89B3),
                onTap: () {
                  isMenuOpen.value = false;
                  controller.clearAvatar();
                },
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
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24.sp,
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterWithBackground() {
    return Container(
      width: 280.w, // Larger container for character
      height: 280.w,
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
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFB5C4FF).withOpacity(0.3),
            ),
          ),

          // Reflection
          Positioned(
            top: 50.h,
            child: Container(
              width: 200.w,
              height: 100.h,
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
          ..._buildSparkles(),
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

  List<Widget> _buildSparkles() {
    final random = math.Random(42);
    return List.generate(6, (index) {
      final size = 4.0 + random.nextDouble() * 4.0;
      final angle = index * (math.pi * 2 / 6);
      final radius = 120.0 + random.nextDouble() * 20.0;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;

      return Positioned(
        left: 140.w + x,
        top: 120.w + y,
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
                width: size.w,
                height: size.w,
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

  Widget _buildCustomizationArea() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
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
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: Column(
              children: [
                _buildDragHandle(),
                _buildCategorySelector(),
                Expanded(
                  child: _buildItemsGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 70.h,
      child: AnimationLimiter(
        child: GetBuilder<PageMakerCharacterController>(
          id: 'category_selector',
          builder: (controller) {
            final listItemMaker = controller.assetRepo.listItemMaker;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
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
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: GestureDetector(
                            onTap: () {
                              controller.changePartSelected(index);
                              controller
                                  .update(['category_selector', 'item_grid']);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 80.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
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
                                borderRadius: BorderRadius.circular(14.r),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    color: Colors.transparent,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30.w,
                                          height: 30.w,
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
                                        SizedBox(height: 4.h),
                                        Text(
                                          "Part ${index + 1}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
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

  Widget _buildItemsGrid() {
    return AnimationLimiter(
      child: Obx(() {
        final listItemMaker = controller.assetRepo.listItemMaker;
        final selectedItem = controller
                .selectedItemsPerCategory[controller.partSelected.value] ??
            0;

        return GridView.builder(
          padding: EdgeInsets.all(12.w),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.w,
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
                        borderRadius: BorderRadius.circular(12.r),
                        color: selectedItem == index
                            ? Color(0xFFFF6CAB).withOpacity(0.6)
                            : Colors.white.withOpacity(0.4),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
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
                                    top: 5.h,
                                    right: 5.w,
                                    child: Container(
                                      width: 16.w,
                                      height: 16.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Color(0xFFFF6CAB),
                                          size: 12.sp,
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
          borderRadius: BorderRadius.circular(16.r),
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
          borderRadius: BorderRadius.circular(16.r),
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
    Get.bottomSheet(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              // Glass background
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
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
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
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
                  _buildDragHandle(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Manage Layers",
                          style: TextStyle(
                            color: Color(0xFF666CFF),
                            fontSize: 20.sp,
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
                    width: 100.w,
                    height: 100.w,
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
                            alignment: Alignment
                                .bottomCenter, // Important: Bottom alignment
                            children: controller.listImageLayer
                                .map((widget) => widget)
                                .toList(),
                          )),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Divider
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    height: 1.h,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(height: 16.h),

                  // Layers list
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: _buildLayerTile(index),
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
                    padding: EdgeInsets.all(20.w),
                    child: _buildGlassButton(
                      onTap: () => Get.back(),
                      width: double.infinity,
                      height: 50.h,
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
                          fontSize: 16.sp,
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

  Widget _buildLayerTile(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white.withOpacity(0.4),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                // Layer thumbnail - using your specified code
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Stack(
                      alignment: Alignment
                          .bottomCenter, // Important: Bottom alignment here too
                      children: [controller.listImageLayer[index]],
                    ),
                  ),
                ),
                SizedBox(width: 15.w),

                // Layer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Color(0xFFB0A6FF).withOpacity(0.4),
                        ),
                        child: Text(
                          "Layer ${index + 1}",
                          style: TextStyle(
                            color: Color(0xFF666CFF),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "Part ${index + 1} Component",
                        style: TextStyle(
                          color: Color(0xFF666CFF).withOpacity(0.8),
                          fontSize: 13.sp,
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
                    size: 22.sp,
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
    Get.bottomSheet(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              // Glass background
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
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
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
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
                  _buildDragHandle(),
                  SizedBox(height: 10.h),

                  // Title with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB0A6FF).withOpacity(0.4),
                        ),
                        child: Icon(
                          Icons.emoji_objects_rounded,
                          color: Color(0xFF666CFF),
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "How To Play",
                        style: TextStyle(
                          color: Color(0xFF666CFF),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),

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
                          ),
                          _buildHelpItem(
                            icon: Icons.grid_view_rounded,
                            title: "Select Items",
                            description: "Tap on items to add to your avatar",
                            color: Color(0xFFB0A6FF),
                          ),
                          _buildHelpItem(
                            icon: Icons.more_vert,
                            title: "Menu Options",
                            description: "Tap menu for more features",
                            color: Color(0xFFFF89B3),
                          ),
                          _buildHelpItem(
                            icon: Icons.camera_alt_rounded,
                            title: "Save Avatar",
                            description: "Capture and save your creation",
                            color: Color(0xFFFF6CAB),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Got it button
                  _buildGlassButton(
                    onTap: () => Get.back(),
                    width: double.infinity,
                    height: 50.h,
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
                        fontSize: 16.sp,
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
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          // Icon with glass effect
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: color.withOpacity(0.5),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF666CFF),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: Color(0xFF666CFF).withOpacity(0.7),
                    fontSize: 14.sp,
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
