import 'dart:math';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Obx(() => Text(
              controller.isEditing.value ? "Edit Avatar" : "Create Avatar",
              style: TextStyle(
                color: controller.accentColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: controller.accentColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: controller.accentColor),
            onPressed: () => _showHelpBottomSheet(context),
          ),
        ],
      ),
      body: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return Column(
            children: [
              SizedBox(height: 10.h),
              _buildAvatarCanvas(),
              SizedBox(height: 15.h),
              _buildActionsRow(),
              SizedBox(height: 10.h),
              _buildCategorySelector(),
              SizedBox(height: 10.h),
              _buildItemGrid(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarCanvas() {
    return Container(
      width: 280.w,
      height: 280.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: controller.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: RepaintBoundary(
              key: controller.globalKey,
              child: Obx(() => Stack(
                    alignment: Alignment.center,
                    children: controller.listImageLayer
                        .map((widget) => widget)
                        .toList(),
                  )),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Obx(() => _buildActionButton(
                  icon: "assets/ui_icon/ic_camera.png",
                  onTap: () => controller.saveOrUpdateAvatar(),
                  backgroundColor: controller.accentColor,
                  isLoading: controller.isLoading.value,
                )),
          ),
          Obx(() {
            if (controller.isEditing.value) {
              return Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: controller.accentColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(
                    "Editing Avatar ${(controller.editingIndex.value + 1)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required Function() onTap,
    required Color backgroundColor,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.w,
                  ),
                )
              : Image.asset(
                  icon,
                  width: 20.w,
                  height: 20.w,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  Widget _buildActionsRow() {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildActionCard(
              title: "Layers",
              icon: "assets/ui_icon/ic_layer.png",
              onTap: () => _showLayersBottomSheet(Get.context!),
              color: controller.secondaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildActionCard(
              title: "Clear",
              icon: "assets/ui_icon/ic_erase.png",
              onTap: () => controller.clearAvatar(),
              color: controller.primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildActionCard(
              title: "Random",
              icon: "assets/ui_icon/ic_random.png",
              onTap: () => controller.randomizeAvatar(),
              color: controller.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String icon,
    required Function() onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  icon,
                  width: 15.w,
                  height: 15.w,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              style: TextStyle(
                color: controller.textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 90.h,
      child: AnimationLimiter(
        child: GetBuilder<PageMakerCharacterController>(
          id: 'category_selector',
          builder: (controller) {
            final listItemMaker = controller.assetRepo.listItemMaker;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              itemCount: listItemMaker.length,
              itemBuilder: (context, index) {
                // Gunakan GetX value stream untuk memastikan update reaktif
                return Obx(() => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 300),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              controller.changePartSelected(index);
                              // Tambahkan update() untuk memaksa refresh UI
                              controller
                                  .update(['category_selector', 'item_grid']);
                            },
                            child: Container(
                              width: 70.w,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: controller.partSelected.value == index
                                    ? controller.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.w,
                                    child: Stack(
                                      children: [
                                        Image.asset(Part15_class15.asset_0),
                                        Image.asset(listItemMaker[index]
                                            .listItem![0]
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Part ${index + 1}",
                                    style: TextStyle(
                                      color:
                                          controller.partSelected.value == index
                                              ? Colors.white
                                              : controller.textColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemGrid() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            Expanded(
              child: AnimationLimiter(
                child: Obx(() {
                  final listItemMaker = controller.assetRepo.listItemMaker;
                  final selectedItem = controller.selectedItemsPerCategory[
                          controller.partSelected.value] ??
                      0;

                  return GridView.builder(
                    padding: EdgeInsets.all(15.w),
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.w,
                    ),
                    itemCount: listItemMaker[controller.partSelected.value]
                        .listItem!
                        .length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: Duration(milliseconds: 300),
                        columnCount: 4,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () => controller.selectItem(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedItem == index
                                      ? controller.primaryColor.withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                    color: selectedItem == index
                                        ? controller.primaryColor
                                        : Colors.grey.withOpacity(0.2),
                                    width: selectedItem == index ? 2 : 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      Part15_class15.asset_0,
                                    ),
                                    Image.asset(
                                      listItemMaker[
                                              controller.partSelected.value]
                                          .listItem![index],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLayersBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manage Layers",
                    style: TextStyle(
                      color: controller.textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: controller.textColor),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.listImageLayer.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(5.w),
                            child: controller.listImageLayer[index],
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Layer ${index + 1}",
                                  style: TextStyle(
                                    color: controller.textColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Part ${index + 1} Component",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.clearLayer(index);
                              Get.back();
                            },
                            icon: Icon(Icons.delete_outline,
                                color: Colors.red[300]),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.primaryColor,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: Text("Done"),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _showHelpBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Avatar Maker Guide",
              style: TextStyle(
                color: controller.accentColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            _buildInfoItem(
              icon: Icons.category,
              title: "Select Parts",
              description: "Choose different parts from the categories below",
            ),
            _buildInfoItem(
              icon: Icons.grid_view,
              title: "Customize Items",
              description: "Tap on items in the grid to apply them",
            ),
            _buildInfoItem(
              icon: Icons.save,
              title: "Save Your Creation",
              description: "Use the camera button to save your avatar",
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: controller.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: controller.accentColor,
              size: 20.w,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: controller.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey,
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
